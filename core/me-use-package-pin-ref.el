;; me-use-package-pin-ref.el --- Extend use-package to allow straight-x package pinning -*- lexical-binding: t; -*-

;; Copyright (C) 2022-2023  Abdelhak Bougouffa

;; Author: Abdelhak Bougouffa (concat "abougouffa" "@" "fedora" "project" "." "org")

;;; Commentary:

;; Add support for pinning versions of individual packages. See:
;; github.com/radian-software/straight.el#how-do-i-pin-package-versions-or-use-only-tagged-releases

;;; Code:

(with-eval-after-load 'straight
  ;; Add a profile (and lockfile) for stable package revisions.
  (add-to-list 'straight-profiles '(pinned . "pinned.el"))
  (require 'straight-x))

;; Allow pinning versions from `use-package' using the `:pin-ref' keyword
(with-eval-after-load 'use-package-core
  (add-to-list 'use-package-keywords :pin-ref)

  (defun use-package-normalize/:pin-ref (_name-symbol keyword args)
    (use-package-only-one (symbol-name keyword) args
      (lambda (_label arg)
        (cond
         ((stringp arg) arg)
         ((symbolp arg) (symbol-name arg))
         (t (use-package-error ":pin-ref wants a commit hash or a ref."))))))

  (defun use-package-handler/:pin-ref (name-symbol _keyword ref rest state)
    (let ((body (use-package-process-keywords name-symbol rest state)))
      (if (null ref)
          body
        `((let ((straight-current-profile 'pinned))
           (push '(,(symbol-name name-symbol) . ,ref) straight-x-pinned-packages)
           ,(macroexp-progn body)))))))


(provide 'me-use-package-pin-ref)

;;; me-use-package-pin-ref.el ends here
