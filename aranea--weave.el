;;; aranea.el --- Web crawling -*- lexical-binding: t -*-

;; Author: Natan Camargos <natanscamargos@gmail.com>
;; Maintainer: Natan Camargos <natanscamargos@gmail.com>
;; URL: https://github.com/thr0wn/aranea-weave
;; Version: 0.1.0
;; Package-Requires: ((url "22.1"))
;; Keywords: web crawler

;; This file is part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Aranea is an trial on web crawling using elisp.
;; It can be used to do small crawling tasks.

;;; Code:

(cl-defun aranea--weave (&key url on-result on-next-url index)
  "Crawl an :url searching a file :pattern. Download if in: output-dir if it find something."
  (let* (
         (aranea--buffer (url-retrieve-synchronously url))
         (index (+ (or index 0) 1))
         (next-url (if (functionp on-next-url) (funcall on-next-url aranea--output index)))
         )
    (with-current-buffer aranea--buffer
      (goto-char (point-min))
      (funcall on-result aranea--buffer url)
      )
    (when next-url
      (aranea--weave
       :url next-url
       :on-result on-result
       :on-next-url on-next-url
       :index index
       )
      )
    )
  )

(provide 'aranea--weave)
