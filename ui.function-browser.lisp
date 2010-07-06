;;;
;;; ui.function-browser.lisp -- run sexp-browser with given f-tree, used in `!function' command.
;;;

(defpackage :slime-gtk-ui.function-browser
  (:use :cl #+sbcl :sb-introspect :gtk :gobject)
  (:export :run))

(in-package :slime-gtk-ui.function-browser)

(defun to-function (object)
  (etypecase object
    (cons     (when (eq (first object) 'quote)
                (eval `(function ,(second object)))))
    (symbol   (eval `(function ,object)))
    (function object)))

(defun run (object)
  (slime-gtk-ui.sexp-browser:run (to-function object)
                                 "Function flow graph browser"
                                 (write-to-string (to-function object))
                                 #'find-function-callees/recur))
