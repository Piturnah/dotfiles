;; Welcome to my emacs config
;; It is very much cobbled together, hosted on github for personal use
;; Use on your own machine at your own risk

;;; Code:
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

(use-package smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; Old M-x
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(setq display-line-numbers 'relative)

(use-package rustic)
;;  :bind (:map rustic-mode-map
;;	      ("M-j" . lsp-ui-imenu)
;;              ("M-?" . lsp-find-references)
;;              ("C-c C-c l" . flycheck-list-errors)
;;              ("C-c C-c r" . lsp-rename))
;;  :config
;;  (setq rustic-format-on-save t))
;;
(use-package lsp-mode
  :commands lsp)
;;
;;(use-package lsp-ui
;;  :commands lsp-ui-mode)
;;  (lsp-ui-peek-always-show nil)
;;  (lsp-ui-sideline-show-hover t)
;;  (lsp-ui-doc-enable-nil))

(use-package rainbow-mode)
(use-package projectile)

(setq inhibit-startup-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(ido-mode 1)
(use-package gruber-darker-theme)
(use-package gruvbox-theme)

(put 'upcase-region 'disabled nil)

;; Multiple cursors
(global-set-key (kbd "C-c m c") 'mc/edit-lines)

(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(put 'downcase-region 'disabled nil)

;; --------------------------------------------------------------------------------
;; v Disabled for now, refer to https://github.com/elizagamedev/unity.el/issues/6 v
;; --------------------------------------------------------------------------------

;; (setenv "FrameworkPathOverride" "/lib/mono/4.5")
;; (add-to-list 'load-path "~/.emacs.d/unity.el/")
;; (require 'unity)
;; (add-hook 'after-init-hook #'unity-build-code-shim)
;; (add-hook 'after-init-hook #'unity-setup)
;; (require 'lsp-mode)
;; (use-package csharp-mode
;;   :init
;;   (defun pit/csharp-mode-hook ()
;;     (setq-local lsp-auto-guess-root t)
;;     (lsp))
;;   (add-hook 'csharp-mode-hook #'pit/csharp-mode-hook))

(use-package csharp-mode)

;; for completions
;;(use-package company-lsp
;;  :after lsp-mode
;;  :config (push 'company-lsp company-backends))

(use-package vue-mode
  :mode "\\.vue\\'"
  :config
  (add-hook 'vue-mode-hook #'lsp))

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

(add-to-list 'load-path "~/.emacs.d/org/")
(require 'org-variable-pitch)
(add-to-list 'load-path "~/.emacs.d/fodder")
(require 'fodder-theme)
(add-to-list 'load-path "~/.emacs.d/custom-lang-modes")
(require 'noq-mode)

(defun pit/org-mode-setup()
  (org-variable-pitch-minor-mode))
;;  (display-line-numbers-mode 0))

(use-package org
  :hook (org-mode . pit/org-mode-setup)
  :config
  (setq org-ellipsis " ▿"
	org-hide-emphasis-markers t))
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("•" "◦")))

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

(use-package flycheck)
(global-flycheck-mode)

;; auto revert files on change
(global-auto-revert-mode t)

(show-paren-mode t)

;; non-verbose dired auto revert
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(use-package rjsx-mode)
(require 'rjsx-mode)
(use-package typescript-mode)
(require 'typescript-mode)
(use-package web-mode)
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(use-package tide)
(require 'tide)
(use-package company
  :custom
  (company-minimum-prefix-length 1)
  (company--idle-delay 0.0))
(require 'company)
(use-package yasnippet)
(require 'yasnippet)
(use-package prettier)
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
(use-package tex
	     :ensure auctex)
(require 'tex-site)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(use-package latex-pretty-symbols)
(add-hook 'org-mode-hook 'latex-unicode-simplified)
(remove-hook 'LaTeX-mode-hook 'latex-unicode-simplified)

;; Custom keybinding `C-0 b` for `\mathbb{}` on prev letters
(fset 'pit/mathbb
(kmacro-lambda-form [?\C-b ?\\ ?m ?a ?t ?h ?b ?b ?\{ ?\C-f ?\}] 0 "%d"))
(add-hook 'LaTeX-mode-hook
          (lambda () (local-set-key (kbd "C-0 b") #'pit/mathbb)))

(use-package magit)
(use-package multiple-cursors)
(use-package vue-mode)
(use-package haskell-mode)

(use-package mentor)

(use-package darkokai-theme)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(compilation-message-face 'default)
 '(custom-enabled-themes '(gruber-darker))
 '(custom-safe-themes
   '("70936e3b54ca6d668354fdc87eea5f0a5129380c0c459598be943efba6ae1563" "bfac9f5b962572739db905a07a2d8d32b25258cd67826727d354013b63d8529e" "d14f3df28603e9517eb8fb7518b662d653b25b26e83bd8e129acea042b774298" "83e0376b5df8d6a3fbdfffb9fb0e8cf41a11799d9471293a810deb7586c131e6" "7661b762556018a44a29477b84757994d8386d6edee909409fabe0631952dad9" "6b5c518d1c250a8ce17463b7e435e9e20faa84f3f7defba8b579d4f5925f60c1" "94bf3521824de75820b9e730eda5b45287e7b33a32ffaf0f2b9ab6365687b8a3" "0cd00c17f9c1f408343ac77237efca1e4e335b84406e05221126a6ee7da28971" "3d2e532b010eeb2f5e09c79f0b3a277bfc268ca91a59cdda7ffd056b868a03bc" "c8b83e7692e77f3e2e46c08177b673da6e41b307805cd1982da9e2ea2e90e6d7" default))
 '(fci-rule-color "#323342")
 '(frame-brackground-mode 'dark)
 '(highlight-changes-colors '("#ff8eff" "#ab7eff"))
 '(highlight-tail-colors
   '(("#323342" . 0)
     ("#63de5d" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#323342" . 100)))
 '(magit-diff-use-overlays nil)
 '(package-selected-packages
   '(lavender-theme shades-of-purple-theme mentor latex-pretty-symbols pretty-mode gruvbox-theme csharp-mode lsp-ui rustic rust-mode general rainbow-mode org-bullets projectile auctex prettier company rjsx-mode tide web-mode yasnippet flycheck multiple-cursors mozc scss-mode magit gruber-darker-theme typescript-mode vue-mode company-lsp lsp-mode haskell-mode monokai-pro-theme smex))
 '(pdf-view-midnight-colors '("#fdf4c1" . "#1d2021"))
 '(pos-tip-background-color "#E6DB74")
 '(pos-tip-foreground-color "#242728")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   '((20 . "#ff0066")
     (40 . "#CF4F1F")
     (60 . "#C26C0F")
     (80 . "#E6DB74")
     (100 . "#AB8C00")
     (120 . "#A18F00")
     (140 . "#989200")
     (160 . "#8E9500")
     (180 . "#63de5d")
     (200 . "#729A1E")
     (220 . "#609C3C")
     (240 . "#4E9D5B")
     (260 . "#3C9F79")
     (280 . "#53f2dc")
     (300 . "#299BA6")
     (320 . "#2896B5")
     (340 . "#2790C3")
     (360 . "#06d8ff")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (unspecified "#242728" "#323342" "#F70057" "#ff0066" "#86C30D" "#63de5d" "#BEB244" "#E6DB74" "#40CAE4" "#06d8ff" "#FF61FF" "#ff8eff" "#00b2ac" "#53f2dc" "#f8fbfc" "#ffffff")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
