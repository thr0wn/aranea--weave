<p>
  <a href="https://www.gnu.org/software/emacs/download.html">
    <img src="https://www.gnu.org/software/emacs/images/emacs.png" width="24"></img>
    emacs and elisp
  </a>
</p>

# aranea--weave: an elisp crawler
Super simple crawler using elisp. It may help you in small tasks or help to study elisp as it did to me.

## Install
In your Emacs:
```
M-x package-vc-install RET https://github/thr0wn/aranea--weave RET
```

## Usage
Here are some snippets using the package.
### Download a single formatted html from a url
Download full grindosaur page of Digimon World 1 as html. Note that `url-copy-file` could do the same job.
```elisp
;; load 'arane--weave after installation
(require 'aranea--weave)

;; crawl grindosaur
(aranea--weave
 "https://www.grindosaur.com/en/games/digimon-world/digimon"
 (lambda (status buffer &rest args)
   (with-current-buffer buffer
     ;; copy request body to aranea--output
     (let ((aranea--output (get-buffer-create "aranea.out"))) 
       (copy-to-buffer aranea--output (re-search-forward "\n\n" nil t) (point-max))
       ;; format html in aranea--output and save to a file
       (with-current-buffer aranea--output
         (html-mode)
         (write-file "digimon-world-1-all-digimon.html")
         (find-file "digimon-world-1-all-digimon.html")
         )
       )
     )
   )
 )
```

### Download some images from grindosaur
Download digimon icons from grindosaur of Digimon World 1 and print the results in a `org-mode` buffer. 
```elisp
;; load 'arane--weave after installation
(require 'aranea--weave)

;; crawl grindosaur images
(aranea--weave
 "https://www.grindosaur.com/en/games/digimon-world/digimon"
 (lambda (status buffer url &rest args)
   (with-current-buffer buffer
     ;; copy request body to aranea--output
     (let ((aranea--output (get-buffer-create "aranea.out"))
           (output-dir "https://www.grindosaur.com/img/games/digimon-world/icons/.+")
           (pattern "https:\/\/www\.grindosaur\.com\/img\/games\/digimon-world\/icons\/[^\.]*\.\\(png\\|jpg\\|jpeg\\|svg\\)")
           (output-dir (expand-file-name "./digimon-world/images/"))
           (paths ()))
       ;; make dir if it does not exist
       (unless (file-exists-p output-dir)
         (make-directory output-dir t)
         )
       ;; search the image regex pattern
       (princ (format "* Searching in url: %s\n" url) aranea--output)
       (while (search-forward-regexp pattern nil t)
         (setq-local path (buffer-substring (match-beginning 0) (match-end 0)))
         (setq-local file-path (string-replace "/" "-" path))
         (push path paths)
         (princ (format "** Found: %s\n    [[%s]]\n\n" path (concat output-dir file-path)) aranea--output)
         (url-copy-file path (concat output-dir file-path) t)
         (sit-for 0.05)
         )
       ;; log no results
       (if (length= paths 0)
           (princ "Image not found" aranea--output)
         )
       ;; switch to the output
       (switch-to-buffer aranea--output)
       (with-current-buffer aranea--output
         (org-mode)
         (org-toggle-inline-images)
         )
       )
     )
   )
 )
```
Expected result:
<img width="1053" height="621" alt="image" src="https://github.com/user-attachments/assets/dbd8cc0c-c97f-466f-a26e-3bf9f7f0734f" />
