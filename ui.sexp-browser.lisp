;;;
;;; ui.sexp-browser.lisp -- TREE-STORE based browser, used in `!sexp' and `!function' commands.
;;;

(defpackage :slime-gtk-ui.sexp-browser
  (:use :cl :gtk :gobject)
  (:export :run))

(in-package :slime-gtk-ui.sexp-browser)

(defstruct tvi title value)

(defun make-tree-from-sexp (sexp)
  (let* ((sexp (if (listp sexp) sexp (list sexp)))
         (node (make-tree-node :item (make-tvi :title (write-to-string (first sexp))
                                               :value (write-to-string (class-of (first sexp)))))))
    (dolist (child (rest sexp))
      (tree-node-insert-at node (make-tree-from-sexp child) (length (tree-node-children node))))
    node))

(defun run (sexp title entry-text sexp-f)
  (with-simple-main-window (window :title title)
    (let-uis ((model              'tree-lisp-store)
              (scroll             'scrolled-window :hscrollbar-policy :automatic :vscrollbar-policy :automatic)
              ((tree-view scroll) 'tree-view :headers-visible t :width-request 500 :height-request 200 :rules-hint t)
              (h-box              'h-box)
              ((v-box window)     'v-box)
              (entry              'entry :text entry-text)
              (button             'button :label "Show"))
      (tree-lisp-store-add-column model "gchararray" #'tvi-title)
      (tree-lisp-store-add-column model "gchararray" #'tvi-value)
      (tree-node-insert-at (tree-lisp-store-root model)
                           (make-tree-from-sexp (funcall sexp-f sexp))
                           0)
      (setf (tree-view-model tree-view) model
            (tree-view-tooltip-column tree-view) 0)
      (connect-signal tree-view "row-activated"
                      (lambda (tv path column)
                        (declare (ignore column))
                        (let* ((model (tree-view-model tv))
                               (iter  (tree-model-iter-by-path model path))
                               (value (tree-model-value model iter 0)))
                          (slime-gtk-ui.describe:run (read-from-string value)))))
      (connect-signal button "clicked" (lambda (b)
                                         (declare (ignore b))
                                         (let ((object (read-from-string (entry-text entry))))
                                           (tree-node-remove-at (tree-lisp-store-root model) 0)
                                           (tree-node-insert-at (tree-lisp-store-root model)
                                                                (make-tree-from-sexp (funcall sexp-f object))
                                                                0))))
      ;; TODO: enter on entry
      (make-scrolling-search-box v-box h-box entry button scroll)
      (let-uis ((column   'tree-view-column :title "Value" :sort-column-id 0)
                (renderer 'cell-renderer-text :text "A text"))
        (tree-view-column-pack-start column renderer)
        (tree-view-column-add-attribute column renderer "text" 0)
        (tree-view-append-column tree-view column))
      (let-uis ((column   'tree-view-column :title "Type")
                (renderer 'cell-renderer-text :text "A text"))
        (tree-view-column-pack-start column renderer)
        (tree-view-column-add-attribute column renderer "text" 1)
        (tree-view-append-column tree-view column)))))
