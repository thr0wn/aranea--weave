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
  "Retrieve the specified url and call callback as below:
  (funcall callback
    status
    buffer
    url
    (lambda (next-url)
      (aranea--weave next-url callback)
    )
  )

Parameters:
  status: same as url-retrieve callback statuses
  buffer: buffer where response resides
  url: retrieved url
  next: function to call to do another aranea--weave
  
Declare your callback like below to access response contents:
  (aranea--weave
    \"some url\"
    (lambda (status buffer &rest args)
      (...do something...)

"
  (url-retrieve url (aranea--weave-on-url-retrieve url callback))
  )

(defun aranea--weave-on-url-retrieve (url callback)
  (lambda (&optional status)
    (let ((buffer (current-buffer)))
      (with-current-buffer buffer
        (goto-char (point-min))
        (funcall callback
                 status
                 buffer
                 url
                 (lambda (next-url)
                         (aranea--weave next-url callback)
                         )
                 )
        )
      )
    )
  )

(provide 'aranea--weave)
