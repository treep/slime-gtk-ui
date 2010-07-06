;;;
;;; slime-gtk-ui.el -- elisp functions for SLIME.
;;;
;;;   load this file in `~/.emacs'
;;;

;;; FIXME: it's ok? This code ruin SLIME in first time,
;;;        but after `M-x SLIME' again everythig work finely.

(require 'slime)

(defun !describe (string)
  (interactive (list (slime-last-expression)))
  (slime-eval `(slime-gtk-ui:run-describe-ui ,string)))

(defun !sexp (string)
  (interactive (list (slime-last-expression)))
  (slime-eval `(slime-gtk-ui:run-sexp-browser-ui ,string)))

(defun !class (string)
  (interactive (list (slime-last-expression)))
  (slime-eval `(slime-gtk-ui:run-class-browser-ui ,string)))

(defun !function (string)
  (interactive (list (slime-last-expression)))
  (slime-eval `(slime-gtk-ui:run-function-browser-ui ,string)))

;;; TODO:
;;;   1. keymaps
;;;   2. menu
