;;; -*- lexical-binding: t -*-

;; Always start Emacs maximized
(push '(fullscreen . maximized) default-frame-alist)

;; Don't flicker GUI elements on startup
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Disable terminal bell
(setq ring-bell-function 'ignore)

;; We're using straight.el instead of package.el, no need to load it
(setq package-enable-at-startup nil)

