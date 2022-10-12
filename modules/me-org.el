;;; me-org.el --- Org related stuff -*- lexical-binding: t; -*-

;; Copyright (C) 2022  Abdelhak Bougouffa

;; Author: Abdelhak Bougouffa <abougouffa@fedoraproject.org>

(use-package org
  :straight t
  :after minemacs-loaded ;; load Org after finishing Emacs startup
  :general
  (me-map-local :keymaps 'org-mode-map
    "l"  '(nil :which-key "link")
    "ll" '(org-insert-link :which-key "Insert link")
    "e" '(org-export-dispatch :which-key "Export dispatch"))
  :preface
  ;; Set to nil so we can detect user changes (in config.el)
  (defvar org-directory nil)
  (defvar org-id-locations-file nil)
  (defvar org-attach-id-dir nil)
  (defvar org-babel-python-command nil)
  (setq org-persist-directory (expand-file-name "org/persist/" minemacs-cache-dir)
        org-publish-timestamp-directory (expand-file-name "org/timestamps/" minemacs-cache-dir)
        org-preview-latex-image-directory (expand-file-name "org/latex/" minemacs-cache-dir)
        org-list-allow-alphabetical t)
  (let ((dir (expand-file-name "org/" minemacs-cache-dir)))
    (unless (file-directory-p dir)
      (mkdir dir t)))
  :custom
  (org-tags-column 0)
  (org-auto-align-tags nil)
  (org-fold-catch-invisible-edits 'smart) ;; try not to accidently do weird stuff in invisible regions
  (org-pretty-entities-include-sub-superscripts nil)
  (org-fontify-quote-and-verse-blocks t)
  (org-special-ctrl-a/e t)
  (org-insert-heading-respect-content t)
  (org-hide-emphasis-markers t)
  (org-use-property-inheritance t) ; it's convenient to have properties inherited
  (org-ellipsis " ↩")
  (org-log-done 'time)             ; having the time an item is done sounds convenient
  (org-list-allow-alphabetical t)  ; have a. A. a) A) list bullets
  (org-export-in-background nil)   ; run export processes in external emacs process

  :config
  (setq org-export-async-debug t) ;; Can be useful!

  (let ((size 1.3))
    (dolist (face '(org-level-1 org-level-2 org-level-3 org-level-4 org-level-5))
      (set-face-attribute face nil :weight 'semi-bold :height size)
      (setq size (max (* size 0.9) 1.0)))))


(use-package org-contrib
  :straight t
  :after org)


(use-package ox-latex
  :after org
  :custom
  (org-latex-prefer-user-labels t)
  ;; Default `minted` options, can be overwritten in file/dir locals
  (org-latex-minted-options
   '(("frame"         "lines")
     ("fontsize"      "\\footnotesize")
     ("tabsize"       "2")
     ("breaklines"    "true")
     ("breakanywhere" "true") ;; break anywhere, no just on spaces
     ("style"         "default")
     ("bgcolor"       "GhostWhite")
     ("linenos"       "true")))
  :config
  ;; Map some org-mode blocks' languages to lexers supported by minted
  ;; you can see supported lexers by running this command in a terminal:
  ;; 'pygmentize -L lexers'
  (dolist (pair '((ipython    "python")
                  (jupyter    "python")
                  (scheme     "scheme")
                  (lisp-data  "lisp")
                  (conf-unix  "unixconfig")
                  (conf-space "unixconfig")
                  (authinfo   "unixconfig")
                  (gdb-script "unixconfig")
                  (conf-toml  "yaml")
                  (conf       "ini")
                  (conf       "ini")
                  (gitconfig  "ini")
                  (systemd    "ini")))
    (unless (member pair org-latex-minted-langs)
      (add-to-list 'org-latex-minted-langs pair))))


(use-package ob-tangle
  :after org)


(use-package ox-extra
  :config
  (ox-extras-activate '(latex-header-blocks ignore-headlines)))


(use-package me-org-extras
  :after org
  :config
  (me-org-extras-setup))


(use-package org-appear
  :straight t
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autoemphasis t)
  (org-appear-autosubmarkers t)
  (org-appear-autolinks nil)
  :config
  ;; for proper first-time setup, `org-appear--set-elements'
  ;; needs to be run after other hooks have acted.
  (run-at-time nil nil #'org-appear--set-elements))


(use-package org-modern
  :straight t
  :hook (org-mode . org-modern-mode)
  :custom
  (org-modern-star '("◉" "○" "◈" "◇" "✳" "◆" "✸" "▶"))
  (org-modern-table-vertical 5)
  (org-modern-table-horizontal 2)
  (org-modern-list '((43 . "➤") (45 . "–") (42 . "•")))
  (org-modern-block-fringe nil))


;; for latex fragments
(use-package org-fragtog
  :straight t
  :hook (org-mode . org-fragtog-mode))


(provide 'me-org)

;;; me-org.el ends here
