;; fennel-ls: macro-file

(fn tx! [& args]
  "Mixed sequential and associative tables at compile time. Because the Neovim ecosystem loves them but Fennel has no neat way to express them (which I think is fine, I don't like the idea of them in general)."
  (let [to-merge (when (table? (. args (length args)))
                    (table.remove args))]
    (if to-merge
      (do
        (each [key value (pairs to-merge)]
          (tset args key value))
        args)
      args)))
(fn call-require! [req method & args]
  "require the module and call the method on it with the given arguments"
  `(let [f# (require ,req)]
    ((. f# ,method) ,(unpack args))))

:return {
  : tx!
  : call-require!
}