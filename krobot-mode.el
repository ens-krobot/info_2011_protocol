;; krobot-mode.el
;; --------------
;; Copyright : (c) 2011, Jeremie Dimino <jeremie@dimino.org>
;; Licence   : BSD3
;;
;; This file is a part of [kro]bot.

(require 'tuareg)

(defconst krobot-keywords '("message")
  "List of keywords for the krobot-mode")

(defvar krobot-file nil
  "Whether the current buffer is krobot protocol file")

(defun krobot-tuareg-mode-hook ()
  "Setup the tuareg mode for krobot protocol files"
  (if krobot-file
      (progn
        (setq krobot-file nil)
        (make-local-variable 'tuareg-governing-phrase-regexp)
        (make-local-variable 'tuareg-keyword-alist)
        (make-local-variable 'tuareg-font-lock-keywords)

        (setq tuareg-governing-phrase-regexp "\\<message\\>")
        (setq tuareg-keyword-alist (mapcar (lambda (x) (cons x 2)) krobot-keywords))

        (setq tuareg-font-lock-keywords
              (list
               (list "[(){}:*=,;]"
                     0 'font-lock-keyword-face nil nil)
               (list (regexp-opt krobot-keywords `words)
                     0 'font-lock-keyword-face nil nil)
               (list "\\<message\\>[ \t\n]+\\([A-Za-z_][A-Za-z0-9_]*\\)\\>"
                     1 'font-lock-function-name-face 'keep nil)
               (list "\\<message\\>[ \t\n]+[A-Za-z_][A-Za-z0-9_]*[ \t\n]*=[ \t\n]*\\([0-9]+\\)\\>"
                     1 'font-lock-constant-face 'keep nil)
               (list "\\<\\([A-Za-z_][A-Za-z0-9_.]+\\)[ \t\n]*:"
                     1 'font-lock-variable-name-face 'keep nil)
               (list ":[ \t\n]*\\([A-Za-z_][A-Za-z0-9_.]+\\)\\>"
                     1 'font-lock-type-face 'keep nil))))))

(add-hook 'tuareg-mode-hook 'krobot-tuareg-mode-hook)

;;;###autoload (add-to-list 'auto-mode-alist '("\\.krobot\\'" . krobot-mode))

;;;###autoload
(defun krobot-mode ()
  "Major mode for editing krobot protocol files"
  (interactive)
  (setq krobot-file t)
  (tuareg-mode))

(provide 'krobot-mode)
