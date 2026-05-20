;;; -*- lexical-binding: t -*-
;; --------------------------------------------------------
;; Bootstrap
;; --------------------------------------------------------
(defvar bootstrap-version)
(let ((bootstrap-file
		(expand-file-name
			"straight/repos/straight.el/bootstrap.el"
			(or (bound-and-true-p straight-base-dir)
				user-emacs-directory)))
		(bootstrap-version 7))
	(unless (file-exists-p bootstrap-file)
		(with-current-buffer
			(url-retrieve-synchronously
			 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
			 'silent 'inhibit-cookies)
		(goto-char (point-max))
		(eval-print-last-sexp)))
	(load bootstrap-file nil 'nomessage))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Package system configuration
;; --------------------------------------------------------
(straight-use-package 'use-package)
(setq package-enable-at-startup       nil
	straight-use-package-by-default t
	use-package-always-defer        t)
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Core Emacs behavior
;; --------------------------------------------------------
(use-package emacs
	:init

	;; UI elements
	(tool-bar-mode   -1)
	(scroll-bar-mode -1)
	(setq inhibit-splash-screen   t
		use-file-dialog         nil
		initial-scratch-message nil)
	(defun display-startup-echo-area-message () (message ""))

	;; Input/confirmation
	(defalias 'yes-or-no-p 'y-or-n-p)
	(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

	;; Encoding
	(set-charset-priority               'unicode)
	(setq locale-coding-system          'utf-8
		coding-system-for-read        'utf-8
		coding-system-for-write       'utf-8)
		default-process-coding-system '(utf-8-unix . utf-8-unix))
	(set-terminal-coding-system         'utf-8)
	(set-keyboard-coding-system         'utf-8)
	(set-selection-coding-system        'utf-8)
	(prefer-coding-system               'utf-8)

	;; Indentation
	(defvar tabs-are-better-than-spaces 6)
	(setq-default indent-tabs-mode t
		        tab-width        tabs-are-better-than-spaces)
	(setq c-basic-offset                       tabs-are-better-than-spaces
		backward-delete-char-untabify-method nil
		electric-indent-mode                 nil
		tab-always-indent                    t)

	;; macOS specific
	(when (eq system-type 'darwin)
		(setq mac-command-modifier 'super
			mac-option-modifier  'nil
			mac-control-modifier 'nil)
		(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
		(add-to-list 'default-frame-alist '(ns-appearance . dark))
		(setq ns-use-proxy-icon nil
			frame-title-format nil))

	;; Font
	(set-face-attribute 'default nil
				  :font    "JetBrainsMono Nerd Font"
				  :height  100)

	;; Line numbers
	(global-display-line-numbers-mode)
	(setq display-line-numbers-width-start 1)
	(setq display-line-numbers 'relative)

	;; Add a ruler at 80 columns
	(setq-default fill-column 80)
	(set-face-attribute 'fill-column-indicator nil
		              :foreground "#717C7C" ; katana-gray
		              :background "transparent")
	(global-display-fill-column-indicator-mode 1)

	(setq backup-directory-alist `(("." . "~/.saves")))

	;; Refresh files modified on disk
	(global-auto-revert-mode 1)

	;; Disable line wrap
	(setq-default truncate-lines t)

	;; Scrolling
	(unless (display-graphic-p)
		(xterm-mouse-mode 1)
		(global-set-key (kbd "<mouse-4>") 'scroll-down-line)
		(global-set-key (kbd "<mouse-5>") 'scroll-up-line))
	(pixel-scroll-mode 1)

	;; Make backspace work properly
	(global-set-key (kbd "DEL") 'backward-delete-char)

	;; Recognize ES and CommonJS modules as JavaScript
	(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-mode))
	(add-to-list 'auto-mode-alist '("\\.cjs\\'" . js-mode))

	;; Show Treemacs
	(add-hook 'emacs-startup-hook 'treemacs)

	;; Emacs restarting
	(global-set-key (kbd "C-x r") 'restart-emacs)
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Environment / shell integration
;; --------------------------------------------------------
(use-package exec-path-from-shell
	:init
	(exec-path-from-shell-initialize))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Keybinding infrastructure
;; --------------------------------------------------------
(use-package general
	:demand t
	:config
	(general-evil-setup)

	(general-create-definer leader-keys
		:states '(normal insert visual emacs)
		:keymaps 'override
		:prefix "SPC"
		:global-prefix "C-SPC")

	;; Global / top-level
	(leader-keys
		"x" '(execute-extended-command :which-key "execute command")
		"r" '(restart-emacs            :which-key "restart Emacs")
		"i" '((lambda () (interactive) (find-file user-init-file))
			:which-key "open init file"))

	;; Buffers
	(leader-keys "b"  '(:ignore t           :which-key "buffer")
		       "bd" '(kill-current-buffer :which-key "kill buffer"))

	;; Insert mode tweaks
	(general-define-key
		:states 'insert
		"TAB" 'tab-to-tab-stop))

(use-package which-key
	:ensure t
	:demand t
	:config
	(which-key-mode)
	(setq which-key-idle-delay 0.3))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Appearance / theme
;; --------------------------------------------------------
(use-package catppuccin-theme
	:demand t
	:init
	(setq catppuccin-flavor 'macchiato)
	:config
	(load-theme 'catppuccin t))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Gizmos
;; --------------------------------------------------------
(use-package doom-modeline
	:demand t
	:init
	(doom-modeline-mode 1))

(use-package nyan-mode
	:demand t
	:init
	(nyan-mode))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Evil / Modal editing
;; --------------------------------------------------------
(use-package evil
	:demand t
	:init
	(setq evil-want-keybinding nil
		evil-want-C-u-scroll t)
	:config
	(evil-mode 1))

(use-package evil-collection
	:after evil
	:demand t
	:config
	(evil-collection-init))

(use-package evil-nerd-commenter
	:general
	(general-nvmap "gc" 'evilnc-comment-operator))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Projects / navigation
;; --------------------------------------------------------
(use-package projectile
	:demand t
	:general
	(leader-keys
		"SPC" '(projectile-find-file            :which-key "find file in project")
		"b b" '(projectile-switch-to-buffer     :which-key "switch buffer")
		"p"   '(:ignore t                       :which-key "project")
		"p p" '(projectile-switch-project       :which-key "switch project")
		"p a" '(projectile-add-known-project    :which-key "add project")
		"p r" '(projectile-remove-known-project :which-key "remove project"))
	:init
	(projectile-mode +1))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Git / version control
;; --------------------------------------------------------
(use-package magit
	:general
	(leader-keys
		"g"   '(:ignore t    :which-key "git")
		"g g" '(magit-status :which-key "status")
		"g l" '(magit-log    :which-key "log"))
	(general-nmap "<escape>" #'transient-quit-one))

(use-package diff-hl
	:init
	(add-hook 'magit-pre-refresh-hook  'diff-hl-magit-pre-refresh)
	(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
	:config
	(global-diff-hl-mode))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Terminal / tools
;; --------------------------------------------------------
(use-package vterm)
(use-package vterm-toggle
	:general
	(leader-keys "'" '(vterm-toggle :which-key "terminal")))

(use-package rg
	:general
	(leader-keys "f" '(rg-menu :which-key "find (ripgrep)")))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Performance
;; --------------------------------------------------------
(use-package gcmh
	:demand t
	:config
	(gcmh-mode 1))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Language Server Protocol (LSP) support
;; --------------------------------------------------------
(use-package eglot
	:defer t
	:init
	(add-hook 'python-mode-hook 'eglot-ensure))

(use-package python
	:ensure nil
	:mode ("\\.py\\'" . python-ts-mode)
	:hook (python-ts-mode . eglot-ensure))

(use-package flycheck
	:ensure t
	:init
	(global-flycheck-mode 1))

(use-package treesit-auto
	:ensure t
	:custom
	(treesit-auto-install 'prompt)
	:config
	(treesit-auto-add-to-auto-mode-alist 'all)
	(global-treesit-auto-mode 1))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Completion and fuzzy finding
;; --------------------------------------------------------
(use-package ivy
	:config
	(ivy-mode 1))

(use-package company
	:after eglot
	:hook (python-mode . company-mode)
	:bind (:map company-active-map
		("C-/" . company-compete-selection))

	:config
	(setq company-minimum-prefix-length 1
		company-idle-delay 0.1)
	(global-company-mode t))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; File Management
;; --------------------------------------------------------
(use-package treemacs
	:ensure t
	:defer t
	:bind
	(("C-c t"   . treemacs)
	 ("C-x t 1" . treemacs-select-window)
	 ("C-x t 2" . treemacs-find-file)
	 ("C-x t 3" . treemacs-show-project-content)
	 ("C-x t 4" . treemacs-select-directory))

	:custom
	(treemacs-default-visit-action #'treemacs-visit-node-no-split)
	(treemacs-follow-mode t)
	(treemacs-filewatch-mode t)
	(treemacs-git-mode 'simple)
	(treemacs-is-never-other-window t)

	:config
	(treemacs-resize-icons 18)
	(defun my/disable-line-numbers-in-treemacs ()
		"Disable line numbers in treemacs buffers."
		(display-line-numbers-mode -1))
	(add-hook 'treemacs-mode-hook 'my/disable-line-numbers-in-treemacs))

(use-package treemacs-projectile
	:after (treemacs projectile)
	:ensure t)

;; --------------------------------------------------------

;; --------------------------------------------------------
;; Dashboard
;; --------------------------------------------------------
(use-package dashboard
	:ensure t
	:config
	(setq dashboard-center-content 1)
	(setq dashboard-startup-banner nil)
	(setq dashboard-startup-banner (expand-file-name "banner.txt" user-emacs-directory))
	(setq dashboard-items '((recents   . 5)
					(bookmarks . 5)
					(projects  . 5)
					(agenda    . 5)))
	:init
	(dashboard-setup-startup-hook))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; UI Tweaks
;; --------------------------------------------------------
(use-package all-the-icons
	:demand t
	:if (display-graphic-p))

(use-package awesome-tab
	:demand t
	:after all-the-icons
	:config
	(awesome-tab-mode t)
	(setq awesome-tab-height 100)
	(dotimes (i 10)
		(global-set-key (kbd (format "C-%d" i)) 'awesome-tab-select-visible-tab))
	:bind
	("C-<tab>"         . awesome-tab-forward-tab)
	("C-<iso-lefttab>" . awesome-tab-backward-tab))
;; --------------------------------------------------------

;; --------------------------------------------------------
;; Misc
;; --------------------------------------------------------
(use-package scroll-restore
	:ensure t
	:config
	(setq scroll-restore-jump-back     t
		scroll-restore-handle-cursor t
		scroll-restore-cursor-type   nil))
;; --------------------------------------------------------

;; TODO: Org Mode, Java, C, Build Systems, AI, Calendar, Email, etc

(provide 'init)
;;; init.el ends here

