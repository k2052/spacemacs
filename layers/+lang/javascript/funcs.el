;;; funcs.el --- Javascript Layer functions File for Spacemacs
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Muneeb Shaikh <muneeb@reversehack.in>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3


;; backend

(defun spacemacs//javascript-setup-backend ()
  "Conditionally setup javascript backend."
  (pcase javascript-backend
    (`tern (spacemacs//javascript-setup-tern))
    (`lsp (spacemacs//javascript-setup-lsp))))

(defun spacemacs//javascript-setup-company ()
  "Conditionally setup company based on backend."
  (pcase javascript-backend
    (`tern (spacemacs//javascript-setup-tern-company))
    (`lsp (spacemacs//javascript-setup-lsp-company))))

(defun spacemacs//javascript-setup-next-error-fn ()
  "If the `syntax-checking' layer is enabled, then disable `js2-mode''s
`next-error-function', and let `flycheck' handle any errors."
  (when (configuration-layer/layer-used-p 'syntax-checking)
    (setq-local next-error-function nil)))

;; lsp

(defun spacemacs//javascript-setup-lsp ()
  "Setup lsp backend."
  (if (configuration-layer/layer-used-p 'lsp)
      (progn
        (when (not javascript-lsp-linter)
          (setq-local lsp-prefer-flymake :none))
        (lsp))
    (message (concat "`lsp' layer is not installed, "
                     "please add `lsp' layer to your dotfile."))))

(defun spacemacs//javascript-setup-lsp-company ()
  "Setup lsp auto-completion."
  (if (configuration-layer/layer-used-p 'lsp)
      (progn
        (spacemacs|add-company-backends
          :backends company-lsp
          :modes js2-mode
          :append-hooks nil
          :call-hooks t)
        (company-mode))
    (message (concat "`lsp' layer is not installed, "
                     "please add `lsp' layer to your dotfile."))))


;; tern
(defun spacemacs//javascript-setup-tern ()
  (if (configuration-layer/layer-used-p 'tern)
      (when (locate-file "tern" exec-path)
        (spacemacs/tern-setup-tern))
    (message (concat "Tern was configured as the javascript backend but "
                     "the `tern' layer is not present in your `.spacemacs'!"))))

(defun spacemacs//javascript-setup-tern-company ()
  (if (configuration-layer/layer-used-p 'tern)
      (when (locate-file "tern" exec-path)
        (spacemacs/tern-setup-tern-company 'js2-mode))
    (message (concat "Tern was configured as the javascript backend but "
                     "the `tern' layer is not present in your `.spacemacs'!"))))


;; js-doc

(defun spacemacs/js-doc-require ()
  "Lazy load js-doc"
  (require 'js-doc))
(add-hook 'js2-mode-hook 'spacemacs/js-doc-require)

(defun spacemacs/js-doc-set-key-bindings (mode)
  "Setup the key bindings for `js2-doc' for the given MODE."
  (spacemacs/declare-prefix-for-mode mode "mrd" "documentation")
  (spacemacs/set-leader-keys-for-major-mode mode
    "rdb" 'js-doc-insert-file-doc
    "rdf" (if (configuration-layer/package-used-p 'yasnippet)
              'js-doc-insert-function-doc-snippet
            'js-doc-insert-function-doc)
    "rdt" 'js-doc-insert-tag
    "rdh" 'js-doc-describe-tag))

;; js-refactor

(defun spacemacs/js2-refactor-require ()
  "Lazy load js2-refactor"
  (require 'js2-refactor))

(defun spacemacs/js2-indium-require ()
  "lazy require indium"
  (require 'indium))
