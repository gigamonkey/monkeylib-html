;;; Copyright (c) 2005-2001, Peter Seibel. All rights reserved. See COPYING for details.

(in-package :cl-user)

(defpackage :monkeylib-html
  (:use :common-lisp
        :com.gigamonkeys.utilities
        :com.gigamonkeys.test
        :com.gigamonkeys.pathnames
        :monkeylib-text-output
        :monkeylib-text-languages)
  (:export
   :&attributes
   :define-html-macro
   :define-html-special-operator
   :define-xml-language
   :emit-xml
   :emit-html
   :emit-xhtml
   :xml
   :html
   :xhtml
   :with-html-output))
