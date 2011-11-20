;;; Copyright (c) 2005-2011, Peter Seibel.
;;; All rights reserved. See COPYING for details.

(defsystem monkeylib-html
  :name "com.gigamonkeys.foo"
  :author "Peter Seibel <peter@gigamonkeys.com>"
  :version "1.0"
  :licence "BSD"
  :description "HTML generation"
  :components
  ((:file "packages")
   (:file "string-escaping"  :depends-on ("packages"))
   (:file "html"             :depends-on ("packages""string-escaping" "xml"))
   (:file "html-tests"       :depends-on ("packages" "html"))
   (:file "xml"              :depends-on ("packages"))
   (:file "xml-macros"       :depends-on ("packages" "xml")))
  :depends-on (:com.gigamonkeys.macro-utilities
	       :com.gigamonkeys.test-framework
	       :com.gigamonkeys.pathnames
	       :com.gigamonkeys.utilities
               :monkeylib-text-output
               :monkeylib-text-languages))
