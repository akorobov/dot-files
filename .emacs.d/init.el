;-*- Mode: Emacs-Lisp -*-

(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

(add-to-list 'exec-path "~/bin")

;; ensure temporary directory path is absolute
(setq temporary-file-directory (file-truename temporary-file-directory))

;; start server
(if (and (fboundp 'server-running-p)
         (not (server-running-p)))
    (progn
      (server-start)
      (add-hook 'server-switch-hook
                (lambda nil
                  (let ((server-buf (current-buffer)))
                    (bury-buffer)
                    (switch-to-buffer-other-frame server-buf))))))

(require 'package)
(package-initialize)

;; elpa/package archives
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))

(defvar my-packages
  '(company
    flycheck
    projectile
    smartparens
    erlang
    haskell-mode
    clojure-mode
    cider
    web-mode
    yasnippet
    go-mode
    company-go
    helm
    paredit
    ggtags)
  "my packages")

;; install on demand
(defun fetch-my-packages ()
  (interactive)
  (when (not package-archive-contents)
  (package-refresh-contents))

  (dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))
)

(load "~/.emacs.d/custom.el")
(load "~/.emacs.d/modes.el")
