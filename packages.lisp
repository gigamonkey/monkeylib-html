;;; Copyright (c) 2005-2001, Peter Seibel. All rights reserved. See COPYING for details.

(in-package :cl-user)

(defpackage :monkeylib-html
  (:use :common-lisp
	:com.gigamonkeys.macro-utilities
	:com.gigamonkeys.utilities
        :com.gigamonkeys.test
        :com.gigamonkeys.pathnames
	:text-output
	:text-languages)
  (:export
   :&attributes
   :cons-form-p
   :define-html-macro
   :define-html-special-operator
   :emit-html
   :emit-xhtml
   :html
   :xhtml
   :in-html-style))



