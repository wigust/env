(after! doom-themes
  (setq doom-theme 'doom-one)
  (setq doom-unicode-font (font-spec :family "FiraCode Nerd Font Mono")))
(after! which-key
  (setq which-key-idle-delay 0.15)
  (setq which-key-idle-secondary-delay 0.15))
(after! '(direnv lsp)
  (advice-add 'lsp :before #'direnv-update-environment)
  (setq lsp-enable-completion-at-point t))
(after! jira
  (setq jiralib2-url              "https://tracker.morsecorp.com"
        jiralib2-auth             'basic
        jiralib2-user-login-name  "bbuscarino"
        jiralib2-token            nil

        ejira-org-directory       "~/.jira"
        ejira-projects            '("MATE")

        ejira-priorities-alist    '(("Highest" . ?A)
                                    ("High"    . ?B)
                                    ("Medium"  . ?C)
                                    ("Low"     . ?D)
                                    ("Lowest"  . ?E))
        ejira-todo-states-alist   '(("To Do"       . 1)
                                    ("In Progress" . 2)
                                    ("Done"        . 3))))
(after! '(haskell format)
  (setq-hook! 'haskell-mode-hook +format-with 'ormolu))

(after! '( format)
  (setq-hook! 'nix-mode-hook +format-with 'nixpkgs-fmt))

(use-package! graphql-mode
  :mode ("\\.gql\\'" "\\.graphql\\'")
  :config (setq-hook! 'graphql-mode-hook tab-width graphql-indent-level))
