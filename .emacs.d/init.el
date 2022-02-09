

(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
	("org" . "https://orgmode.org/elpa/")
        ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Bootstrap 'use-package'
(eval-after-load 'gnutls
  '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; Old M-x
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(setq display-line-numbers 'relative)

(setq inhibit-startup-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(ido-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes '(gruber-darker))
 '(custom-safe-themes
   '("3d2e532b010eeb2f5e09c79f0b3a277bfc268ca91a59cdda7ffd056b868a03bc" "c8b83e7692e77f3e2e46c08177b673da6e41b307805cd1982da9e2ea2e90e6d7" default))
 '(frame-brackground-mode 'dark)
 '(package-selected-packages
   '(auctex prettier company rjsx-mode tide web-mode yasnippet flycheck multiple-cursors mozc scss-mode magit gruber-darker-theme typescript-mode vue-mode company-lsp lsp-mode haskell-mode monokai-pro-theme smex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)

;; Multiple cursors
(global-set-key (kbd "C-c m c") 'mc/edit-lines)

(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(put 'downcase-region 'disabled nil)

(require 'lsp-mode)

(use-package lsp-mode
  :commands lsp)

;; for completions
;;(use-package company-lsp
;;  :after lsp-mode
;;  :config (push 'company-lsp company-backends))

(use-package vue-mode
  :mode "\\.vue\\'"
  :config
  (add-hook 'vue-mode-hook #'lsp))

(use-package org)

(add-hook 'mmm-mode-hook
	  (lambda ()
	    (set-face-background 'mmm-default-submode-face nil)))

;; (use-package mozc
;;   :init
;;   (setq default-input-method "japanese-mozc")
;;   :custom
;;   (mozc-candidate-style 'overlay))
(put 'scroll-left 'disabled nil)

(setq c-default-style "linux"
      c-basic-offset 4)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

(global-flycheck-mode)

;; auto revert files on change
(global-auto-revert-mode t)

;; non-verbose dired auto revert
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(require 'rjsx-mode)
(require 'typescript-mode)
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(require 'tide)
(require 'company)
(require 'yasnippet)
(require 'prettier)

 ;; tide def func: (https://dev.to/viglioni/how-i-set-up-my-emacs-for-typescript-3eeh)
 (defun tide-setup-hook ()
    (tide-setup)
    (eldoc-mode)
    (tide-hl-identifier-mode +1)
    (setq web-mode-enable-auto-quoting nil)
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-attr-indent-offset 2)
    (setq web-mode-attr-value-indent-offset 2)
    (setq lsp-eslint-server-command '("node" (concat (getenv "HOME") "/var/src/vscode-eslint/server/out/eslintServer.js") "--stdio"))
    (set (make-local-variable 'company-backends)
         '((company-tide company-files :with company-yasnippet)
           (company-dabbrev-code company-dabbrev))))

;; hooks
(add-hook 'before-save-hook 'tide-format-before-save)


;; use rjsx-mode for .js* files except json and use tide with rjsx
(add-to-list 'auto-mode-alist '("\\.js.*$" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))
(add-hook 'rjsx-mode-hook 'tide-setup-hook)


;; web-mode extra config
(add-hook 'web-mode-hook 'tide-setup-hook
          (lambda () (pcase (file-name-extension buffer-file-name)
                  ("tsx" ('tide-setup-hook))
                  (_ (my-web-mode-hook)))))
(flycheck-add-mode 'typescript-tslint 'web-mode)
(add-hook 'web-mode-hook 'company-mode)
(add-hook 'web-mode-hook 'prettier-mode)
(add-hook 'web-mode-hook #'turn-on-smartparens-mode t)
 ;; ...

;; yasnippet
(yas-global-mode 1)

;; flycheck
(global-flycheck-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)

;; company-mode
(global-company-mode)

(add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets/")
(yas-global-mode 1)

(add-hook 'typescript-mode-hook 'prettier-mode)
(add-hook 'scss-mode-hook 'prettier-mode)

;; AUCTeX
(require 'tex-site)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(provide 'init)
;;; init.el ends here
