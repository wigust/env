(doom! 
 :ui
 doom
 doom-dashboard
 (emoji +unicode +ascii +github)
 modeline
 ophints
 minimap
 (:if IS-MAC (ligatures +fira))
 hl-todo
 workspaces
 (window-select +numbers)
 vi-tilde-fringe
 vc-gutter
 tabs
 (popups +defaults +all)
 treemacs
 nav-flash
 unicode

 :config
 (default +bindings +smartparens)

 :editor
 evil
 fold
 multiple-cursors
 (format +onsave)
 (parinfer +rust)
 snippets

 :emacs
 (dired +ranger +icons)
 (ibuffer +icons)
 (undo +tree)
 vc

 :completion
 (company +childframe)
 (ivy +childframe +fuzzy +icons +prescient)

 :checkers
 (spell +aspell)
 (syntax +childframe)

 :term
 vterm

 :tools
 debugger
 direnv
 (docker +lsp)
 (eval +overlay)
 (lookup +docsets)
 (lsp +peek)
 (magit +forge)
 prodigy
 terraform
 ;;jira

 :os
 (:if IS-MAC macos)

 :app
 calendar
 (:if IS-LINUX everywhere)
 irc

 :lang
 (cc +lsp)
 (haskell +lsp)
 (javascript +lsp)
 (markdown +grip)
 (org +brain +dragndrop +pandoc +present +pretty +roam)
 (purescript +lsp)
 (python +lsp +pyright +poetry +cython (:if IS-MAC +pyenv))
 (sh +lsp)
 (web +lsp)
 (dart +flutter +lsp)
 data  ;; CSV, etc
 elm
 emacs-lisp
 hy
 json
 nix
 plantuml
 ;;tdf
 yaml)
