;;; mike-search.el --- Replicate the 'F3' search functionality from Visual Studio, for any F_

;; Copyright (C) 2018 Mike Panitz

;; Author: Mike Panitz
;; Version: 1.0
;; Keywords: search

;;; Commentary:

;; This package provides three functions which will, together,
;; replicate the F3 search functionality from Visual Studio:
;; 
;; (global-set-key [C-f3] 'search-thing-at-point)
;; (global-set-key [f3] 'repeat-search-thing-at-point-forward)
;; (global-set-key [S-f3] 'repeat-search-thing-at-point-backward)

(defcustom HW-search-vars-file "~/.emacs.d/DataFiles/HomeworkSearchVars.el"
  "File to save the F2, F3, etc search patterns into"
  :group 'MikeSearch)

;; from https://emacs.stackexchange.com/questions/42332/near-identical-commands-on-multiple-keys
(defvar search-thing-memory nil
  "History of things searched with `search-thing-at-point'.")

(defun set-search-item (key thing)
  (let ( (memory (assq key search-thing-memory)))
    (if memory
	(setcdr memory thing)
      (setq search-thing-memory (cons (cons key thing)
				      search-thing-memory))
      )
    ) )

;;;###autoload
(defun search-thing-at-point (key)
  "Search the thing at point.
Store the thing in MEMORY for a future search with
`repeat-search-thing-at-point-forward' and
`repeat-search-thing-at-point-backward'."
  (interactive (list (event-basic-type last-command-event)))
  (let ((thing  (if (use-region-p)  (buffer-substring-no-properties (region-beginning) (region-end))   (thing-at-point 'symbol) )))
    (set-search-item key thing)
    (unhighlight-regexp t)
    (highlight-regexp thing)
    (deactivate-mark)
    (search-forward-regexp thing)
    (backward-char)
    )
  )

;;;###autoload
(defun repeat-search-thing-at-point-forward (key)
  "Repeat the last thing searched with `search-thing-at-point'
with a matching key binding."
  (interactive (list (event-basic-type last-command-event)))
  (let ( (thing (cdr (assq key search-thing-memory))) )
    (if thing
	(progn
	  (search-forward-regexp thing)
	  (unhighlight-regexp t)
	  (highlight-regexp thing)
	  (backward-char)
	  )
      (message (format "Nothing to search for (press \"control-%s\" to select something to search)" key))
      )
    ))

;;;###autoload
(defun repeat-search-thing-at-point-backward (key)
  "Repeat the last thing searched with `search-thing-at-point'
with a matching key binding."
  (interactive (list (event-basic-type last-command-event)))
  (let ( (thing (cdr (assq key search-thing-memory)) ) )
    (search-backward-regexp thing)
    (unhighlight-regexp t)
    (highlight-regexp thing)
    (forward-char)
    ))


					; from https://stackoverflow.com/questions/2321904/elisp-how-to-save-data-in-a-file
(defun dump-vars-to-file (varlist filename)
  "simplistic dumping of variables in VARLIST to a file FILENAME"
  (save-excursion
    (let ((buf (find-file-noselect filename)))
      (set-buffer buf)
      (erase-buffer)
      (dump varlist buf)
      (save-buffer)
      (kill-buffer))))

(defun dump (varlist buffer)
  "insert into buffer the setq statement to recreate the variables in VARLIST"
  (cl-loop for var in varlist do
           (print (list 'setq var (list 'quote (symbol-value var)))
		  buffer)))


(add-to-list 'recentf-exclude (expand-file-name HW-search-vars-file))

(defun dump-vars-to-file-on-exit () 
  (dump-vars-to-file `(search-thing-memory) HW-search-vars-file))

(add-hook 'kill-emacs-hook `dump-vars-to-file-on-exit)

(if (file-exists-p HW-search-vars-file)
    (load-file HW-search-vars-file)
  )

(provide 'mike-search)
