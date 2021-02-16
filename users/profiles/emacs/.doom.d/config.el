(after! doom-themes
  (setq doom-theme 'doom-one)
  (setq doom-unicode-font (font-spec :family "FiraCode Nerd Font Mono")))
(after! which-key
  (setq which-key-idle-delay 0.15)
  (setq which-key-idle-secondary-delay 0.15))
(after! '(direnv lsp)
  (advice-add 'lsp :before #'direnv-update-environment)
  (setq lsp-enable-completion-at-point t))
