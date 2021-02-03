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
 (default +bindings +smartparens)

 :editor
 evil
 fold
 (format +onsave)
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

 :term
 eshell
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

 :os
 (:if IS-MAC macos)

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
 elm
 (sh +lsp)
 (haskell +lsp))
