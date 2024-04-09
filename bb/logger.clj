(ns logger)

;; https://gist.github.com/borkdude/c97da85da67c7bcc5671765aef5a89ad

(defmacro log [& msgs]
  (let [m    (meta &form)
        _ns  (ns-name *ns*) ;; can also be used for logging
        file *file*]
    `(binding [*out* *err*] ;; or bind to (io/writer log-file)
       (println (str ~file ":"
                     ~(:line m) ":"
                     ~(:column m))
                ~@msgs))))

;; (ns bar (:require bb-godot.logger))

;; (logger/log "what goes on here")
