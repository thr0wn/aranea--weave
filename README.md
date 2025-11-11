[![](https://img.shields.io/badge/elisp-black?logo=elisp)](https://www.gnu.org/software/emacs/manual/html_node/eintr/)
[![](https://img.shields.io/badge/emacs-black?logo=emacs)](https://www.gnu.org/savannah-checkouts/gnu/emacs/emacs.html)


# aranea--weave: an elisp crawler
Super simple crawler using elisp. It may help you in small tasks or helpto study elisp as it did to me.

## Install
In Emacs:
```
RET package-install RET https://github/thr0wn/aranea--weave
```

## Usage
### Download a single formatted html from a url
Download grindosaur of Digimon World 1 as html.
```elisp
;; crawl grindosaur
(aranea--weave
 :url "https://www.grindosaur.com/en/games/digimon-world/digimon"
 :on-result
 (lambda (buffer-response url)
   (with-current-buffer buffer-response
     ;; copy request body to aranea--output
     (let ((aranea--output (get-buffer-create "aranea.out")))
       (copy-to-buffer aranea--output (re-search-forward "\n\n" nil t) (point-max))

       ;; format html in aranea--output and save to a file
       (with-current-buffer aranea--output
         (html-mode)
         (sgml-pretty-print (point-min) (point-max))
         (write-file "digimon-world-1-all-digimon.html")
         )
       )
     )
   )
 )
```
