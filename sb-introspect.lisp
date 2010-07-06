;;;
;;; sb-introspect.lisp -- f-trees builder to SB-INTROSPECT package.
;;;

(in-package :sb-introspect)

(defparameter *ff* nil) ;; to collect finded functions

(defun %find-function-callees/recur (f deep)
  (when (numberp deep)
    (decf deep)
    (when (< deep 0)
      (return-from %find-function-callees/recur)))
  (etypecase f
    (sb-kernel::closure        f)
    (standard-generic-function f)
    (function                  (pushnew f *ff*)
                               (let ((callees (find-function-callees f)))
                                 (cons f (loop for call in callees
                                               if (not (find call *ff*))
                                               collect (%find-function-callees/recur call deep)))))))

(defun find-function-callees/recur (f &optional deep)
  "Build f-tree (flow graph) for function F."
  (setf *ff* nil)
  (%find-function-callees/recur f deep))

(defun print-tree (tree &optional (i 0))
  (typecase tree
    (atom (dotimes (_ i)
            (princ "  "))
          (format t "~A~%" tree))
    (cons (print-tree (car tree) i)
          (print-tree (cdr tree) (1+ i)))))

(export 'find-function-callees/recur)
(export 'print-tree)
