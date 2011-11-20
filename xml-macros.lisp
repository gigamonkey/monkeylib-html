;;; Copyright (c) 2005-2011, Peter Seibel.
;;; All rights reserved. See COPYING for details.

(in-package :monkeylib-html)

(define-xml-macro :? (name &rest attrs)
  `(:progn
    (:noescape (:format "<?~(~a~) ~@{~(~a~)=\"~a\"~^ ~}?>" ,name ,@attrs))
    (:newline)))

(define-html-macro :? (name &rest attrs)
  `(:progn
    (:noescape (:format "<?~a ~@{~(~a~)=\"~a\"~^ ~}?>" ,name ,@attrs))
    (:newline)))

(define-xml-macro :doctype (name type id url)
  `(:progn
    (:noescape (:format "<!DOCTYPE ~a ~a \"~a\" \"~a\">" ,name ,type ,id ,url))
    (:newline)))

(define-xml-macro :character (name)
  `(:noescape (:format ,(if (numberp name) "&#~d;" "&~(~a~);") ,name)))


