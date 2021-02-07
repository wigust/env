(setq doom-theme 'doom-one)
(setq doom-unicode-font (font-spec :family "Fira Mono"))
(setq which-key-idle-delay 0.05)
(setq which-key-idle-secondary-delay 0.05)


(after! magit
  (setq magit-repository-directories
        '(;; Directory containing project root directories
          ("~/development/"      . 3)
          ("~/Development/"      . 3)
          ;; Specific project root directory
          ("~/env/" . 1)))
  (after! projectile
    (mapc #'projectile-add-known-project
          (mapcar #'file-name-as-directory (magit-list-repositories)))
    ;; Optionally write to persistent `projectile-known-projects-file'
    (projectile-save-known-projects)))
