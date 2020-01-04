#lang racket/gui

(require racket/gui)


(define board (new pasteboard%))

(define toplevel (new frame%
                      [label "Sherlock Holmes 221B Baker Board Game"]
                      [min-width (* 50 23)]
                      [min-height (* 50 23)]
                      [stretchable-width #f]
                      [stretchable-height #f]))

(define canvas (new editor-canvas%
                    [parent toplevel]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor board]))

(send toplevel show #t)
