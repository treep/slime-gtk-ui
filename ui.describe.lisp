;;;
;;; ui.describe.lisp -- simple window with describe text, used in `!describe' command.
;;;

(defpackage :slime-gtk-ui.describe
  (:use :cl :gtk :gobject)
  (:export :run))

(in-package :slime-gtk-ui.describe)

(defun describe-to-string (object)
  (with-output-to-string (stream)
    (describe object stream)))

(defun run (object)
  (with-simple-main-window (window :title "Describe object")
    (let-uis ((buffer       'text-buffer :text (describe-to-string object))
              (scrolled     'scrolled-window :hscrollbar-policy :automatic :vscrollbar-policy :automatic)
              ((v scrolled) 'text-view :buffer buffer :wrap-mode :word)
              ((box window) 'v-box))
      (box-pack-start box scrolled))))
