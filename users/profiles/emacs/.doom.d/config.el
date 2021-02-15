(after! doom-themes
  (setq doom-theme 'doom-one)
  (setq doom-unicode-font (font-spec :family "Fira Mono")))
(after! which-key
  (setq which-key-idle-delay 0.05)
  (setq which-key-idle-secondary-delay 0.05))
(after! '(direnv lsp)
  (advice-add 'lsp :before #'direnv-update-environment)
  (setq lsp-enable-completion-at-point t))
