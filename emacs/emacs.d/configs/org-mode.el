(use-package org
  :straight org-plus-contrib
  )

(use-package org-journal
  :ensure t
  :straight org-journal
  :custom
  (org-journal-dir "~/Dropbox (Personal)/org/journal/")
  (org-journal-date-format "%A, %d %B %Y")
  :config
  (evil-leader/set-key "jj" 'org-journal-new-entry)
  )

(use-package org-roam
  :ensure t
  :hook (after-init . org-roam-mode)
  :straight (:host github :repo "jethrokuan/org-roam" :branch "develop")
  :custom
  (org-roam-directory "~/Dropbox (Personal)/org/roam/")

  :bind (:map org-roam-mode-map
	      (("C-c n l" . org-roam)
	       ("C-c n f" . org-roam-find-file)
	       ("C-c n g" . org-roam-show-graph))
	      :map org-mode-map
	      (("C-c n i" . org-roam-insert)))
  :config

  (evil-leader/set-key "ar" 'org-roam)
  (evil-leader/set-key "af" 'org-roam-find-file)
  (evil-leader/set-key "aa" 'org-roam-insert)
  )
