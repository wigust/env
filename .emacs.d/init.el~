;; Better defaultsemacs 
(unless (eq window-system 'ns)
  (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (fboundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode -1))
(save-place-mode 1)
(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      visible-bell t
      load-prefer-newer t
      ediff-window-setup-function 'ediff-setup-windows-plain)


;; Package configs
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "https://orgmode.org/elpa/")
                         ("gnu"   . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(package-refresh-contents)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Theme
(use-package doom-themes
  :config
  (load-theme 'doom-one t))

;; Helm
(use-package helm
  :init
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  (setq helm-candidate-number-list 50)
  (helm-mode 1))
(use-package helm-ag
  :after helm
  :config
  (setq helm-follow-mode-persistent t))
(use-package helm-swoop
  :after helm)

;; Telephone Line
(use-package telephone-line
  :init
  (telephone-line-mode 1))

(use-package centaur-tabs
  :config
  (setq centaur-tabs-set-bar 'left)
  (centaur-tabs-mode t))

;; Which Key
(use-package which-key
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode))

;; Projectile
(use-package projectile
  :config
  (setq projectile-project-search-path '("~/Development/"))
  (projectile-mode +1))
(use-package helm-projectile
  :after projectile
  :config
  (helm-projectile-on))

;; Crux
(use-package crux)

;; Org
(use-package org)
(use-package org-bullets)
(use-package org-present)
(use-package org-projectile)

;; Git
(use-package magit)
(use-package forge
  :after magit)
;; LSP
(use-package lsp-mode
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)
(use-package lsp-mode
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         (haskell-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package helm-lsp :commands helm-lsp-workspace-symbol)

;; Completion
(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode))
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0)

;; Checking
(use-package flycheck
  :init (global-flycheck-mode))

;; Nix
(use-package nix-mode)
(use-package nixos-options
  :after (company nix-mode)
  :config
  (add-to-list 'company-backends 'company-nixos-options))

;; Ranger.el
(use-package ranger)

;; Custom keybinding
(use-package general
  :after (helm crux projectile)
  :config
  ;; Globals
  (general-define-key
   "C-k" '(crux-smart-kill-line :which-key "smart kill line")
  )
  ;; Everything else
  (general-define-key
  :prefix "C-c"
  "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
  "SPC" '(helm-M-x :which-key "M-x")
  ;; Files
  "f"   '(nil :which-key "files")
  "ff"  '(helm-find-files :which-key "find files")
  "fs"  '(save-buffer :which-key "save buffer")
  "fp"  '(helm-projectile-find-file :which-key "find file in project")
  "fr"  '(helm-recentf :which-key "recent files")
  ;; Projects
  "p"   '(helm-projectile :which-key "projectile")
  ;; Editing shortcuts
  "d"   '(crux-duplicate-current-line-or-region :which-key "duplicate line/region")
  ;; Configuration
  ;; "c"   '(nil :which-key "configuration")
  "ci"  '(crux-find-user-init-file :which-key "find-user-init-file")
  ;; Buffers
  "bb"  '(helm-buffers-list :which-key "list buffers")
  ;; Windows
  "w"   '(nil :which-key "windows")
  "wd"  '(delete-window :which-key "delete window")
  "w/"  '(split-window-right :which-key "split window right")
  ;; Search
  "sa"  '(helm-do-ag-this-file :which-key "ag current file")
  "ss"  '(helm-swoop :which-key "search current file")
  "sb"  '(helm-do-ag-buffers :which-key "ag buffers")
  ;; Window

  ;; Others
))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (general which-key telephone-line helm doom-themes use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
