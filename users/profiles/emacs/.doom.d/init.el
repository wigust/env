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
 parinfer
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

 :os
 (:if IS-MAC macos)

 :app
 calendar
 everywhere

 :lang
 (python +lsp +pyright +poetry +cython (:if IS-MAC +pyenv))
 json
 data  ;; CSV, etc
 nix
 emacs-lisp
 (org +brain +dragndrop +pandoc +present +pretty +roam)
 web
 (markdown +grip)
 (javascript +lsp)
 hy
 yaml
 (purescript +lsp)
 elm
 (sh +lsp)
 (haskell +lsp))
