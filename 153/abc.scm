#! /usr/bin/env guile
  abc, amb
  from SICP amb, require
  2018 (c) Gunter Liszewski
!#

(define *f* #f)

(define-syntax abc
  (syntax-rules ()
    ((abc) (*f*))
    ((abc ?a) ?a)
    ((abc ?a ?b)
      (let ((c *f*))
        ((call/cc 
           (lambda (d)
             (set! *f*
               (lambda ()
                 (set! *f* c)
                 (d (lambda () ?b))))
             (lambda () ?a))))))
    ((abc ?a ?rest ...)
      (abc ?a (abc ?rest ...)))))


(define (require a)
  (if (not a) (abc)))

(define *un* '())
(define (parse input)
  (set! *un* input)
    (let ((a (parse-sentence)))
      (require (null? *un*))
      a))

(define (parse-word a)
  (require (not (null? *un*)))
  (require (memq (car *un*) (cdr a)))
  (let ((b (car *un*)))
    (set! *un* (cdr *un*))
    (list (car a) (b))))

(define (parse-noun-phrase)
  (list 'noun-phrase (parse-word articles) (parse-word nouns)))

(define (parse-sentence)
  (list 'sentence (parse-noun-phrase) (parse-word verbs)))

;;; words

(define nouns
  '(noun dog cat man hut chair))
(define verbs
  '(verb sits lies wals is hides))
(define articles
  '(article the a))
