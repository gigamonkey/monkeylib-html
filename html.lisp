;;; Copyright (c) 2005-2011, Peter Seibel.
;;; All rights reserved. See COPYING for details.

(in-package :monkeylib-html)

(defclass html (xml)
  ()
  (:default-initargs
   :output-file-type "html"
    :input-readtable (copy-readtable)))

(defmethod initialize-instance :after ((html html) &key &allow-other-keys)
  (push 'html-special-operator (special-operator-symbols html))
  (push 'html-macro (macro-symbols html)))

(define-xml-language xhtml
  (:block-elements
   :body :colgroup :div :dl :fieldset :form :head :html :map :noscript
   :object :ol :optgroup :pre :script :select :style :table :tbody
   :tfoot :thead :tr :ul)
  (:paragraph-elements
   :area :base :blockquote :br :button :caption :col :dd :div :dt :h1
   :h2 :h3 :h4 :h5 :h6 :hr :input :li :link :meta :option :p :param
   :td :textarea :th :title)
  (:preserve-whitespace-elements
   :pre :script :style :textarea))

(defun emit-xhtml (sexp) (emit-for-language 'xhtml sexp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Public API

(defmacro with-html-output ((stream &key (pretty t)) &body body)
  `(with-text-output (,stream :pretty ,pretty)
     (html ,@body)))

(defun emit-html (sexp) (emit-for-language 'html sexp))

(define-language-macro html)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Redefine these since HTML is not exactly XML

(defmethod emit-open-tag ((language html) processor tag body-p attributes environment)
  (declare (ignore body-p))
  (when (or (paragraph-element-p tag environment) (block-element-p tag environment))
    (freshline processor))
  (raw-string processor (format nil "<~a" (funcall (name-converter language) tag)))
  (emit-attributes language processor attributes environment)
  (raw-string processor ">"))

(defmethod emit-close-tag ((language html) processor tag body-p environment)
  (when (or body-p (not (empty-element-p tag environment)))
    (raw-string processor (format nil "</~a>" (funcall (name-converter language) tag))))
  (when (or (paragraph-element-p tag environment) (block-element-p tag environment))
    (freshline processor)))

(defmethod top-level-environment ((language html))
  (let ((bindings
         '((empty-elements
            :area :base :br :col :embed :hr :img :input :keygen :link :meta
            :param :source :track :wbr)
           (block-elements
            :body :colgroup :div :dl :fieldset :form :head :html :map :noscript
            :object :ol :optgroup :pre :script :select :style :table :tbody
            :tfoot :thead :tr :ul)
           (paragraph-elements
            :area :base :blockquote :br :button :caption :col :dd :div :dt :h1
            :h2 :h3 :h4 :h5 :h6 :hr :input :li :link :meta :option :p :param
            :td :textarea :th :title)
           (preserve-whitespace-elements
            :pre :script :style :textarea)
           (inline-elements
            :a :abbr :acronym :address :b :bdo :big :cite :code :del :dfn :em
            :i :img :ins :kbd :label :legend :q :samp :small :span :strong :sub
            :sup :tt :var)
           (non-empty-elements
            :script :style :textarea))))
    (loop for (k . v) in (cons nil bindings)
       for env = (call-next-method) then (new-env k v env)
       finally (return env))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; One element of environment specific to HTML.

(defun empty-element-p (tag env)
  (find tag (environment-value 'empty-elements env)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Macros

(defmacro define-html-macro (name (&rest parameters) &body body)
  (multiple-value-bind (attributes parameters)
      (parse-xml-macro-lambda-list parameters)
    (if attributes
      (generate-xml-macro-with-attributes name 'html-macro attributes parameters body)
      `(define-macro ,name html-macro (,@parameters) ,@body))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Special Forms -- we inherit special forms from XML but any
;;; HTML-specific could be defined with this.

(defmacro define-html-special-operator (name (language processor &rest other-parameters) &body body)
  `(define-special-operator ,name html-special-operator (,language ,processor ,@other-parameters) ,@body))
