;; configure various modes

(eval-after-load 'projectile
  '(progn
     (setq projectile-cache-project t)))

;; haskell
(eval-after-load 'haskell-mode
  '(custom-set-variables
    '(haskell-mode-hook '(turn-on-haskell-indentation))))

;; erlang
(defun ak/configure-distel ()
  (add-to-list 'load-path "~/.emacs.d/site-lisp/distel/elisp")
  (when (require 'distel nil 'noerror)
     (distel-setup)
     ;; add distel shortcuts to erlang shell
     (defconst distel-shell-keys
       '(("\C-\M-i"   erl-complete)
         ("\M-?"      erl-complete)
         ("\M-."      erl-find-source-under-point)
         ("\M-,"      erl-find-source-unwind)
         ("\M-*"      erl-find-source-unwind)
         )
       "Additional keys to bind when in Erlang shell.")

     (add-hook 'erlang-shell-mode-hook
               (lambda ()
                 (dolist (spec distel-shell-keys)
                   (define-key erlang-shell-mode-map (car spec) (cadr spec)))))

     ;; auto-completion for erlang/distel
     (add-to-list 'load-path "~/.emacs.d/site-lisp/company-distel")
     (require 'company-distel)
     (require 'company-distel-frontend)
     (add-to-list 'company-backends 'company-distel)
    ))

;; (add-to-list 'auto-mode-alist '("\\.erl$" . erlang-mode))
;; (add-to-list 'auto-mode-alist '("\\.hrl$" . erlang-mode))
(eval-after-load 'erlang
  '(progn
     (setq erlang-node-name "emacs@localhost")
     (setq erl-nodename-cache (intern erlang-node-name))
     (setq inferior-erlang-machine-options (list "-name" erlang-node-name "-sname" erlang-node-name))
     (ak/configure-distel)))

;; flycheck adjustments
(eval-after-load 'flycheck
  '(progn
     (setq flycheck-highlighting-mode 'lines)
     (load "flycheck-java")))

;; enable company mode by default (if present)
(when (require 'company nil 'noerror)
  (global-company-mode))

(eval-after-load 'company
  '(progn
     (setq company-tooltip-limit 20)
     (setq company-minimum-prefix-length 1)
     (setq company-idle-delay .25)
     (setq company-echo-delay 0)
     ;; do not convert to lower case dabbrev candidates
     (setq company-dabbrev-downcase nil)
     (setq company-begin-commands '(self-insert-command))
     (define-key company-active-map (kbd "C-c C-d") 'company-show-doc-buffer)
     (define-key company-active-map (kbd "C-/") 'company-complete-common)
     (define-key company-active-map (kbd "<tab>") 'company-complete)

     ; close on escape
     (define-key company-active-map (kbd "<escape>")
       '(lambda ()
          (interactive)
          (company-abort)
          (if (fboundp 'evil-normal-state)
              (evil-normal-state))))))

(add-hook 'go-mode-hook
  (lambda ()
    (when (require 'company-go nil 'noerror)
      (add-to-list 'company-backends 'company-go))))

(add-hook 'python-mode-hook
  (lambda ()
    (when (require 'jedi nil 'noerror)
      (jedi:setup))))

(eval-after-load 'ggtags
  '(progn
     (setq ggtags-global-abbreviate-filename 60)))


(setq c-default-style "k&r"
      c-basic-offset 4)

(setq cperl-continued-statement-offset 0
      cperl-indent-level 4
      cperl-indent-parens-as-block t
      cperl-close-paren-offset -4 )

;; to switch between single-line and multi-line comments
(defun ak/use-cpp-comments ()
  (interactive)
  (setq-local comment-start "//")
  (setq-local comment-end   ""))

(defun ak/use-c-comments ()
  (interactive)
  (setq-local comment-start "/*")
  (setq-local comment-end   "*/"))
