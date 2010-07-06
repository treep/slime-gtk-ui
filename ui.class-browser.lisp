;;;
;;; ui.class-browser.lisp -- browse class slots, used in `!class' command.
;;;

(defpackage :slime-gtk-ui.class-browser
  (:use :cl :gtk :gobject)
  (:export :run))

(in-package :slime-gtk-ui.class-browser)

(defun run (symbol)
  (with-simple-main-window (window :title "Class Browser")
    (let-uis ((search-entry        'entry :text (write-to-string symbol))
              (search-button       'button :label "Show")
              (scroll              'scrolled-window :hscrollbar-policy :automatic :vscrollbar-policy :automatic)
              (slots-model         'array-list-store)
              ((slots-list scroll) 'tree-view :model slots-model)
              ((v-box window)      'v-box)
              (search-box          'h-box))
     (make-scrolling-search-box v-box search-box search-entry search-button scroll)
     (store-add-column slots-model "gchararray"
                       (lambda (slot)
                         (format nil "~S" (closer-mop:slot-definition-name slot))))
     (let-uis ((col 'tree-view-column :title "Slot name")
               (cr  'cell-renderer-text))
       (tree-view-column-pack-start col cr)
       (tree-view-column-add-attribute col cr "text" 0)
       (tree-view-append-column slots-list col))
     (labels ((display-class-slots (class)
                                   (loop repeat (store-items-count slots-model)
                                         do (store-remove-item slots-model (store-item slots-model 0)))
                                   (closer-mop:finalize-inheritance class)
                                   (loop for slot in (closer-mop:class-slots class)
                                         do (store-add-item slots-model slot)))
              (on-search-clicked (button)
                                 (declare (ignore button))
                                 (with-gtk-message-error-handler
                                  (let* ((class-name (read-from-string (entry-text search-entry)))
                                         (class (find-class class-name)))
                                    (display-class-slots class)))))
       (g-signal-connect search-button "clicked" #'on-search-clicked)))))
