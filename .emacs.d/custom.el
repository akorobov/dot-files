;-*- Mode: Emacs-Lisp -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; global settings
; no splash
(setq inhibit-startup-message t)

; faster switching between buffers
(iswitchb-mode 1)

(setq ibuffer-expert t) 

(if window-system
    (toggle-scroll-bar -1)
    (menu-bar-mode -1))

(tool-bar-mode -1)
(line-number-mode t)
(column-number-mode t)

; keep backups
(setq version-control t)
(setq delete-old-versions t)

; fontlock
(global-font-lock-mode 1)
(setq font-lock-auto-fontify t)
(setq font-lock-verbose nil)
(setq lazy-lock-continuity-time 0.3)

; remove noisy yes/no
(fset 'yes-or-no-p 'y-or-n-p)

; use spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

; fix default c- and cperl- mode indentations
(setq c-default-style "linux"
      c-basic-offset 4)
(setq cperl-continued-statement-offset 0
      cperl-indent-level 4
      cperl-indent-parens-as-block t
      cperl-close-paren-offset -4 )
(setq nxml-child-indent 4)

; don't get lost
(show-paren-mode t)

; delete selected region on edit
(delete-selection-mode t)

;; delete trailing spaces on save
; (add-hook 'before-save-hook (lambda () (delete-trailing-whitespace)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; configure keyboard settings
; 'C-h l' to see last key strokes 
(define-key function-key-map "\e[25~" [(shift f3)])
(define-key function-key-map "\e[26~" [(shift f4)])
(define-key function-key-map "\e[28~" [(shift f5)])

(global-set-key [help] 'info)
(global-set-key [f1] 'manual-entry)
(global-set-key [f2] 'save-buffer)
(global-set-key [f3] 'find-file-at-point)
(global-set-key [(shift f3)] 'revert-buffer)

(global-set-key [(control o)] 'other-window)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-2") 'split-window-vertically)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-0") 'delete-window)

(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

(global-set-key [(meta j)] 'goto-line)
(global-set-key [(meta g)] 'grep)
(global-set-key [(meta q)] 'kill-buffer)
(global-set-key [(meta \`)] 'ibuffer) ; buffer-menu
(global-set-key [(meta backspace)] 'backward-kill-word)

(global-set-key [(control c) (control a)] 'beginning-of-buffer)
(global-set-key [(control c) (control e)] 'end-of-buffer)
(global-set-key [(control c) (a)] 'beginning-of-buffer)
(global-set-key [(control c) (e)] 'end-of-buffer)
(global-set-key [(control c) (control q)] 'diff-apply-hunk)

(global-set-key (kbd "<select>") 'end-of-line)

(global-set-key [(meta i)] 'imenu)
(global-set-key [(meta \])] 'gtags-find-tag)

(define-key global-map [(control x) (g)] nil) ; define prefix
(global-set-key [(control x) (g) (s)] 'gtags-find-symbol)
(global-set-key [(control x) (g) (r)] 'gtags-find-rtag)
(global-set-key [(control x) (g) (t)] 'gtags-find-tag)
(global-set-key [(control x) (g) (f)] 'gtags-find-file)
(global-set-key [(meta *)] 'gtags-pop-stack)

; retain relative paths(i.e. handle cases when parent directory is symlink)
(setq gtags-path-style 'relative)

(defun shell-filter-region ( command )
  (interactive (list (read-shell-command "Filter to apply: ")))
  (shell-command-on-region (region-beginning) (region-end) command (current-buffer) t))
(global-set-key [(control |)] 'shell-filter-region)

;; (global-set-key [(control i)]
;;   '(lambda ()
;;      (interactive)
;;      (shell-command (read-string "Shell command to insert: ") t)))

(defun my-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command ()))))
;        (t (self-insert-command (or arg 1)))))

(global-set-key [(meta \\)] 'my-match-paren)       ; Bounce across parens, like in vi.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; use recentf
(recentf-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; diff buffers are read-only
(setq diff-default-read-only t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; nice colors
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

; always split horizontally
;(setq split-width-threshold 0)
;(setq split-height-threshold nil)
(setq display-buffer-reuse-frames t)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

; include dired buffers when filtering by path
(eval-after-load "ibuf-ext"
  '(progn 
     (define-ibuffer-filter path
         "Toggle current view to buffers with file or directory name matching QUALIFIER."
       (:description "path"
                     :reader (read-from-minibuffer "Filter by file/directory name (regexp): "))
       (ibuffer-awhen (or (buffer-local-value 'buffer-file-name buf)
                          (buffer-local-value 'dired-directory buf))
         (string-match qualifier it)))
     (setq ibuffer-show-empty-filter-groups nil)))

;;; misc utility functions
; Select everything
(defun select-all ()
  (interactive)
  (set-mark (point-min))
  (goto-char (point-max)))

; Insert the date
(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%a %b %e, %Y %l:%M %p")))

(defun read-lines (file)
  "returns a list of lines read from a file with given name."
  (with-temp-buffer
    (insert-file-contents file)
    (split-string
     (buffer-string) "\n" t)
    ))

;;
(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis. Else go to the
   opening parenthesis one level up."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1))
        (t
         (backward-char 1)
         (cond ((looking-at "\\s\)")
                (forward-char 1) (backward-list 1))
               (t
                (while (not (looking-at "\\s("))
                  (backward-char 1)
                  (cond ((looking-at "\\s\)")
                         (message "->> )")
                         (forward-char 1)
                         (backward-list 1)
                         (backward-char 1)))
                  ))))))
(global-set-key (kbd "M-\\") 'goto-match-paren)

;; protect Messages and scratch buffers
(add-hook 'kill-buffer-query-functions
          (lambda ()
            (if (not (member (buffer-name) '("*scratch*" "*Messages*")))
                t
              (bury-buffer)
              nil)))

(defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
    (define-key ido-completion-map (kbd "SPC") 'ido-select-text))
(add-hook 'ido-setup-hook 'ido-define-keys)
