#lang racket/gui

(define chess-piece-snip-class
  (make-object
   (class snip-class%
     (super-new)
     (send this set-classname "chess-piece-snip"))))

(send (get-the-snip-class-list) add chess-piece-snip-class)

(define chess-piece%
  (class snip%
    (init-field glyph font size)
    (super-new)
    (send this set-snipclass chess-piece-snip-class)

    (define/override (get-extent dc x y width height descent space lspace rspace)
      (when width (set-box! width size))
      (when height (set-box! height size))
      (when descent (set-box! descent 0.0))
      (when space (set-box! space 0.0))
      (when lspace (set-box! lspace 0.0))
      (when rspace (set-box! rspace 0.0)))

    (define/override (draw dc x y . other)
      (send dc set-font font)
      (send dc set-text-foreground "black")
      (define-values (glyph-width glyph-height baseline extra-space)
        (send dc get-text-extent glyph font #t))
      (let ((ox (/ (- size glyph-width) 2))
            (oy (/ (- size glyph-height 2))))
        (send dc draw-text glyph (+ x ox) (+ y oy))))
    ))

(define chess-piece-data
  (hash
   "N" #\u2658
   "n" #\u265E))

(define (make-chess-piece id)
  (define glyph (hash-ref chess-piece-data id))
  (define font (send the-font-list find-or-create-font 30 'default 'normal 'normal))
  (new chess-piece% [glyph (string glyph)] [font font] [size 45]))

(define chess-board%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-chess-board dc)))

    ))

(define (draw-chess-board dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 23))
  (define cell-height (/ dc-height 23))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
 
  (for* ([row (in-range 23)] [col (in-range 23)]
         #:when (or (and (odd? row) (even? col))
                    (and (even? row) (odd? col))))
    (define-values [x y] (values (* col cell-width) (* row cell-height)))
    (send dc draw-rectangle x y cell-width cell-height))
    (send dc set-brush (send the-brush-list find-or-create-brush "white" 'solid))


; 221B Baker Street

  (send dc draw-rectangle (* 19 (/ dc-width 23)) (* 19 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
  (send dc draw-text "221B Baker Street" (* 20 (/ dc-width 23)) (* 20.5 (/ dc-height 23)) #f 0 0)
  (send dc set-pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (send dc draw-rectangle (* 20 (/ dc-width 23)) (* 19 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))

; Chemist

 (send dc draw-rectangle (* 15 (/ dc-width 23)) (* 19 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Chemist" (* 16 (/ dc-width 23)) (* 20.5 (/ dc-height 23)) #f 0 0)
  (send dc set-pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (send dc draw-rectangle (* 16 (/ dc-width 23)) (* 19 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))

; Newsagent

 (send dc draw-rectangle (* 11 (/ dc-width 23)) (* 19 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Newsagent" (* 12 (/ dc-width 23)) (* 20.5 (/ dc-height 23)) #f 0 0)
  (send dc draw-rectangle (* 12 (/ dc-width 23)) (* 19 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))

; Locksmith

 (send dc draw-rectangle (* 0 (/ dc-width 23)) (* 19 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Locksmith" (* 1 (/ dc-width 23)) (* 20.5 (/ dc-height 23)) #f 0 0)
  (send dc draw-rectangle (* 3 (/ dc-width 23)) (* 20 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))

; Pawnbroker

 (send dc draw-rectangle (* 0 (/ dc-width 23)) (* 15 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Pawnbroker" (* 1 (/ dc-width 23)) (* 16.5 (/ dc-height 23)) #f 0 0)
  (send dc draw-rectangle (* 3 (/ dc-width 23)) (* 16 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))

; Docks

 (send dc draw-rectangle (* 0 (/ dc-width 23)) (* 0 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Docks" (* 1.5 (/ dc-width 23)) (* 1.5 (/ dc-height 23)) #f 0 0)
 (send dc draw-rectangle (* 3 (/ dc-width 23)) (* 1 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))
 
; Boar's Head

 (send dc draw-rectangle (* 0 (/ dc-width 23)) (* 4 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Boar's Head" (* 1 (/ dc-width 23)) (* 5.5 (/ dc-height 23)) #f 0 0)
 (send dc draw-rectangle (* 1 (/ dc-width 23)) (* 7 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))
 

; Park

 (send dc draw-rectangle (* 19 (/ dc-width 23)) (* 8 (/ dc-height 23)) (/ dc-width 2.875) (/ dc-height 2.875))
 (send dc draw-text "Park" (* 20.5 (/ dc-width 23)) (* 11 (/ dc-height 23)) #f 0 0)
 (send dc draw-rectangle (* 19 (/ dc-width 23)) (* 12 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))

; Scotland Yard

 (send dc draw-rectangle (* 19 (/ dc-width 23)) (* 0 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Scotland Yard" (* 20 (/ dc-width 23)) (* 1.5 (/ dc-height 23)) #f 0 0)
 (send dc draw-rectangle (* 21 (/ dc-width 23)) (* 3 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))
 
; Bank

 (send dc draw-rectangle (* 15 (/ dc-width 23)) (* 0 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Bank" (* 16.5 (/ dc-width 23)) (* 1.5 (/ dc-height 23)) #f 0 0)
 (send dc draw-rectangle (* 17 (/ dc-width 23)) (* 3 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))
 
; Museum

 (send dc draw-rectangle (* 11 (/ dc-width 23)) (* 0 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Museum" (* 12 (/ dc-width 23)) (* 1.5 (/ dc-height 23)) #f 0 0)
 (send dc draw-rectangle (* 11 (/ dc-width 23)) (* 2 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))

; Theatre

 (send dc draw-rectangle (* 6 (/ dc-width 23)) (* 6 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Theatre" (* 7.5 (/ dc-width 23)) (* 7.5 (/ dc-height 23)) #f 0 0)
 (send dc draw-rectangle (* 7 (/ dc-width 23)) (* 6 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))

; Carriage - Depot

 (send dc draw-rectangle (* 11 (/ dc-width 23)) (* 6 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Carriage - Depot" (* 12 (/ dc-width 23)) (* 7 (/ dc-height 23)) #f 0 0)
 (send dc draw-rectangle (* 14 (/ dc-width 23)) (* 8 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))

; Tobacconist

 (send dc draw-rectangle (* 6 (/ dc-width 23)) (* 11 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Tobacconist" (* 7 (/ dc-width 23)) (* 12.5 (/ dc-height 23)) #f 0 0)
  (send dc draw-rectangle (* 8 (/ dc-width 23)) (* 11 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))

; Hotel

 (send dc draw-rectangle (* 11 (/ dc-width 23)) (* 11 (/ dc-height 23)) (/ dc-width 5.75) (/ dc-height 5.75))
 (send dc draw-text "Hotel" (* 12.5 (/ dc-width 23)) (* 12.5 (/ dc-height 23)) #f 0 0)
 (send dc draw-rectangle (* 11 (/ dc-width 23)) (* 13 (/ dc-height 23)) (/ dc-width 23) (/ dc-height 23))
 
   

  (send dc set-font (send the-font-list find-or-create-font 8 'default 'normal 'normal))
  (for ([(rank index) (in-indexed '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23"))])
    (define-values [_0 h _1 _2] (send dc get-text-extent rank font #t))
    (define y (+ (* index cell-height) (- (/ cell-height 2) (/ h 2))))
    (send dc draw-text rank margin y))
 
  (for ([(file index) (in-indexed '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23"))])
    (define-values [w h _1 _2] (send dc get-text-extent file font #t))
    (define x (+ (* index cell-width) (- (/ cell-width 2) (/ w 2))))
    (send dc draw-text file x (- dc-height h margin))))
;(send dc set-pen (send the-pen-list find-or-create-pen "white" 1 'transparent))


;; A test program for our chess-piece% objects:

;; The pasteboard% that will hold and manage the chess pieces
(define board (new chess-board%))
;; Toplevel window for our application
(define toplevel (new frame% [label "The Sherlock Game"] [width (* 50 23)] [height (* 50 23)]))
(define bottomlevel (new frame% [label "The Sherlock Game"] [width (* 50 23)] [height (* 50 23)]))
;; The canvas which will display the pasteboard contents
(define canvas (new editor-canvas%
                    [parent toplevel]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor board]))
(send toplevel show #t)
(send bottomlevel show #f)
(new button% [parent toplevel]
             [vert-margin 10]
             [label "Dice Roll"]
             ; Callback procedure for a button click:
             [callback (lambda (button event)
                         (send toplevel set-label "asdas"))])






;; Insert one of each of the chess pieces onto the board, so we can see them
;; and drag them around.
(for ([id (in-hash-keys chess-piece-data)])
  (define piece (make-chess-piece id))
  (send board insert piece 1800 850))
