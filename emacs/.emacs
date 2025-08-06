
;;; .emacs --- Emacs initialization file -*- lexical-binding: t; -*-

;;; Commentary:

;; Welcome to Emacs (http://go/emacs).
;;
;; If you see this file, your homedir was just created on this workstation.
;; That means either you are new to Google (in that case, welcome!) or you
;; got yourself a faster machine.
;;
;; Either way, the main goal of this configuration is to help you be more
;; productive; if you have ideas, praise or complaints, direct them to
;; emacs-users@google.com (http://g/emacs-users).  We'd especially like to hear
;; from you if you can think of ways to make this configuration better for the
;; next Noogler.
;;
;; If you want to learn more about Emacs at Google, see http://go/emacs.

;;; Code:

;; Use the 'google' package by default.
(require 'google)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq inferior-lisp-program "sbcl")

(require 'evil)
(evil-mode 1)

;;; .emacs ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(evil slime zenburn-theme yasnippet-snippets yaml-mode which-key undo-tree tabbar session rust-mode puppet-mode pod-mode muttrc-mode mutt-alias lsp-ui initsplit ido-completing-read+ htmlize graphviz-dot-mode goto-chg gitignore-mode gitconfig-mode gitattributes-mode git-modes folding ess eproject editorconfig diminish csv-mode company-lsp color-theme-modern browse-kill-ring boxquote bm bar-cursor apache-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
