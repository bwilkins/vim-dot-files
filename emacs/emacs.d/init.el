(require 'org-install)
(require 'ob-tangle)
(org-babel-load-file (expand-file-name "emacs.org" user-emacs-directory))

(server-start)

; This should be set in emacs.org
(load custom-file)
