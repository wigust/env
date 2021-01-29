(doom! 
       :ui
       doom
       doom-dashboard
       (emoji +unicode +ascii +github)
       modeline
       ophints
       minimap
       (ligatures +extra +fira)
       hl-todo
       workspaces
       (window-select +numbers)
       vi-tilde-fringe
       vc-gutter
       tabs
       (popups +defaults)
       treemacs
       nav-flash

       :config
       default

       :editor
       evil
       fold
       format
       parinfer
       snippets

       :emacs
       (dired +ranger +icons)
       (ibuffer +icons)
       (undo +tree)
       vc

       :completion
       (company +childframe)
       helm

       :checkers
       spell
       syntax

       :app
       calendar
       ;;irc

       :term
       shell
       term
       vshell

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
       
       :os
       (:if IS-MAC macos)

       :email
       ;notmuch

       :lang
       (python +lsp +pyright +pyenv +poetry +cython)
       json
       data  ;; CSV, etc
       nix
       emacs-lisp
       (org +brain +pandoc +present +pretty +roam)
       web
       (markdown +grip)
       (javascript +lsp)
       hy
       yaml
       (purescript +lsp)
       (sh +lsp)

       (haskell +lsp))