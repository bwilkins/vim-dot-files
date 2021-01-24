(use-package enh-ruby-mode
  :ensure t
  :straight enh-ruby-mode
  :config

  (use-package rspec-mode
    :ensure t
    :straight rspec-mode
    )

  (use-package robe
    :ensure t
    :straight robe
    )

  (use-package ruby-end
    :ensure t
    :straight ruby-end
    :defer 1)

  (use-package rbenv
    :ensure t
    :straight rbenv
    :config
    (global-rbenv-mode))
  (use-package inf-ruby
    :ensure t
    :straight inf-ruby
    :config

    (defun comint-goto-end-and-insert ()
      (interactive)
      (if (not (comint-after-pmark-p))
	  (progn (comint-goto-process-mark)
		 (evil-append-line nil))
	(evil-insert 1)))
    (evil-define-key 'normal comint-mode-map "i" 'comint-goto-end-and-insert)
    (evil-define-key 'normal inf-ruby-mode-map "i" 'comint-goto-end-and-insert)

    (evil-define-key 'insert comint-mode-map
      (kbd "<up>") 'comint-previous-input
      (kbd "<down>") 'comint-next-input)))

(add-hook 'enh-ruby-mode-hook 'robe-mode)
(eval-after-load 'company
  '(push 'company-robe company-backends))
(add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
(add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)
(add-hook 'dired-mode-hook 'rspec-dired-mode)

(setenv "CAPYBARA_INLINE_SCREENSHOT" "artifact")