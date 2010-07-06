;;;
;;; gtk-macros.lisp -- some macros for CL-GTK2.
;;;

(in-package :gtk)

(defmacro let-ui (ui-description &body body)
  "Bind ui name in UI-DESCRIPTION to class instance from UI-DESCRIPTION."
 `(let ((,(first ui-description) (make-instance ,@(rest ui-description))))
    ,@body))

(defmacro let-uis (ui-descriptions &body body)
  "Bind each ui name in UI-DESCRIPTIONS to class instance from UI-DESCRIPTIONS.
If ui-name element is list of ui-name and some other symbol then generate 
\(container-add ...) form for ui-name and that symbol."
  (let (to-add-to-container)
    `(let* ,(mapcar #'(lambda (description)
                        (let ((ui     (first description))
                              (params (rest description)))
                          (etypecase ui
                            (symbol `(,ui (make-instance ,@params)))
                            (cons    (push ui to-add-to-container)
                                     `(,(first ui) (make-instance ,@params))))))
                    ui-descriptions)
       ,@(mapcar #'(lambda (ui)
                     `(container-add ,@(nreverse ui)))
                 to-add-to-container)
       ,@body)))

(defmacro with-simple-main-window ((var &key (title "Untitled")
                                             (type :toplevel)
                                             (window-position :center)
                                             (default-width 400)
                                             (default-height 600))
                                        &body body)
 `(within-main-loop
    (let-ui (,var 'gtk-window :type  ,type
                              :title ,title
                              :window-position ,window-position
                              :default-width   ,default-width
                              :default-height  ,default-height)
      ,@body
      (connect-signal ,var "destroy" (lambda (w) (declare (ignore w)) (leave-gtk-main)))
      (widget-show ,var))))

(defmacro make-scrolling-search-box (v-box search-box search-entry search-button scroll &key (expand nil))
 `(progn
    (box-pack-start ,v-box ,search-box :expand ,expand)
    (box-pack-start ,search-box ,search-entry)
    (box-pack-start ,search-box ,search-button :expand ,expand)
    (box-pack-start ,v-box ,scroll)))

(export 'let-ui)
(export 'let-uis)
(export 'with-simple-main-window)
(export 'make-scrolling-search-box)
