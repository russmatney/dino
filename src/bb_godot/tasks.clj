(ns bb-godot.tasks
  (:require
   [babashka.process :as p]
   [babashka.fs :as fs]
   [clojure.java.io :as io]
   [clojure.string :as string]))

;; TODO move pods to bb.edn style
(require '[babashka.pods :as pods])
(pods/load-pod 'org.babashka/filewatcher "0.0.1")
(require '[pod.babashka.filewatcher :as fw])

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
                                    ;; TODO escape stringified bodies for osascript's standards
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
                            ;; TODO use dynamic global bool to print all notifs
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
  (let [files (->> dir .list vec (map #(io/file dir %))
                   (filter #(ext-match? % "aseprite")))]
    (doall (map pixels-file files))))

(defn pixels
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
  "Defaults to watching an ./assets dir and calling (all)"
  [& args]
  (-> (Runtime/getRuntime)
      (.addShutdownHook (Thread. #(println "\nShut down watcher."))))

  (let [dir (or (some-> args first) "assets")
        dir (str (cwd) "/" dir)]
    (println "Watching:" dir)
    (if (fs/exists? dir)
      (do
        (fw/watch
          dir
          (fn [event]
            (if (re-seq #"_sheet" (:path event))
              (println "Change event for" (:path event) "[bb] Ignoring.")
              (do
                (println "Change event for" (:path event) "[bb] Processing.")
                (pixels-file (:path event))
                ;; (all)
                )))
          {:delay-ms 50})

        @(promise))
      (println (str "dir: " dir "  does not exist.")))))
