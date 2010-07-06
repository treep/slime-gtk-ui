;;;
;;; slime-gtk-ui.asd -- ASDF definition.
;;;

#-slime
(when (find-package :swank)
  (push :slime *features*))

(defsystem :slime-gtk-ui
  :name        :slime-gtk-ui
  :version     "0.1"
  :description "SLIME (GTK) UI tools."
  :depends-on  (:cl-gtk2-gtk :iterate #+sbcl :sb-introspect #+slime :swank)
  :serial      t
  :components (#+sbcl (:file "sb-introspect")
               #-sbcl (:file "xref") ;; TODO, for other CL impl's
               (:file "object-reader")
               (:file "gtk-macros")
               (:file "ui.describe")
               (:file "ui.sexp-browser")
               (:file "ui.class-browser")
               (:file "ui.function-browser")
               #+slime (:file "slime-gtk-ui")
               #+slime (:static-file "slime-gtk-ui.el")))
