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

(defun aranea--weave (url callback)
  "Retrieve url and callback with (apply callback status)"
  (url-retrieve url (aranea--weave-on-url-retrieve url callback))
  )

(defun aranea--weave-on-url-retrieve (url callback)
  (lambda (&optional status)
    (let ((aranea--buffer (current-buffer)))
      (with-current-buffer aranea--buffer
        (goto-char (point-min))
        (funcall callback
                 :buffer aranea--buffer
                 :status status
                 :url url
                 :next (lambda (next-url)
                         (aranea--weave next-url callback)
                         )
                 )
        )
      )
    )
  )

(provide 'aranea--weave)
