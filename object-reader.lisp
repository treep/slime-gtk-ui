;;;
;;; object-reader.lisp -- reader for #<FUNCTION NAME> forms.
;;;

(in-package :cl-user)

(defun char-whitespace-p (char)
  (or (char= char #\Space)
      (char= char #\Newline)
      (char= char #\Tab)))

(defun read-next-token (stream)
  (let (chars)
    (do ((char #\_))
        ((char-whitespace-p char))
      (setf char (read-char stream))
      (push char chars))
    (coerce (nreverse (rest chars)) 'string)))

(defun read-last-token (stream)
  (let (chars)
    (do ((char #\_))
        ((char= char #\>))
      (setf char (read-char stream))
      (push char chars))
    (coerce (nreverse (rest chars)) 'string)))

;;; FIXME: some strange types problem there.
(defun |#<-reader| (stream sub-char numarg)
  (declare (ignore sub-char numarg))
  (let ((next-token (read-next-token stream)))
    (cond ((string= next-token "FUNCTION")
           (let* ((last-token (read-last-token stream))
                  (split      (position #\: last-token))
                  (package    (when split
                                (subseq last-token 0 split)))
                  (symbol     (when split
                                (if (find #\: (subseq last-token (1+ split)))
                                    (subseq last-token (+ 2 split))
                                    (subseq last-token (1+ split))))))
             (if split
                 (eval `(function ,(intern symbol (find-package package))))
                 (eval `(function ,(intern last-token)))))))))

(set-dispatch-macro-character #\# #\< #'|#<-reader|)
