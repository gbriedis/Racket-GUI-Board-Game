#lang racket/gui

;; I've created a dice which only gives from 1-6, if you want the output to be shown in the Console - remove the commented code.


;; ISSUES - When the button is pressed - it doesn't roll the dice

(define (dice-roll x) (random 1 7))
;;(build-vector 1 dice-roll)

(define *window-main* (new frame%
                           [label "Dice"]
                           [width 350]
                           [height 350]))

                           

(define *button-dice* (new button%
                         [label "Roll the Dice"]
                         [parent *window-main*]
                         [callback (lambda (button event)
                                     (build-vector 1 dice-roll))]))

(send *window-main* show #t)
                         