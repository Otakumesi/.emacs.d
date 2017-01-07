;;; elscreen-setting.el --- elscreen's settings.
;;; COMMENTARY

;;; Code:
;; elscreenの読み込み
(el-get-bundle elscreen
  :type git
  :url "https://github.com/shosti/elscreen.git")
(require 'elscreen)
(elscreen-start)
(with-eval-after-load 'elscreen
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
          ("*WL:Message*" . "Wanderlust"))))

(global-set-key (kbd "C-<right>") 'elscreen-next)
(global-set-key (kbd "C-<left>") 'elscreen-previous)
(global-set-key (kbd "C-c <up>") 'elscreen-clone)
(global-set-key (kbd "C-c <down>") 'elscreen-kill)
(global-set-key (kbd "C-c <C-up>") 'elscreen-clone)
(global-set-key (kbd "C-c <C-down>") 'elscreen-kill)

;; (require 'desktop+)
;; (add-to-list 'desktop+-globals-to-save 'file-name-histroy)
;; (desktop+-create-auto)
;; (desktop+-load-auto)

(provide 'elscreen-setting)
;;; elscreen-setting.el ends here
