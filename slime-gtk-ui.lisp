;;;
;;; slime-gtk-ui.lisp -- defslimefun for SLIME.
;;;

(defpackage :slime-gtk-ui
  (:use :cl #+slime :swank)
  (:export
   :run-describe-ui
   :run-sexp-browser-ui
   :run-class-browser-ui
   :run-function-browser-ui))

(in-package :slime-gtk-ui)

(swank::defslimefun run-describe-ui (string)
  (slime-gtk-ui.describe:run (read-from-string string)))

(swank::defslimefun run-sexp-browser-ui (string)
  (slime-gtk-ui.sexp-browser:run (read-from-string string) "S-expression browser" string #'identity))

(swank::defslimefun run-class-browser-ui (string)
  (slime-gtk-ui.class-browser:run (read-from-string string)))

(swank::defslimefun run-function-browser-ui (string)
  (slime-gtk-ui.function-browser:run (read-from-string string)))
