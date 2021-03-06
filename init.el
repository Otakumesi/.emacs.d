;;; init.el --- initialize file.
;;; Commentary:
;;; Code:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;;(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
;;(el-get 'sync)

(el-get-bundle fullscreen)
(el-get-bundle fuzzy)
(el-get-bundle dash)
(el-get-bundle emacs-async)
(el-get-bundle deferred)
(el-get-bundle use-package)
(require 'use-package)

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(setq gc-cons-threshold (* 128 1024 1024))
(when (eq system-type 'darwin)
  (setq ns-command-modifier (quote meta)))

;; shell
(el-get-bundle purcell/exec-path-from-shell)
(use-package exec-path-from-shell
  :config
  (setq explicit-shell-file-name "/usr/local/bin/zsh")
  (setq shell-file-name "zsh")
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  (exec-path-from-shell-copy-env "GOPATH"))
;; (load-file "~/.emacs.d/shellenv.el")

;; Magitの読み込み
(el-get-bundle magit/magit)
(add-to-list 'load-path "~/.emacs.d/el-get/magit/lisp")
(use-package magit
  :config
  (global-set-key (kbd "M-m") prefix-arg)
  (global-set-key (kbd "M-m m") 'magit-status)
  (global-set-key (kbd "M-m i") 'magit-init))

(el-get-bundle purcell/package-lint)
(use-package package-lint)

(load (setq custom-file (expand-file-name "custom-val.el" user-emacs-directory)))

;; (el-get-bundle zonuexe/emoji-fontset.el)
;; (use-package emoji-fontset)
;; (emoji-fontset-enable "Symbola")

(el-get-bundle TeMPOraL/nyan-mode)
(use-package nyan-mode
  :config
  (nyan-mode 1))

(defun user-settings ()
  ;; フォント設定
  (set-face-attribute 'default
                      nil
                      :family "Noto Mono for Powerline"
                      :height 160)

  ;; クリップボードの利用
  (cond (window-system
         (setq x-select-enable-clipboard t)))
  (when (eq system-type 'darwin)
    (defun copy-from-osx ()
      (shell-command-to-string "pbpaste"))

    (defun paste-to-osx (text &optional push)
      (let ((process-connection-type nil))
        (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
          (process-send-string proc text)
          (process-send-eof proc))))

    (setq interprogram-cut-function 'paste-to-osx)
    (setq interprogram-paste-function 'copy-from-osx))

  (when (eq system-type 'gnu/linux)
    (el-get-bundle xclip)
    (use-package xclip
      :config
      (turn-on-xclip)))

  (setq whitespace-style '(face
                           trailing
                           tabs
                           spaces
                           empty
                           space-mark
                           tab-mark))

  (setq whitespace-display-mappings
        '((space-mark ?\u3000 [?\u2337])
          (tab-mark ?\t [?\u2337 ?\u2337 ?\u2337 ?\u2337])))

  (global-whitespace-mode 1)

  ;; 対応する括弧を光らせる
  (show-paren-mode 1)
  ;; バッファの終端を明示する
  (setq indicate-empty-lines t)
  ;; yes-noをy-nに置き換え
  (fset 'yes-or-no-p 'y-or-n-p)
  ;; M-xでコマンドを入力する時に候補を表示する
  (icomplete-mode 1)
  ;; status-barにカーソルの位置を表示
  (column-number-mode t)
  ;; インデントをタブからスペースに
  (setq-default indent-tabs-mode nil)
  ;; バックアップファイルを作らない
  (setq backup-inhibited t)
  ;; ファイル名補完で大文字小文字を区別しない
  (setq read-buffer-completion-ignore-case nil)
  (setq read-file-name-completion-ignore-case t)
  ;; cua-mode
  (use-package cua-mode)
  (cua-mode t)
  (setq cua-enable-cua-keys nil)
  (define-key global-map (kbd "C-x SPC") 'cua-set-rectangle-mark)
  ;; 行末の空白をハイライト
  (setq-default show-trailing-whitespace t)

  ;; 単語の移動単位をキャメルケースにも適用
  (global-subword-mode 1))
;; end user-settings

(user-settings)

(unless (eq window-system nil)
  (tool-bar-mode -1))

;; 現在行のハイライト
(use-package hl-line
  :config
  (defun global-hl-line-timer-function ()
    (global-hl-line-unhighlight-all)
    (let ((global-hl-line-mode t))
      (global-hl-line-highlight)))
  (setq global-hl-line-timer
        (run-with-idle-timer 0.03 t 'global-hl-line-timer-function)))


(let ((gls "/usr/local/bin/gls"))
  (if (file-exists-p gls) (setq insert-directory-program gls)))

(setq default-frame-alist
      (append (list '(width . 100)
                    '(height . 48))
              default-frame-alist))

(el-get-bundle restart-emacs)

(el-get-bundle elscreen
  :type git
  :url "https://github.com/shosti/elscreen.git")
(use-package elscreen
  :config
  (elscreen-start)
  (setq elscreen-prefix-key (kbd "C-,"))
  (setq elscreen-tab-display-control nil)
  (setq elscreen-buffer-to-nickname-alist
        '(("^dired-mode$" .
           (lambda ()
             (format "Dired(%s)" dired-directory)))
          ("^Info-mode$" .
           (lambda ()
             (format "Info(%s)" (file-name-nondirectory Info-current-file))))
          ("^mew-draft-mode$" .
           (lambda ()
             (format "Mew(%s)" (buffer-name (current-buffer)))))
          ("^mew-" . "Mew")
          ("^irchat-" . "IRChat")
          ("^liece-" . "Liece")
          ("lookup-" . "Lookup")))
  (setq elscreen-mode-to-nickname-alist
        '(("[Ss]hell" . "shell")
          ("compilation" . "compile")
          ("-telnet" . "telnet")
          ("dict" . "OnlineDict")
          ("*WL:Message*" . "Wanderlust")))

  (global-set-key (kbd "C-<right>") 'elscreen-next)
  (global-set-key (kbd "C-<left>") 'elscreen-previous)
  (global-set-key (kbd "C-c <up>") 'elscreen-clone)
  (global-set-key (kbd "C-c <down>") 'elscreen-kill)
  (global-set-key (kbd "C-c <C-up>") 'elscreen-clone)
  (global-set-key (kbd "C-c <C-down>") 'elscreen-kill))

;; カラーテーマ
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; (el-get-bundle solarized-emacs)
;; use-package solarized
;;  :config
;;  (setq solarized-high-contrast-mode-line t)
;;  (load-theme 'solarized-dark t)
;;  (setq ns-use-srgb-colorspace nil))
(load-theme 'wombat t)

;; key-chordの読み込み
(el-get-bundle key-chord)
(use-package key-chord
  :config
  (key-chord-mode 1))

(el-get-bundle helm)
(use-package helm
  :config
  (helm-mode 1)
  (define-key global-map (kbd "M-x") 'helm-M-x)
  (define-key global-map (kbd "<space>-x") 'helm-M-x)
  (define-key global-map (kbd "C-x C-f") 'helm-find-files)
  (define-key global-map (kbd "C-x C-r") 'helm-recentf)

  (el-get-bundle helm-css-scss)
  (use-package helm-css-scss)

  ;; helm-gtagsの設定
  (el-get-bundle helm-gtags)
  (use-package helm-gtags
    :if (executable-find "global")
    :config
    ;; (add-hook 'c-mode-hook 'helm-gtags-mode)
    (add-hook 'enh-ruby-mode-hook 'helm-gtags-mode)
    (add-hook 'emacs-lisp-mode-hook 'helm-gtags-mode)
    (add-hook 'javascript-mode-hook 'helm-gtags-mode)
    (setq helm-gtags-path-style 'root)
    (setq helm-gtags-auto-update t)
    (add-hook 'helm-gtags-mode-hook
              (lambda ()
                (local-set-key (kbd "C-c g t") 'helm-gtags-find-tag)
                (local-set-key (kbd "C-c g r") 'helm-gtags-find-rtag)
                (local-set-key (kbd "C-c g s") 'helm-gtags-select)
                (local-set-key (kbd "C-c g p") 'helm-gtags-pop-stack)
                (local-set-key (kbd "C-c g c") 'helm-gtags-clear-stack))))

  (use-package helm-ag
    :config
    (if (executable-find "rg")
        (custom-set-variables
         '(helm-ag-base-command "rg --no-heading"))))

  (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action))


;; projectile
(el-get-bundle projectile)
(use-package projectile
  :config
  (el-get-bundle helm-projectile)
  (use-package helm-projectile
    :config
    (setq projectile-completion-system 'helm)
    (helm-projectile-on))
  (projectile-global-mode)
  (el-get-bundle helm-google)
  (el-get-bundle ptrv/helm-smex)
  (global-set-key [remap execute-extended-command] #'helm-smex)
  (global-set-key (kbd "M-X") #'helm-smex-major-mode-commands)
  (el-get-bundle projectile-rails)
  ;; projectile-rails
  (use-package projectile-rails
    :if (executable-find "rails")
    :config
    (add-hook 'enh-ruby-mode-hook 'projectile-rails-on)
    (add-hook 'slim-mode-hook 'projectile-rails-on)
    (add-hook 'scss-mode-hook 'projectile-rails-on)
    (add-hook 'coffee-mode-hook 'projectile-rails-on)
    (add-hook 'web-mode-hook 'projectile-rails-on)))

(use-package eldoc
  :config
  (eldoc-mode)
  (el-get-bundle eldoc-extension)
  (use-package eldoc-extension)
  (setq eldoc-idle-delay 0)
  (setq eldoc-echo-area-use-multiline-p t))

(defun shorten-directory (dir max-length)
  "Show up to `max-length' characters of a directory name `dir'."
  (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
        (output ""))
    (when (and path (equal "" (car path)))
      (setq path (cdr path)))
    (while (and path (< (length output) (- max-length 4)))
      (setq output (concat (car path) "/" output))
      (setq path (cdr path)))
    (when path
      (setq output (concat ".../" output)))
    output))

(el-get-bundle markdown-mode)
(use-package markdown-mode)

(el-get-bundle flycheck/flycheck)
(use-package flycheck
  :config
  (add-hook 'after-init-hook 'global-flycheck-mode)

  (el-get-bundle flycheck-color-mode-line)
  (use-package flycheck-color-mode-line)
  (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)
  (setq-default flycheck-disable-checkers '(javascript-jshint))
  (setq flycheck-check-syntax-automatically '(save mode-enabled))

  ;; 要textlint
  (flycheck-define-checker textlint
    "A linter for prose."
    :command ("textlint" "--format" "unix"
              "--rule" "no-mix-dearu-desumasu"
              "--rule" "max-ten"
              "--rule" "spellcheck-tech-word"
              "--rule" "ja-no-abusage"
              "--rule" "no-doubled-joshi"
              "--rule" "no-double-negative-ja"
              "--rule" "ja-no-weak-phrase"
              "--rule" "ja-no-redundant-expression"
              "--rule" "textlint-rule-no-dropping-the-ra"
              "--rule" "no-doubled-conjunctive-particle-ga"
              "--rule" "ja-no-mixed-period"
              "--rule" "ja-unnatural-alphabet"
              "--rule" "@textlint-ja/textlint-rule-no-insert-dropping-sa"
              source-inplace)
    :error-patterns
    ((warning line-start (file-name) ":" line ":" column ": "
              (id (one-or-more (not (any " "))))
              (message (one-or-more not-newline)
                       (zero-or-more "\n" (any " ") (one-or-more not-newline)))
              line-end))
    :modes (text-mode markdown-mode))
  (add-to-list 'flycheck-checkers 'textlint)
  (add-hook 'markdown-mode-hook 'flycheck-mode))

;; (el-get-bundle flycheck-package
;;   :depends (flycheck)
;;   :config
;;   (flycheck-package-setup))

(el-get-bundle flycheck/flycheck-popup-tip :depends (flycheck))

(el-get-bundle company-mode)
(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (el-get-bundle company-statistics)
  (use-package company-statistics)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (setq company-selection-wrap-around t)
  (setq company-dabbrev-downcase nil)
  ;;(company-quickhelp-mode nil)
  ;;(custom-set-variables '(company-quickhelp-delay nil))
  (add-hook 'after-init-hook 'company-statistics-mode))

(el-get-bundle yasnippet)
(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/.emacs.d/yasnippet-snippets" "~/.emacs.d/snippets"))
  (el-get-bundle 'johnmastro/react-snippets.el)
  (use-package react-snippets)
  (yas-global-mode 1)
  (setq helm-yas-space-match-any-greedy t)
  (define-key yas-minor-mode-map (kbd "C-c y") 'helm-yas-complete)
  (define-key yas-minor-mode-map (kbd "C-c i") 'yas-insert-snippet)
  (define-key yas-minor-mode-map (kbd "C-c o") 'yas-visit-snippet-file))

(setq hippie-expand-try-functions-list
      '(yas/hippie-try-expand
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-list try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

;; HTML, CSS, etc...

(el-get-bundle web-mode)
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode)))

(el-get-bundle scss-mode)
(use-package scss-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
  (add-hook 'scss-mode-hook 'skewer-css-mode)
  (setq css-indent-offset 2))

(el-get-bundle slim-mode)
(use-package slim-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.slim$" . slim-mode)))

(el-get-bundle web-completion-data)

(el-get-bundle company-web)
(use-package company-web
  :config
  (add-hook 'web-mode-hook 'skewer-html-mode)
  ;; (el-get-bundle osv/ac-html-bootstrap)
  ;; (use-package ac-html-bootstrap)
  (add-to-list 'company-backends '(company-css))
  (use-package company-web-html
    :config
    (add-to-list 'company-backends '(company-web-html)))
  (use-package company-web-slim
    :config
    (add-hook 'slim-mode-hook
              (lambda ()
                (add-to-list 'company-backends '(comapny-web-slim company-css company-robe))))
    (add-to-list 'company-backends '(company-web-slim))))

;; ruby

(el-get-bundle enh-ruby-mode)
(use-package enh-ruby-mode
  :if (executable-find "ruby")
  :config
  (custom-set-variables '(ruby-program "~/.rbenv/shims/ruby"))
  (custom-set-variables '(ruby-insert-encoding-magic-comment nil))
  (custom-set-variables '(enh-ruby-program "~/.rbenv/shims/ruby"))
  (custom-set-variables '(enh-ruby-deep-indent-paren nil))

  (add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rake$" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.jbuilder$" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.watchr$" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist '("Gemfile$" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist '("Guardfile$" . enh-ruby-mode))
  (add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

  ;; inf-ruby
  (el-get-bundle inf-ruby)
  (use-package inf-ruby
    :config
    ;;(autoload inf-ruby-minor-mode "inf-ruby" "Run an iferior Ruby process" t)
    ;; (add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
    (setq inf-ruby-default-implementation "pry")
    ;;(add-to-list inf-ruby-implementations ("pry" . "pry"))
    (setq  inf-ruby-console-gem (directory-file-name "/Users/niitsumatakurou/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0"))
    (setq inf-ruby-eval-binding "Pry.toplevel_binding"))

  ;; Yard-mode
  (el-get-bundle yard-mode)
  (use-package yard-mode
    :config
    (add-hook 'enh-ruby-mode-hook 'yard-mode))

  ;; rbenv
  (el-get-bundle rbenv)
  (use-package rbenv)

  ;; bundler
  (el-get-bundle bundler)
  (use-package bundler)

  ;; Robeの起動
  (el-get-bundle dgutov/robe)
  (use-package robe
    :config
    (add-hook 'enh-ruby-mode-hook 'robe-mode)
    (add-hook 'slim-mode-hook 'robe-mode)
    (define-key robe-mode-map (kbd "C-c r d") 'robe-jump)
    (define-key robe-mode-map (kbd "C-c r w") 'robe-ask)
    (define-key robe-mode-map (kbd "C-c r q") 'robe-doc))

  (defun common-ruby-settings ()
    "Provide common ruby settings"
    (progn
      (global-rbenv-mode)
      (rbenv-use-global)
      ;; (robe-start)
      ;; (robe-eldoc)
      (setq rbenv-installation-dir "/usr/local/var/homebrew/linked/rbenv")
      (setq rbenv-modeline-function 'rbenv--modeline-plain)
      (add-to-list 'company-backends '(company-robe))));; company-files company-restclient))))

  (add-hook 'enh-ruby-mode-hook 'common-ruby-settings)
  (add-hook 'slim-mode-hook 'common-ruby-settings)

  (el-get-bundle rubocop)
  (use-package rubocop)

  ;; (add-hook 'enh-ruby-mode-hook 'erm-define-faces)

  ;; マジックコメントの削除
  (defun remove-enh-magic-comment ()
    (remove-hook 'before-save-hook 'enh-ruby-mode-set-encoding t))
  (add-hook 'enh-ruby-mode-hook 'remove-enh-magic-comment)
  (setq enh-ruby-use-encoding-map nil)

  (el-get-bundle rspec-mode)
  (use-package rspec-mode
    :config
    (rspec-install-snippets))

  (el-get-bundle myrurema
    :type http
    :url "https://gist.githubusercontent.com/raw/2875bd46c958ac4c74b2/2ef30e39b4b950131a03ccb57c4a092815bf0876/myrurema.el")
  (use-package myrurema))

;; javascript, typescript, etc...

(setq js-indent-level 2)

;; (el-get-bundle ac-js2)
;; (use-package ac-js2
;;   :config
;;   (setq ac-js2-evaluate-calls t)
;;   (add-to-list 'company-backends '(ac-js2-company company-jquery)))

(el-get-bundle js2-mode)
(use-package js2-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (add-hook 'js-mode-hook 'js2-minor-mode)
  (custom-set-variables
   '(flycheck-disable-checkers '(javascript-jshint javascript-jscs)))
  (flycheck-add-mode 'javascript-eslint 'js2-mode)
  (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-jsx-mode))
  (flycheck-add-mode 'javascript-eslint 'js2-jsx-mode)
  ;;(el-get-bundle tern-mode)
  (defun switch-tern ()
    (when (locate-library "tern")
      (setq default-tab-width 2)
      (setq tern-command '("tern" "--no-port-file"))
      (tern-mode t)
      (with-eval-after-load 'tern
        (require 'company-tern)
        (add-to-list 'company-backends '(company-tern ac-js2-company company-jquery)))))

  (add-hook 'js2-mode-hook 'switch-tern)
  (add-hook 'js2-jsx-mode-hook 'switch-tern)
  (setq js2-strict-trailing-comma-warning nil)
  (setq js2-strict-missing-semi-warning t)
  (setq js2-missing-semi-one-line-override t)
  (setq js2-strict-inconsistent-return-warning nil))

(el-get-bundle typescript-mode)
(el-get-bundle typescript-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (el-get-bundle tide)
  (use-package tide
    :config
    (defun setup-tide-mode ()
      (setq default-tab-width 2)
      (tide-setup))

    (add-hook 'tide-mode-hook (lambda () (tide-restart-server)))

    (defun switch-tide ()
      (when (string-equal "tsx" (file-name-extension buffer-file-name))
        (add-to-list 'company-backends '(company-web-html company-css))
        (setup-tide-mode)))

    (add-hook 'typescript-mode-hook #'setup-tide-mode)

    (add-hook 'web-mode-hook #'switch-tide)))

(el-get-bundle coffee-mode)
(use-package coffee-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.coffee\\'" . coffee-mode)))

(el-get-bundle json-mode)
(use-package json-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode)))

(el-get-bundle jade-mode)
(use-package jade-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.jade\\'" . jade-mode)))

(el-get-bundle jquery-doc)
(use-package jquery-doc)
(el-get-bundle skewer-mode)
(use-package skewer-mode)

;; Golang

(el-get-bundle go-mode)
(use-package go-mode
  :config
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)

  (use-package go-mode-autoloads)

  (add-hook 'go-mode-hook
            '(lambda ()
               (setq tab-width 2)
               ))

  (el-get-bundle golint :url "https://raw.githubusercontent.com/golang/lint/master/misc/emacs/golint.el")
  (use-package golint)

  (el-get-bundle go-eldoc)
  (use-package go-eldoc
    :config
    (add-hook 'go-mode-hook 'go-eldoc-setup))

  (el-get-bundle benma/go-dlv.el)
  (use-package go-dlv)
  (el-get-bundle company-go :url "https://raw.githubusercontent.com/nsf/gocode/master/emacs-company/company-go.el")
  (use-package company-go)
  ;;(add-to-list 'company-backends '(company-go company-file company-yasnippet))
  (add-hook 'go-mode-hook (lambda ()
                            (setq tab-width 2)
                            (set (make-local-variable 'company-backends) '(company-go))))

  (el-get-bundle helm-go-package)
  (use-package helm-go-package
    :config
    (substitute-key-definition 'go-import-add 'helm-go-package go-mode-map)))

(el-get-bundle elixir-editors/emacs-elixir)
(use-package elixir-mode
  :config
  (el-get-bundle alchemist)
  (use-package alchemist
    :config
    (setq alchemist-mix-command "/usr/local/bin/mix")
    (setq alchemist-iex-program-name "/usr/local/bin/iex")
    (setq alchemist-execute-command "/usr/local/bin/elixir")
    (setq alchemist-compile-command "/usr/local/bin/elixirc")
    (setq alchemist-hooks-text-on-save t)
    (setq alchemist-hooks-compine-on-save t)
    (add-hook 'elixir-mode-hook '(lambda ()
                                   (alchemist-mode t)
                                   (add-to-list 'flycheck-checkers 'elixir-dogma)
                                   ;; (set (make-variable-buffer-local 'ruby-end-expand-keywords-before-re) "\\(?:^\\|\\s-+\\)\\(?:do\\)" )
                                   ;; (set (make-variable-buffer-local 'ruby-end-check-statement-modifiers))
                                   (setq company-minimum-prefix-length 1)
                                   ;;(autoload 'ruby-end-mode "ruby-end" nil t)
                                   (ruby-end-mode +1)))
    (add-to-list 'auto-mode-alist '("\\.eex$" . web-mode))
    (el-get-bundle lbolla/emacs-flycheck-elixir)
    (el-get-bundle hisea/elixir-yasnippets)
    (use-package elixir-yasnippets)))

;; elisp
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)

;;common-lisp
(with-eval-after-load 'slime
  (slime-mode t)
  (defalias 'sl-restart 'slime-restart-inferior-lisp)
  (require 'elisp-slime-nav))

(with-eval-after-load 'slime
  (slime-setup '(slime-repl slime-fancy slime-banner slime-company))
  (setq slime-net-coding-system 'utf-8-unix)
  (add-hook 'slime-mode-hook 'slime-autodoc-mode))

;; c-lang
(require 'cc-mode)
;;(el-get-bundle cc-mode)
;;(use-package cc-mode
;;  :config
;;  (add-hook 'c-mode-common-hook
;;            (lambda ()
;;              (setq c-default-style "k&r")
;;              (setq indent-tabs-mode t)
;;              (setq c-basic-offset 2))))

;; haml
(el-get-bundle nex3/haml-mode)
(use-package haml-mode)

;; python
(el-get-bundle epc)
(el-get-bundle jedi-core)
(use-package python
  :config
  (defun python-shell-parse-command ()
    "python3 -i")
  (add-hook 'python-mode-hook 'jedi:setup)
  (el-get-bundle autopep8)
  ;; (el-get-bundle pyflakes)
  (el-get-bundle company-jedi :depends (company-mode))
  (el-get-bundle Wilfred/flycheck-pyflakes :depends (flycheck))
  (with-eval-after-load 'jedi
    (use-package pyflakes)
    (use-package flycheck-pyflakes)
    (use-package autopep8)
    (jedi:setup)
    (add-to-list 'company-backends 'company-jedi))
  (add-hook 'jedi-mode-hook (lambda () (setq jedi:complete-on-dot t))))

;; clojure
(el-get-bundle clojure-mode)
(el-get-bundle cider)
(el-get-bundle flycheck-clojure)
(el-get-bundle clojure-snippets)
(add-hook #'clojure-mode (lambda () (cider-jack-in)))
(with-eval-after-load 'clojure-mode
  '(flycheck-clojure-setup)
  (use-package clojure-snippets))

;; elmacro
(el-get-bundle elmacro)
(use-package elmacro
  :config
  (elmacro-mode +1))

;; anzu
(el-get-bundle anzu)
(use-package anzu
  :config
  (global-anzu-mode +1)
  (global-set-key [remap query-replace] 'anzu-query-replace)
  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
  (global-set-key (kbd "C-c C-r") 'anzu-query-replace-at-cursor))

;; smartparens
(el-get-bundle smartparens)
(use-package smartparens-config
  :config
  (cl-dolist (hook (list
                    'emacs-lisp-mode-hook
                    'c-mode-hook
                    'elixir-mode-hook
                    'javascript-mode-hook
                    'js2-mode-hook
                    'js2-jsx-mode-hook
                    'typescript-mode-hook
                    'coffee-mode-hook
                    'go-mode-hook
                    'haskell-mode-hook
                    'enh-ruby-mode-hook
                    'python-mode
                    'clojure-mode
                    'rust-mode))
    (add-hook hook #'smartparens-mode)))

;; fullscreen
(global-set-key (kbd "C-;") 'fullscreen-mode-fullscreen-toggle)

;; expand-region
(el-get-bundle magnars/expand-region.el)
(use-package expand-region
  :config
  (global-set-key (kbd "M-@") 'er/expand-region))

;; windmov
(use-package windmove
  :config
  (global-set-key (kbd "S-<up>") 'windmove-up)
  (global-set-key (kbd "S-<down>") 'windmove-down)
  (global-set-key (kbd "S-<right>") 'windmove-right)
  (global-set-key (kbd "S-<left>") 'windmove-left))

;; undo-tree
(el-get-bundle undo-tree)
(use-package undo-tree
  :config
  (global-undo-tree-mode)
  (global-set-key (kbd "C-_") 'undo-tree-undo)
  (global-set-key (kbd "C-S-_") 'undo-tree-redo))

(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))
(define-key key-translation-map (kbd "M-h") (kbd "<M-DEL>"))

;;; skk
;; (use-package skk nil t
;;   :config
;;   (global-set-key "\C-xj" 'skk-auto-fill-mode)
;;   (with-eval-after-load 'skk-auto-fill-mode
;;     (setq default-input-method "japanese-skk")
;;     (use-package skk-study)))

;;; linum
(el-get-bundle tom-tan/hlinum-mode)
(use-package hlinum
  :config
  (setq linum-delay t)
  (defadvice linum-schedule (around my-linum-schedule () activate)
    (run-with-idle-timer 0.2 nil #'linum-update-current))
  (hlinum-activate)
  (global-linum-mode 1))

;;; open init.el
(global-set-key (kbd "M-I") (lambda () (interactive)
                              (switch-to-buffer (find-file-noselect "~/.emacs.d/init.el"))))

;; popwin
(el-get-bundle popwin)
(use-package popwin
  :config
  (popwin-mode 1))

;; org-mode
(el-get-bundle org)
(use-package org
  :config
  (setq org-plantuml-jar-path "/usr/local/Cellar/plantuml/8041/plantuml.8041.jar")
  (defun org-mode-init ()
    (org-babel-do-load-languages
     'org-babel-load-languages
     (add-to-list 'org-babel-load-languages '(plantuml . t))))
  (add-hook 'org-mode-hook 'org-mode-init))

(el-get-bundle puml-mode)
(use-package puml-mode
  :if (executable-find "java")
  :config
  (add-to-list 'auto-mode-alist '("\\.puml$" . puml-mode)))

(el-get-bundle quickrun)
(use-package quickrun)

(el-get-bundle dockerfile-mode)
(use-package dockerfile-mode
  :config
  (el-get-bundle docker-tramp)
  (use-package docker-tramp
    :if (executable-find "docker")))

(use-package gitignore-mode)

(el-get-bundle yaml-mode)
(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(el-get-bundle google-translate)
(use-package google-translate
  :config
  (global-set-key (kbd "C-c t") 'google-translate-at-point))

;; emacs-lsp
(el-get-bundle emacs-lsp/lsp-mode)
(use-package lsp-mode
  :config
  (el-get-bundle emacs-lsp/lsp-rust)
  (use-package lsp-flycheck))

;; rust
(el-get-bundle rust-mode)
(use-package rust-mode
  :config
  (setq flycheck-checker 'lsp)
  (setq flycheck-disabled-checkers '(rust-cargo))
  (use-package lsp-rust))
(add-hook 'rust-mode-hook #'lsp-mode)

(el-get-bundle toml-mode)
(use-package toml-mode)

(el-get-bundle cargo)
(use-package cargo
  :config
  (add-hook 'rust-mode-hook 'cargo-minor-mode))

(el-get-bundle emacs-racer)
(use-package racer
  :config
  (setq racer-cmd "/Users/otakumesi/.cargo/bin/racer")
  (add-hook 'rust-mode-hook #'racer-mode))

(el-get-bundle racer-rust/emacs-racer)
(use-package company-racer
  :config
  (setq company-racer-executable "/Users/otakumesi/.cargo/bin/racer")
  (add-to-list 'company-backends 'company-racer))

(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)

(el-get-bundle fbergroth/emacs-rustfmt)
(use-package rustfmt)

(add-hook 'rust-mode-hook #'rustfmt-enable-on-save)

(el-get-bundle migemo)
(use-package migemo
  :if (executable-find "cmigemo")
  :config
  (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
  (setq migemo-command "cmigemo")
  (setq migemo-options '("-q" "--emacs"))
  (setq migemo-user-dictionary nil)
  (setq migemo-coding-system 'utf-8)
  (setq migemo-regex-dictionary nil)
  (load-library "migemo")
  (migemo-init))

(el-get-bundle haxney/smart-tab)
(use-package smart-tab
  :config
  (global-smart-tab-mode 1)
  (setq smart-tab-using-hippie-expand 1))


(el-get-bundle jacktasia/dumb-jump)
(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g b" . dumb-jump-back))
  :config
  ;; (setq dumb-jump-selector 'helm)
  (setq dumb-jump-prefer-searcher 'rg))

(el-get-bundle ejmr/php-mode)
(use-package php-mode)

(el-get-bundle Wilfred/bison-mode)
(use-package bison-mode)

(el-get-bundle racer-rust/emacs-racer)
(use-package hexo)
(defun hexo-my-blog ()
  (interactive)
  (hexo "~/Documents/blog"))

;; 要growl
;; (el-get-bundle fsm)
;; (use-package fsm
;;   :config
;;   (el-get-bundle jabber)
;;   (use-package jabber))

(provide 'init)
;;; init.el ends here
