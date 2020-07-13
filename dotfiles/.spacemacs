;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation 'unused
   ;; List of additional paths where to look for configuration layers (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   dotspacemacs-configuration-layers
   '(;; Fundamentals
     (ibuffer :variables ibuffer-group-buffers-by 'projects)
     ;; (templates :variables templates-private-directory "~/.spacemacs.d/templates")
     (treemacs :variables treemacs-use-git-mode 'deferred)
     copy-as-format
     dap
     ;; OS
     nixos
     ;; Tools
     cmake
     docker
     nginx
     prodigy
     (org :variables org-projectile-file "TODOS.org")
     ;; LSP
     lsp
     ;; Languages & File types
     (python
      :variables
      python-backend 'lsp
      python-formatter 'black
      python-test-runner 'pytest
      python-lsp-server 'pyls)
     (haskell
      :variables
      haskell-completion-backend 'ghci)
     (c-c++
      :variables
      c-c++-backend 'lsp-clangd
      c-c++-enable-google-style t
      c-c++-enable-google-newline t)
     ;; (purescript :variables node-add-modules-path t)
     sql
     elm
     emacs-lisp
     html
     javascript
     markdown
     yaml
     rust
     ;; Completion
     (helm :variables helm-enable-auto-resize t)
     (auto-completion :variables auto-completion-enable-sort-by-usage t)
     (spell-checking :variables enable-flyspell-auto-completion t)
     syntax-checking
     ;; Source control
     (git
      :variables
      magit-repository-directories '(("~/Development/" . 4))
      )
     github
     version-control
     ;; Other fun stuff
     unicode-fonts
     (shell :variables
             shell-default-height 30
             shell-default-position 'bottom)
     emoji)
   ;; List of additional packages that will be installed
   dotspacemacs-additional-packages '(doom-themes
                                      direnv
                                      company-lsp
                                      gnu-elpa-keyring-update)
   dotspacemacs-frozen-packages '()
   dotspacemacs-excluded-packages '()
   dotspacemacs-install-packages 'used-only)
  (when (spacemacs/system-is-mac)
    (append dotspacemacs-configuration-layers
            '(osx)))
  )

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   package-check-signature nil
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-check-for-update nil
   dotspacemacs-elpa-subdirectory nil
   dotspacemacs-editing-style 'vim
   dotspacemacs-mode-line-theme 'spacemacs
   dotspacemacs-verbose-loading nil
   dotspacemacs-startup-banner 'official
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7)
                                (todos . 5))
   dotspacemacs-startup-buffer-responsive t
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-themes '(doom-one
                         doom-Iosvkem
                         doom-dark+
                         doom-nord
                         doom-palenight
                         doom-sourcerer
                         doom-spacegrey
                         doom-tomorrow-night
                         doom-vibrant
                         spacemacs-dark)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font '("JetBrains Mono"
                               :size 12
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-retain-visual-state-on-shift t
   dotspacemacs-default-layout-name "Default"
   ;; Files
   dotspacemacs-large-file-size 2
   dotspacemacs-auto-save-file-location 'cache
   dotspacemacs-max-rollback-slots 5
   ;; Helm
   dotspacemacs-helm-position 'bottom
   dotspacemacs-helm-use-fuzzy 'always
   ;; Other
   dotspacemacs-which-key-delay 0.4
   ;; Window behavior
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup nil
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 90
   dotspacemacs-show-transient-state-title t
   dotspacemacs-show-transient-state-color-guide t
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-smooth-scrolling t
   dotspacemacs-folding-method 'evil
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'trailing
   ;; Extra stuff
   dotspacemacs-line-numbers t
   evil-kill-on-visual-paste nil
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

 (direnv-mode)

(defun fira-code-mode--make-alist (list)
  "Generate prettify-symbols alist from LIST."
  (let ((idx -1))
    (mapcar
     (lambda (s)
       (setq idx (1+ idx))
       (let* ((code (+ #Xe100 idx))
          (width (string-width s))
          (prefix ())
          (suffix '(?\s (Br . Br)))
          (n 1))
     (while (< n width)
       (setq prefix (append prefix '(?\s (Br . Bl))))
       (setq n (1+ n)))
     (cons s (append prefix suffix (list (decode-char 'ucs code))))))
     list)))

(defconst fira-code-mode--ligatures
  '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\"
    "{-" "[]" "::" ":::" ":=" "!!" "!=" "!==" "-}"
    "--" "---" "-->" "->" "->>" "-<" "-<<" "-~"
    "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
    ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*"
    "/**" "/=" "/==" "/>" "//" "///" "&&" "||" "||="
    "|=" "|>" "^=" "$>" "++" "+++" "+>" "=:=" "=="
    "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">="
    ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>"
    "<$" "<$>" "<!--" "<-" "<--" "<->" "<+" "<+>" "<="
    "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<" "<~"
    "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~" "~~>" "%%"
    "x" ":" "+" "+" "*"))

(defvar fira-code-mode--old-prettify-alist)

(defun fira-code-mode--enable ()
  "Enable Fira Code ligatures in current buffer."
  (setq-local fira-code-mode--old-prettify-alist prettify-symbols-alist)
  (setq-local prettify-symbols-alist (append (fira-code-mode--make-alist fira-code-mode--ligatures) fira-code-mode--old-prettify-alist))
  (prettify-symbols-mode t))

(defun fira-code-mode--disable ()
  "Disable Fira Code ligatures in current buffer."
  (setq-local prettify-symbols-alist fira-code-mode--old-prettify-alist)
  (prettify-symbols-mode -1))

(define-minor-mode fira-code-mode
  "Fira Code ligatures minor mode"
  :lighter " Fira Code"
  (setq-local prettify-symbols-unprettify-at-point 'right-edge)
  (if fira-code-mode
      (fira-code-mode--enable)
    (fira-code-mode--disable)))

(defun fira-code-mode--setup ()
  "Setup Fira Code Symbols"
  (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol"))

(provide 'fira-code-mode)

(if (eq system-type 'darwin)
    (mac-auto-operator-composition-mode)
  (add-hook 'prog-mode-hook 'fira-code-mode))



;; Load secret configuration if the file is present
(if (file-exists-p "~/.spacemacs.secret")
    (load "~/.spacemacs.secret")
    (message "secret config not found")
    )
)

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("cd736a63aa586be066d5a1f0e51179239fe70e16a9f18991f6f5d99732cabb32" "d1b4990bd599f5e2186c3f75769a2c5334063e9e541e37514942c27975700370" "a3fa4abaf08cc169b61dea8f6df1bbe4123ec1d2afeb01c17e11fdc31fc66379" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "fd944f09d4d0c4d4a3c82bd7b3360f17e3ada8adf29f28199d09308ba01cc092" "6d589ac0e52375d311afaa745205abb6ccb3b21f6ba037104d71111e7e76a3fc" "f0dc4ddca147f3c7b1c7397141b888562a48d9888f1595d69572db73be99a024" "6b2636879127bf6124ce541b1b2824800afc49c6ccd65439d6eb987dbf200c36" default)))
 '(delete-selection-mode nil)
 '(evil-want-Y-yank-to-eol nil)
 '(fci-rule-color "#5B6268" t)
 '(jdee-db-active-breakpoint-face-colors (cons "#1B2229" "#51afef"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1B2229" "#98be65"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1B2229" "#3f444a"))
 '(objed-cursor-color "#ff6c6b")
 '(package-selected-packages
   (quote
    (lsp-mode nginx-mode forge ghub closql emacsql-sqlite emacsql treepy tide typescript-mode tablist docker-tramp web-mode tagedit slim-mode scss-mode sass-mode pug-mode helm-css-scss haml-mode emmet-mode company-web web-completion-data web-beautify livid-mode skewer-mode simple-httpd json-mode json-snatcher json-reformat js2-refactor multiple-cursors js2-mode js-doc company-tern dash-functional tern coffee-mode yaml-mode company-shell smeargle orgit org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-mime org-download mmm-mode markdown-toc markdown-mode magit-gitflow magit-popup htmlize helm-gitignore gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter gh-md flyspell-correct-helm flyspell-correct flycheck-pos-tip pos-tip evil-magit magit transient git-commit with-editor diff-hl auto-dictionary flycheck-haskell flycheck-elixir flycheck-elm company-go xterm-color shell-pop multi-term helm-company helm-c-yasnippet fuzzy eshell-z eshell-prompt-extras esh-help company-statistics company-cabal auto-yasnippet ac-ispell auto-complete all-the-icons memoize yarn-mode intero hlint-refactor hindent helm-hoogle haskell-snippets yasnippet company-ghci company-ghc ghc haskell-mode cmm-mode ob-elixir flycheck-mix flycheck-credo flycheck company elixir-mode doom-themes elm-mode reformatter alchemist docker-compose-mode dockerfile-mode docker ws-butler winum which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox org-plus-contrib org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint indent-guide hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-indentation helm-themes helm-swoop helm-projectile helm-mode-manager helm-make helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu elisp-slime-nav dumb-jump diminish define-word column-enforce-mode clean-aindent-mode auto-highlight-symbol auto-compile aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line)))
 '(vc-annotate-background "#282c34")
 '(vc-annotate-color-map
   (list
    (cons 20 "#98be65")
    (cons 40 "#b4be6c")
    (cons 60 "#d0be73")
    (cons 80 "#ECBE7B")
    (cons 100 "#e6ab6a")
    (cons 120 "#e09859")
    (cons 140 "#da8548")
    (cons 160 "#d38079")
    (cons 180 "#cc7cab")
    (cons 200 "#c678dd")
    (cons 220 "#d974b7")
    (cons 240 "#ec7091")
    (cons 260 "#ff6c6b")
    (cons 280 "#cf6162")
    (cons 300 "#9f585a")
    (cons 320 "#6f4e52")
    (cons 340 "#5B6268")
    (cons 360 "#5B6268")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("cd736a63aa586be066d5a1f0e51179239fe70e16a9f18991f6f5d99732cabb32" "d1b4990bd599f5e2186c3f75769a2c5334063e9e541e37514942c27975700370" "a3fa4abaf08cc169b61dea8f6df1bbe4123ec1d2afeb01c17e11fdc31fc66379" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "fd944f09d4d0c4d4a3c82bd7b3360f17e3ada8adf29f28199d09308ba01cc092" "6d589ac0e52375d311afaa745205abb6ccb3b21f6ba037104d71111e7e76a3fc" "f0dc4ddca147f3c7b1c7397141b888562a48d9888f1595d69572db73be99a024" "6b2636879127bf6124ce541b1b2824800afc49c6ccd65439d6eb987dbf200c36" default)))
 '(delete-selection-mode nil)
 '(evil-want-Y-yank-to-eol nil)
 '(fci-rule-color "#5B6268" t)
 '(hl-todo-keyword-faces
   (quote
    (("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#4f97d7")
     ("OKAY" . "#4f97d7")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f"))))
 '(jdee-db-active-breakpoint-face-colors (cons "#1B2229" "#51afef"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1B2229" "#98be65"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1B2229" "#3f444a"))
 '(objed-cursor-color "#ff6c6b")
 '(package-selected-packages
   (quote
    (toml-mode racer helm-gtags ggtags flycheck-rust counsel-gtags counsel swiper ivy cargo rust-mode lsp-mode nginx-mode forge ghub closql emacsql-sqlite emacsql treepy tide typescript-mode tablist docker-tramp web-mode tagedit slim-mode scss-mode sass-mode pug-mode helm-css-scss haml-mode emmet-mode company-web web-completion-data web-beautify livid-mode skewer-mode simple-httpd json-mode json-snatcher json-reformat js2-refactor multiple-cursors js2-mode js-doc company-tern dash-functional tern coffee-mode yaml-mode company-shell smeargle orgit org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-mime org-download mmm-mode markdown-toc markdown-mode magit-gitflow magit-popup htmlize helm-gitignore gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter gh-md flyspell-correct-helm flyspell-correct flycheck-pos-tip pos-tip evil-magit magit transient git-commit with-editor diff-hl auto-dictionary flycheck-haskell flycheck-elixir flycheck-elm company-go xterm-color shell-pop multi-term helm-company helm-c-yasnippet fuzzy eshell-z eshell-prompt-extras esh-help company-statistics company-cabal auto-yasnippet ac-ispell auto-complete all-the-icons memoize yarn-mode intero hlint-refactor hindent helm-hoogle haskell-snippets yasnippet company-ghci company-ghc ghc haskell-mode cmm-mode ob-elixir flycheck-mix flycheck-credo flycheck company elixir-mode doom-themes elm-mode reformatter alchemist docker-compose-mode dockerfile-mode docker ws-butler winum which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox org-plus-contrib org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint indent-guide hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-indentation helm-themes helm-swoop helm-projectile helm-mode-manager helm-make helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu elisp-slime-nav dumb-jump diminish define-word column-enforce-mode clean-aindent-mode auto-highlight-symbol auto-compile aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line)))
 '(pdf-view-midnight-colors (quote ("#b2b2b2" . "#292b2e")))
 '(safe-local-variable-values
   (quote
    ((haskell-process-use-ghci . t)
     (haskell-indent-spaces . 4)
     (javascript-backend . tern)
     (javascript-backend . lsp)
     (elixir-enable-compilation-checking . t)
     (elixir-enable-compilation-checking))))
 '(vc-annotate-background "#282c34")
 '(vc-annotate-color-map
   (list
    (cons 20 "#98be65")
    (cons 40 "#b4be6c")
    (cons 60 "#d0be73")
    (cons 80 "#ECBE7B")
    (cons 100 "#e6ab6a")
    (cons 120 "#e09859")
    (cons 140 "#da8548")
    (cons 160 "#d38079")
    (cons 180 "#cc7cab")
    (cons 200 "#c678dd")
    (cons 220 "#d974b7")
    (cons 240 "#ec7091")
    (cons 260 "#ff6c6b")
    (cons 280 "#cf6162")
    (cons 300 "#9f585a")
    (cons 320 "#6f4e52")
    (cons 340 "#5B6268")
    (cons 360 "#5B6268")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)
