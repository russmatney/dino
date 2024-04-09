(ns tasks
  (:require
   [babashka.process :as p]
   [babashka.fs :as fs]
   [babashka.tasks :as bb.tasks]
   [clojure.java.io :as io]
   [clojure.string :as string]))

(require '[babashka.pods :as pods])
(pods/load-pod 'org.babashka/filewatcher "0.0.1")
(require '[pod.babashka.filewatcher :as fw])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn shell-and-log
  ([x] (shell-and-log {} x))
  ([opts x]
   (println x)
   (when (seq opts) (println opts))
   (bb.tasks/shell opts x)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fs extensions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn replace-ext [p ext]
  (let [old-ext (fs/extension p)]
    (string/replace (str p) old-ext ext)))

(defn ext-match? [p ext]
  (= (fs/extension p) ext))

(defn cwd []
  (.getCanonicalPath (io/file ".")))

(defn abs-path [p]
  (if-let [path (->> p (io/file (cwd)) (.getAbsolutePath))]
    (do
      (println "Found path:" path)
      (io/file path))
    (println "Miss for path:" p)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; notify
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn expand
  [path & parts]
  (let [path (apply str path parts)]
    (->
      @(p/process (str "zsh -c 'echo -n " path "'")
                  {:out :string})
      :out)))

(defn is-mac? []
  (string/includes? (expand "$OSTYPE") "darwin21"))

(comment
  (is-mac?))

(defn notify
  ([notice]
   (cond (string? notice) (notify notice nil)

         (map? notice)
         (let [subject (some notice [:subject :notify/subject])
               body    (some notice [:body :notify/body])]
           (notify subject body notice))

         :else
         (notify "Malformed ralphie.notify/notify call"
                 "Expected string or map.")))
  ([subject body & args]
   (let [opts             (or (some-> args first) {})
         print?           (:notify/print? opts)
         replaces-process (some opts [:notify/id :replaces-process :notify/replaces-process])
         exec-strs
         (if (is-mac?)
           ["osascript" "-e" (str "display notification \""
                                  (cond
                                    (string? body) body
                                    (not body)     "no body"
                                    :else          "unsupported body")
                                  "\""
                                  (when subject
                                    (str " with title \"" subject "\"")))]
           (cond->
               ["notify-send.py" subject]
             body (conj body)
             replaces-process
             (conj "--replaces-process" replaces-process)))
         _                (when print?
                            (println subject (when body (str "\n" body))))
         proc             (p/process (conj exec-strs) {:out :string})]

     ;; we only check when --replaces-process is not passed
     ;; ... skips error messages if bad data is passed
     ;; ... also not sure when these get dealt with. is this a memory leak?
     (when-not replaces-process
       (-> proc p/check :out))
     nil)))

(comment
  (notify {:subject "subj" :body {:value "v" :label "laaaa"}})
  (notify {:subject "subj" :body "BODY"}))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pixels
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn aseprite-bin-path []
  (if (is-mac?)
    "/Applications/Aseprite.app/Contents/MacOS/aseprite"
    "aseprite"))

(defn pixels-file [path]
  (if (ext-match? path "aseprite")
    (do
      (notify "Processing aseprite file" (str path) {:notify/id (str path)})
      (let [result
            (->
              ^{:out :string}
              (p/$ ~(aseprite-bin-path) -b ~(str path)
                   --format json-array
                   --sheet
                   ~(-> path (replace-ext "png")
                        (string/replace ".png" "_sheet.png"))
                   --sheet-type horizontal
                   --list-tags
                   --list-slices
                   --list-layers)
              p/check :out)]
        (when false #_verbose? (println result))))
    (println "Skipping path without aseprite extension" path)))

(defn pixels-dir [dir]
  (println "Checking pixels-dir" (str dir))
  (let [files          (->> dir .list vec (map #(io/file dir %)))
        aseprite-files (->> files (filter #(ext-match? % "aseprite")))
        dirs           (->> files (filter fs/directory?))]
    (doall (map pixels-file aseprite-files))
    (doall (map pixels-dir dirs))))

(defn pixels
  "Attempts to find `*.aseprite` files to process with `pixels-file`.
  Defaults to looking in an `assets/` dir."
  ([] (pixels nil))
  ([& args]
   (let [dir (or (some-> args first) "assets")]
     (if-let [p (abs-path dir)]
       (if (.isDirectory p)
         (pixels-dir p)
         (pixels-file p))
       (println "Error asserting dir" dir)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; All/Watch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn all [& args]
  (pixels args)
  (println "--finished (all)--"))

(defn watch
  "Defaults to watching the current working directory."
  [& _args]
  (-> (Runtime/getRuntime)
      (.addShutdownHook (Thread. #(println "\nShut down watcher."))))
  (fw/watch (cwd) (fn [event]
                    (let [ext (-> event :path fs/extension)]
                      (when (#{"aseprite"} ext)
                        (if (re-seq #"_sheet" (:path event))
                          (println "Change event for" (:path event) "[bb] Ignoring.")
                          (do
                            (println "Change event for" (:path event) "[bb] Processing.")
                            (pixels-file (:path event)))))))
            {:delay-ms 100})
  @(promise))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deps
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DEPRECATED
(defn input->godot-dep [input & dir-prefix]
  (let [[addon-name repo-id] input
        addon-name           (if (keyword? addon-name)
                               (name addon-name)
                               addon-name)
        repo-id              (cond (keyword? repo-id)
                                   (if (namespace repo-id)
                                     (str (namespace repo-id) "/" (name repo-id))
                                     (name repo-id))
                                   (string? repo-id)

                                   repo-id)
        addon-path (cond
                     (re-seq #"/addons/" repo-id)
                     repo-id

                     :else
                     (str repo-id "/addons/" addon-name))
        dir-prefix (string/join
                     "/"
                     (conj dir-prefix (fs/home)))]
    {:addon-name         addon-name
     :addon-path         addon-path
     :project-addon-path (str "./addons/" addon-name)
     :symlink-target     (str dir-prefix "/" addon-path)
     :repo-id            repo-id
     :repo-path          (str dir-prefix "/" repo-id)}))

(defn git-status-addons [addons & dir-prefix]
  (doall
    (->>
      addons
      (map #(apply input->godot-dep % dir-prefix))
      (map :repo-path)
      (into #{})
      (filter fs/directory?)
      (map (fn [repo-path]
             (bb.tasks/shell {:dir repo-path} "git fetch origin")
             (shell-and-log {:dir repo-path} "git status -sb"))))))

(defn dir-exists-addons [addons & dir-prefix]
  (doall
   (->>
    addons
    (map #(apply input->godot-dep % dir-prefix))
    (map :repo-path)
    (into #{})
    (remove fs/directory?)
    (map (fn [repo-path]
           (println "repo-path does not exist:" repo-path))))))

(defn addons [addons & dir-prefix]
  (println "status checking addons: " addons)

  (apply dir-exists-addons addons dir-prefix)
  (apply git-status-addons addons dir-prefix))

;; probably should clone directly into the repo via :project-addon-path
(defn clone-addons [addons & dir-prefix]
  (doall
    (->>
      addons
      (map #(apply input->godot-dep % dir-prefix))
      (group-by (fn [x] (:repo-path x)))
      (map (fn [[path xs]]
             [path (first xs)]))
      (map second)
      (remove (comp fs/directory? :repo-path))
      (map (fn [{:keys [repo-path repo-id]}]
             (shell-and-log (str "gh repo clone " repo-id " " repo-path)))))))

(defn install-addons [addons & dir-prefix]
  (shell-and-log "mkdir -p addons")
  (println addons)
  (doall
    (->>
      addons
      (map #(apply input->godot-dep % dir-prefix))
      (map
        (fn [{:keys [project-addon-path symlink-target]}]
          (when (or (fs/sym-link? project-addon-path)
                    (fs/exists? project-addon-path))
            (println "deleting existing folder at target" project-addon-path)
            (fs/delete-tree project-addon-path)
            (fs/delete-if-exists project-addon-path)
            (println "Success!"))
          (println "creating symlink from" project-addon-path "to" symlink-target)
          (fs/create-sym-link project-addon-path symlink-target))))))

(comment
  (fs/exists? (str (fs/home) "/russmatney/beatemup-city/addons/core/navi"))
  (fs/sym-link? (str (fs/home) "/russmatney/beatemup-city/addons/core/navi"))
  (->>
    {:navi :russmatney/dino}
    (map input->godot-dep)
    (map
      (fn [{:keys [project-addon-path symlink-target]}]
        (when (fs/exists? project-addon-path)
          (println "deleting existing folder at target" project-addon-path)
          (fs/delete-tree project-addon-path)
          (fs/delete-if-exists project-addon-path)
          (println "Success!"))
        (println "creating symlink from" project-addon-path "to" symlink-target)))))


(defn install-script-templates [paths & dir-prefix]
  (shell-and-log "mkdir -p script_templates")
  (doall
    (->>
      paths
      (map
        (fn [path]
          (let [local-templates-dir "./script_templates"
                path                (->> (fs/home)
                                         (conj dir-prefix)
                                         reverse
                                         (cons path)
                                         reverse
                                         (string/join "/"))]
            (println "copying templates from" path)
            (if (not (fs/directory? path))
              (println "path is not a directory", path)
              (doall
                (->> (fs/list-dir path)
                     (map (fn [f]
                            (println "copying template" f)
                            (fs/copy f (str local-templates-dir "/.") {:replace-existing true}))))))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Build
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def build-dir "dist")

(defn export
  ([] (export nil))
  ([export-name] (export export-name nil))
  ([export-name opts]
   (let [debug?      (:debug? opts)
         export-name (or export-name "dino-linux")
         build-dir   (str "dist/" export-name)
         executable  (case export-name
                       "dino-linux" "dino.x86_64")]
     (println "export" export-name build-dir)
     (-> (p/$ mkdir -p ~build-dir) p/check)
     (shell-and-log (str "godot --headless "
                         (if debug? "--export-debug" "--export-release")
                         " " export-name " " build-dir "/" executable)))))

(defn build-web
  ([] (build-web nil))
  ([export-name]
   (let [export-name (or export-name "dino")
         build-dir   (str "dist/" export-name)]
     (println "build-web" export-name build-dir)
     (-> (p/$ mkdir -p ~build-dir) p/check)
     (shell-and-log (str "godot --headless --export " export-name "-web " build-dir "/index.html")))))

(defn zip []
  (shell-and-log (str "zip " build-dir  ".zip " build-dir "/*")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deploy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn deploy-web [s3-bucket]
  (shell-and-log (str "aws s3 sync " build-dir "/ " s3-bucket)))
