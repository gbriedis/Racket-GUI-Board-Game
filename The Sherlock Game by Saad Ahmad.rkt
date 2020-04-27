#lang racket/gui
;I made two boards, firs board for 1 v 1 game and the other for group game. Everything is same except for the colour and amount of playing pieces on the board
;Board(Group Game)
(define piece-snip-class
  (make-object
   (class snip-class%
     (super-new)
     (send this set-classname "piece-snip"))))

(send (get-the-snip-class-list) add piece-snip-class)

;Class I used to set the size, colour and blackoutlining for the playing piece
(define piece%
  (class snip%
    (init-field glyph font size)
    (super-new)
    (send this set-snipclass piece-snip-class)

    (define/override (get-extent dc x y width height descent space lspace rspace)
      (when width (set-box! width size))
      (when height (set-box! height size))
      (when descent (set-box! descent 0.0))
      (when space (set-box! space 0.0))
      (when lspace (set-box! lspace 0.0))
      (when rspace (set-box! rspace 0.0)))

    (define/override (draw dc x y . other)
      (send dc set-font font)
      (send dc set-text-foreground "red")
      (define-values (glyph-width glyph-height baseline extra-space)
        (send dc get-text-extent glyph font #t))
      (let ((ox (/ (- size glyph-width) 2))
            (oy (/ (- size glyph-height 2))))
        (send dc draw-text glyph (+ x ox) (+ y oy))))
    ))

;Unicode i used for the playing piece
(define piece-data
  (hash
   "N" #\u2658
   ))


(define (make-piece id)
  (define glyph (hash-ref piece-data id))
  (define font (send the-font-list find-or-create-font 25 'default 'normal 'normal))
  (new piece% [glyph (string glyph)] [font font] [size 40]))

;Board(1 v 1)
(define sherlock-piece-snip-class
  (make-object
   (class snip-class%
     (super-new)
     (send this set-classname "sherlock-piece-snip"))))

(send (get-the-snip-class-list) add sherlock-piece-snip-class)

(define sherlock-piece%
  (class snip%
    (init-field glyph font size)
    (super-new)
    (send this set-snipclass sherlock-piece-snip-class)

    (define/override (get-extent dc x y width height descent space lspace rspace)
      (when width (set-box! width size))
      (when height (set-box! height size))
      (when descent (set-box! descent 0.0))
      (when space (set-box! space 0.0))
      (when lspace (set-box! lspace 0.0))
      (when rspace (set-box! rspace 0.0)))

    (define/override (draw dc x y . other)
      (send dc set-font font)
      (send dc set-text-foreground "blue")
      (define-values (glyph-width glyph-height baseline extra-space)
        (send dc get-text-extent glyph font #t))
      (let ((ox (/ (- size glyph-width) 2))
            (oy (/ (- size glyph-height 2))))
        (send dc draw-text glyph (+ x ox) (+ y oy))))
    ))

(define sherlock-piece-data
  (hash
   "N" #\u2658
   "n" #\u265E
   ))


(define (make-sherlock-piece id)
  (define glyph (hash-ref sherlock-piece-data id))
  (define font (send the-font-list find-or-create-font 25 'default 'normal 'normal))
  (new sherlock-piece% [glyph (string glyph)] [font font] [size 40]))

(define sherlock-board%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-sherlock-board dc)))

    ))

;I used the DC(drawing context) class to be able to draw he recangles and text on the board
(define (draw-sherlock-board dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 3 'solid))
  (define font (send the-font-list find-or-create-font 18 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
  (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
;I used this code to make a 20 by 20 board with silver rectangles 
  (for* ([row (in-range 20)] [col (in-range 20)]
         #:when (or (and (odd? row) (even? col))
                    (and (even? row) (odd? col))))
    (define-values [x y] (values (* col cell-width) (* row cell-height)))
    (send dc draw-rectangle x y cell-width cell-height))
    (send dc set-brush (send the-brush-list find-or-create-brush "white" 'solid))
;I wrote the code below to make a seperate rectangle for each location, write the name of the location, and make anoher small rectange to mark the entrace locations.

; 221B Baker Street

  (send dc draw-rectangle (* 16 (/ dc-width 20)) (* 16 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
  (send dc draw-text "221B Baker Street" (* 16.3 (/ dc-width 20)) (* 17 (/ dc-height 20)) #f 0 0)
  (send dc draw-rectangle (* 17 (/ dc-width 20)) (* 16 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))

; Chemist

 (send dc draw-rectangle (* 12 (/ dc-width 20)) (* 16 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Chemist" (* 13 (/ dc-width 20)) (* 17.5 (/ dc-height 20)) #f 0 0)
 (send dc draw-rectangle (* 13 (/ dc-width 20)) (* 16 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))

; Newsagent

 (send dc draw-rectangle (* 8 (/ dc-width 20)) (* 16 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Newsagent" (* 9 (/ dc-width 20)) (* 17.5 (/ dc-height 20)) #f 0 0)
  (send dc draw-rectangle (* 9 (/ dc-width 20)) (* 16 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))

; Locksmith

 (send dc draw-rectangle (* 0 (/ dc-width 20)) (* 16 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Locksmith" (* 0.5 (/ dc-width 20)) (* 17.5 (/ dc-height 20)) #f 0 0)
  (send dc draw-rectangle (* 3 (/ dc-width 20)) (* 17 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))

; Pawnbroker

 (send dc draw-rectangle (* 0 (/ dc-width 20)) (* 12 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Pawnbroker" (* 0.5 (/ dc-width 20)) (* 13.5 (/ dc-height 20)) #f 0 0)
  (send dc draw-rectangle (* 3 (/ dc-width 20)) (* 13 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))

; Docks

 (send dc draw-rectangle (* 0 (/ dc-width 20)) (* 0 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Docks" (* 1.2 (/ dc-width 20)) (* 1.5 (/ dc-height 20)) #f 0 0)
 (send dc draw-rectangle (* 3 (/ dc-width 20)) (* 1 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))
 
; Boar's Head

 (send dc draw-rectangle (* 0 (/ dc-width 20)) (* 4 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Boar's Head" (* 0.8 (/ dc-width 20)) (* 5.5 (/ dc-height 20)) #f 0 0)
 (send dc draw-rectangle (* 1 (/ dc-width 20)) (* 7 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))
 

; Park

 (send dc draw-rectangle (* 16 (/ dc-width 20)) (* 6 (/ dc-height 20)) (/ dc-width 2.5) (/ dc-height 2.5))
 (send dc draw-text "Park" (* 17.5 (/ dc-width 20)) (* 9 (/ dc-height 20)) #f 0 0)
 (send dc draw-rectangle (* 16 (/ dc-width 20)) (* 11 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))
 (send dc draw-rectangle (* 17 (/ dc-width 20)) (* 6 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))

; Scotland Yard

 (send dc draw-rectangle (* 16 (/ dc-width 20)) (* 0 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Scotland Yard" (* 17 (/ dc-width 20)) (* 1.5 (/ dc-height 20)) #f 0 0)
 (send dc draw-rectangle (* 18 (/ dc-width 20)) (* 3 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))
 
; Bank

 (send dc draw-rectangle (* 12 (/ dc-width 20)) (* 0 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Bank" (* 13.5 (/ dc-width 20)) (* 1.5 (/ dc-height 20)) #f 0 0)
 (send dc draw-rectangle (* 14 (/ dc-width 20)) (* 3 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))
 
; Museum

 (send dc draw-rectangle (* 8 (/ dc-width 20)) (* 0 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Museum" (* 9.2 (/ dc-width 20)) (* 1.5 (/ dc-height 20)) #f 0 0)
 (send dc draw-rectangle (* 8 (/ dc-width 20)) (* 2 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))

; Theatre

 (send dc draw-rectangle (* 6 (/ dc-width 20)) (* 6 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Theatre" (* 7.2 (/ dc-width 20)) (* 7.5 (/ dc-height 20)) #f 0 0)
 (send dc draw-rectangle (* 7 (/ dc-width 20)) (* 6 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))

; Carriage - Depot

 (send dc draw-rectangle (* 11 (/ dc-width 20)) (* 6 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Carriage - Depot" (* 11.5 (/ dc-width 20)) (* 7.15 (/ dc-height 20)) #f 0 0)
 (send dc draw-rectangle (* 14 (/ dc-width 20)) (* 8 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))

; Tobacconist

 (send dc draw-rectangle (* 6 (/ dc-width 20)) (* 11 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Tobacconist" (* 7 (/ dc-width 20)) (* 12.5 (/ dc-height 20)) #f 0 0)
  (send dc draw-rectangle (* 8 (/ dc-width 20)) (* 11 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20))

; Hotel

 (send dc draw-rectangle (* 11 (/ dc-width 20)) (* 11 (/ dc-height 20)) (/ dc-width 5) (/ dc-height 5))
 (send dc draw-text "Hotel" (* 12.5 (/ dc-width 20)) (* 12.5 (/ dc-height 20)) #f 0 0)
 (send dc draw-rectangle (* 11 (/ dc-width 20)) (* 13 (/ dc-height 20)) (/ dc-width 20) (/ dc-height 20)))
 
  
;; A test program for our piece% objects:
(define general%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-general dc)))

    ))
(define (draw-general dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 120 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  )
;; The pasteboard% that will hold and manage the sherlock pieces
(define board (new sherlock-board%))
(define board2 (new sherlock-board%))
;; Toplevel window for our application
(define toplevel (new frame% [label "The Sherlock Game"] [width (* 50 20)] [height (* 50 20)]))
(define toplevel2 (new frame% [label "The Sherlock Game"] [width (* 50 20)] [height (* 50 20)]))
(define clue-book (new frame% [label "The Clue Book"] [width (* 50 20)] [height (* 50 20)]))
;diceroll function which converts the output integral value of random number as string so that it can be displayed
(define diceroll (lambda(x)(cond
                       ((equal? x 1.0)"1")
                                 ((equal? x 2.0)"2")
                                 ((equal? x 3.0)"3")
                                 ((equal? x 4.0)"4")
                                 ((equal? x 5.0)"5")
                                 ((equal? x 6.0)"6"))))
;; The canvas which will display the pasteboard contents
(define canvas (new editor-canvas%
                    [parent toplevel]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor board]))
(define canvas21 (new editor-canvas%
                    [parent toplevel2]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor board2]))

;The Rules
(define rules%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-rules dc)))

    ))
(define (draw-rules dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 30 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "The Rules of The Game" 400 10)
  (send dc set-brush (send the-brush-list find-or-create-brush "white" 'solid))
  (send dc set-pen (send the-pen-list find-or-create-pen "silver" 2 'solid))

  (send dc set-font (send the-font-list find-or-create-font 14 'swiss 'normal 'bold))
  (send dc draw-text "Basic Play" 0 70)
  (send dc set-font (send the-font-list find-or-create-font 12 'default 'normal 'normal))
  (send dc draw-text "All players start at 221B Baker Street. The person who gets the highest number on the dice will start first. The basic procedure of play is to roll the dice" 0 100)
  (send dc draw-text "on your turn and move to the various locations on the board (e.g Museum, Park, Hotel) picking up clues which will help you in solving the case you are playing. Playing pieces" 0 130)
  (send dc draw-text "may not move diagonally." 0 160)
  (send dc set-font (send the-font-list find-or-create-font 12 'default 'slant 'bold))
  (send dc draw-text "Drag the mouse over the number on the screen to erase it after you have rolled the dice" 188 160)
  (send dc set-font (send the-font-list find-or-create-font 12 'default 'normal 'normal))

  (send dc set-font (send the-font-list find-or-create-font 14 'swiss 'normal 'bold))
  (send dc draw-text "Clues" 0 220)
  (send dc set-font (send the-font-list find-or-create-font 12 'default 'normal 'normal))
  (send dc draw-text "There are total fourteen locations on the map where you can pick up clues. Each of these locations are listed on the clue book. Once you arrive at a location, you are entitled to look" 0 250)
  (send dc draw-text "at the clue which corresponds to that location by clicking on clue book and then the name of the location you arrived at. You may study a clue fo up to 30 seconds. You are on your" 0 280)
  (send dc draw-text "honour to look at only the clue you are entitled to see. Once your 30 seconds are over, the clue will automatically dissapear and you may not again get the chance to re-visit the clue." 0 310)
  (send dc draw-text "Also, the other player must not cheat by looking at the clue that is being shown to his/her opponent. You may also note the contents of the clue on your solution checklist sheet." 0 340)

  (send dc set-font (send the-font-list find-or-create-font 14 'swiss 'normal 'bold))
  (send dc draw-text "Types of clues" 0 400)
  (send dc set-font (send the-font-list find-or-create-font 12 'default 'normal 'normal))
  (send dc draw-text "There are two basic types of clues: 1)the general statement clue, and 2) the puzzle clue(IMPORTANT). The general statement clue simply gives a statement of fact about the case being played," 0 430)
  (send dc draw-text "whereas the the puzzle clue is usually a syllable clue to a specific item - killer, motive, weapon etc. - and is labelled as such. For example, a puzzle clue might read: KILLER CLUE(Four Parts)" 0 460)
  (send dc draw-text "I) The opposite of east. Note that there are four parts to this clue and you have the first part (I) listed here. This means that there are three more parts to the KILLER CLUE, listed  " 0 490)
  (send dc draw-text "either seperately or together, at some other locations on the board. When you find other KILLER CLUES they might read as follows: KILLER CLUE(Four Parts) II) The alphabet letter after W" 0 520)
  (send dc draw-text "KILLER CLUE(Four Parts) III) The opposite of east. KILLER CLUE(Four Parts) IV) Atishoo, atishoo, we all ____ down. If there is a character named Alex Westfall mentioned somewhere in the" 0 550)
  (send dc draw-text "story than you now know that he is the killer. Furthermore, there might be some locations which might not have a clue so be on the lookout for these places" 0 580)


  )
(define rules(new frame%
                  [label "The Rules of the Game"]
                   [width 1920] [height 1080]
                   ))
(define rules-clue (new rules%))
(define canvas101 (new editor-canvas%
                    [parent rules]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor rules-clue]))
(send rules maximize 1)

;NEXT
(define rules2%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-rules2 dc)))

    ))

(define (draw-rules2 dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 14 'swiss 'normal 'bold))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
  (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "Carriage depot" 0 0)
  (send dc set-font (send the-font-list find-or-create-font 12 'default 'normal 'normal))
  (send dc draw-text "After moving into the Carriage Depot, you will want to check the clue there. Then, on your next turn, without rolling a dice, you may move your playing piece to any other" 0 30)
  (send dc draw-text "location on the board and check the clue there." 0 60)

  (send dc set-font (send the-font-list find-or-create-font 14 'swiss 'normal 'bold))
  (send dc draw-text "Location Entrances" 0 120)
  (send dc set-font (send the-font-list find-or-create-font 12 'default 'normal 'normal))
  (send dc draw-text "A seperate square off the main pathways marks the entrance to each location. You must count at least one extra move beyond this square(i.e exact throw not necessary) to enter the" 0 150)
  (send dc draw-text "location and check the clue." 0 180)

  (send dc set-font (send the-font-list find-or-create-font 14 'swiss 'normal 'bold))
  (send dc draw-text "Winning The Game" 0 240)
  (send dc set-font (send the-font-list find-or-create-font 12 'default 'normal 'normal))
  (send dc draw-text "When you think you have solved all the lettered items listed at the end of the case you are playing, return to 221B Baker Street (via you regular turns and roll of the dice)" 0 270)
  (send dc draw-text "To win, you must give the correct answer to all lettered items in the case - for example a)Killer b) weapon c)motive - but you do not have to explain all the intricacies" 0 300)
  (send dc draw-text "of the case. After announcing the solution, you may click on the solutions button to check your answers. If your solution is correct, then you win and let all the watsons read" 0 330)
  (send dc draw-text "the solution. However, if your answers are incorrect, then close the solution tab and let the other players continue the game(if more than 2 players are playing the game)." 0 360)
  (send dc draw-text "When announcing your answers, you do not have to give the exact answers listed in the solutions page,as long as you can show that you thoroughly understand the proper solution." 0 390)
  (send dc draw-text "For example, if the motive was inheritence and you said that she killed them because she knew that she will get all the money, then you are correct" 0 420)

  (send dc set-font (send the-font-list find-or-create-font 14 'swiss 'normal 'bold))
  (send dc draw-text "Alternate methods of play" 0 480)
  (send dc set-font (send the-font-list find-or-create-font 12 'default 'normal 'normal))
  (send dc draw-text "The game can be played competitively with indivuals or teams, or it can be played as a cooperative game with all players teaming up as Baker Street irregulars to help solve the case." 0 510)
  (send dc draw-text "When played in a group, the members first decide which locations to visit and the meaning of each clue is discussed by the group." 0 540)

    (send dc set-font (send the-font-list find-or-create-font 14 'swiss 'normal 'bold))
  (send dc draw-text "Rankings" 0 600)
  (send dc set-font (send the-font-list find-or-create-font 12 'default 'normal 'normal))
  (send dc draw-text "1-5 clues - Sherlock Holmes         6-11 clues - Detective         12 clues - Gumshoe         13 clues - Scotland Yard Inspector         14 clues - Dr Watson" 0 630)
  )
(define rules20(new frame%
                  [label "Rules"]
                   [width 1920] [height 1080]
                   ))
(define rules-2 (new rules2%))
(define canvas102 (new editor-canvas%
                    [parent rules20]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor rules-2]))
(new button% [parent rules]
             [vert-margin 15]
             [label "Next"]          
                         [callback (lambda (button event)
                                     (send rules show #f)
                                     (send rules20 show #t)     
                                     )])
(send rules20 maximize 1)
;NEXT 2
(define rules3%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-rules3 dc)))

    ))

(define (draw-rules3 dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 60 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
  (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "The Game Is On !!!" 350 250))
(define rules30(new frame%
                  [label "Lets begin ..."]
                   [width 1920] [height 1080]
                   ))
(define rules-3 (new rules3%))
(define canvas103 (new editor-canvas%
                    [parent rules30]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                   [editor rules-3]))
(new button% [parent rules20]
             [vert-margin 3]
             [label "Next"]          
                         [callback (lambda (button event)
                                     (send rules20 show #f)
                                     (send rules30 show #t)     
                                     )])
(new button% [parent rules20]
             [vert-margin 3]
             [label "Back"]          
                         [callback (lambda (button event)
                                     (send rules20 show #f)
                                     (send rules show #t)     
                                     )])

;Main Menu
(define main-menu%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-mainmenu dc)))

    ))
(define (draw-mainmenu dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 70 'decorative 'italic 'bold))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc set-text-foreground "blue")
  (send dc draw-text "The Sherlock Game" 250 200)

  (send dc set-brush (send the-brush-list find-or-create-brush "white" 'solid))
  (send dc set-pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (send dc set-font (send the-font-list find-or-create-font 20 'default 'normal 'normal))

  )
(define mainmenu1(new frame%
                  [label "Main Menu"]))
(define main-menu1 (new main-menu%))
(define canvas406 (new editor-canvas%
                    [parent mainmenu1]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor main-menu1]))
(new button% [parent rules30]
             [vert-margin 15]
             [label "Lets Begin"]
             [callback (lambda (button event)
                                     (send rules30 show #f)
                                     (send mainmenu1 show #t)
                                     )])
(new button% [parent rules30]
             [vert-margin 3]
             [label "Back"]          
                         [callback (lambda (button event)
                                     (send rules30 show #f)
                                     (send rules20 show #t)     
                                     )])
(new button% [parent mainmenu1]
             [vert-margin 30]
             [label "1 vs 1"]
             [callback (lambda (button event)
                                     (send mainmenu1 show #f)
                                     (send toplevel show #t)
                                     )])
(new button% [parent mainmenu1]
             [vert-margin 30]
             [label "Group game"]
             [callback (lambda (button event)
                                     (send mainmenu1 show #f)
                                     (send toplevel2 show #t)
                                     )])

(send rules30 maximize 1)
(send toplevel maximize 1)
(send mainmenu1 maximize 1)
(send toplevel2 maximize 1)

(send toplevel show #f)
(send rules show #t)
; Roll the Dice

(define dc (send canvas get-dc))
(define font (send the-font-list find-or-create-font 100 'decorative 'italic 'bold))
(send dc set-font font)

(new button% [parent toplevel]
             [vert-margin 5]
             [label "Roll the Dice"]          
                         [callback (lambda (button event)
                                     (define y (truncate (+ (* (random) 6) 1)))
                                     (send dc draw-text (diceroll y) 650 200)     
                                     )])
(define dc2 (send canvas21 get-dc))
(define font2 (send the-font-list find-or-create-font 100 'decorative 'italic 'bold))
(send dc2 set-font font2)

(new button% [parent toplevel2]
             [vert-margin 5]
             [label "Roll the Dice"]          
                         [callback (lambda (button event)
                                     (define y (truncate (+ (* (random) 6) 1)))
                                     (send dc2 draw-text (diceroll y) 650 200)     
                                     )])
;Options
(define options%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-options1 dc)))

    ))
(define (draw-options1 dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font
  ))
(define options10(new frame%
                  [label "options"]))
(define options-clue (new options%))
(define canvas211 (new editor-canvas%
                    [parent options10]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor options-clue]))
(new button% [parent toplevel]
             [vert-margin 5]
             [label "Options"]
             [callback (lambda (button event)
                                     
                                     (send options10 show #t)
                                     )])
(new button% [parent toplevel2]
             [vert-margin 5]
             [label "Options"]
             [callback (lambda (button event)
                                     (send options10 show #t)
                                     
                                     )])
(new button% [parent options10]
             [vert-margin 15]
             [label "Clue Book"]
             [callback (lambda (button event)
                                     (send options10 show #f)
                                     (send cluebook show #t)
                                     )])
(new button% [parent options10]
             [vert-margin 15]
             [label "The Case"]
             [callback (lambda (button event)
                                     (send options10 show #f)
                                     (send case show #t)
                                     )])
(new button% [parent options10]
             [vert-margin 15]
             [label "Rules"]
             [callback (lambda (button event)
                                     (send rules show #t)
                                     (send options10 show #f)
                                     )])

(new button% [parent options10]
             [vert-margin 15]
             [label "The Solution"]
             [callback (lambda (button event)
                                     (send options10 show #f)
                                     (send solution-approval show #t)
                                     )])

; Clue Book
(define (draw-clue-book dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 120 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  )
(define cluebook(new frame%
                  [label "The Clue Book"]))
(define book (new general%))
(define canvas0 (new editor-canvas%
                    [parent cluebook]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor book]))


;The Case
(define case%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-case dc)))

    ))
(define (draw-case dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 30 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
  (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc set-text-background "silver")
  (send dc draw-text "The Adventure Of The Silver Patch" 400 10)

  (send dc set-brush (send the-brush-list find-or-create-brush "white" 'solid))
  (send dc set-pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (send dc set-font (send the-font-list find-or-create-font 14 'default 'normal 'normal))
  
  (send dc draw-text "Yesterday morning, the famous 'horse', Silver patch and his trainer Oscar Swift, were found dead in the horse's stall at Cosgrove Sables." 0 100)
  (send dc draw-text "The horse had been poisoned and the trainer had been hit over the head and stabbed repeatedly with a sharp object." 0 130)
  (send dc draw-text "Silver Patch, so named for the patch of silver hair on his mane, was owned by Sir Reginald Cosgrove, a breeder who also owns four other horses." 0 160)
  (send dc draw-text "Persons routinely questioned by Inspector Gregson of Scotland Yard include Sir Reginald Cosgrove and his petite wife, Hilda Cosgrove;" 0 190)
  (send dc draw-text "the Cosgrove cook Mrs Maggie Doan, Mrs Doan's husband, house painter Henry Doan and rival horse breeder Sir Archibald Baxter. Scotland Yard" 0 220)
  (send dc draw-text "is also lookingfor one Bobby Jansen, a stable boy who left the Cosgrove's employ unhappily about a month ago." 0 250)
  (send dc draw-text "The only clues discovered at the scene of the crime were some broker pieces of glass from the bottom of the beer bottle, and a pawnbroker's ticket." 0 280)
  (send dc draw-text "Unable to develop a solid lead, Inspector Gregson has come to 221B Baker Street to consult with the master detective. Gregson wants to know" 0 310)
  (send dc draw-text "a) Who killed the horse and the trainer" 0 340)
  (send dc draw-text "b) the weapon used to kill the trainer" 0 370)
  (send dc draw-text "c) the Motive" 0 400)
  )
(define case(new frame%
                  [label "The Case"]))
(define the-case (new case%))
(define canvas404 (new editor-canvas%
                    [parent case]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor the-case]))

(send case maximize 1)

;The Solution Approval
(define solution-approval%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-solutionapproval dc)))

    ))
(define (draw-solutionapproval dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 35 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "Are you sure?" 500 50)

  (send dc set-brush (send the-brush-list find-or-create-brush "white" 'solid))
  (send dc set-pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (send dc set-font (send the-font-list find-or-create-font 20 'default 'normal 'normal))

  )
(define solution-approval(new frame%
                  [label "Solution approval"]))
(define solutionapproval (new solution-approval%))
(define canvas405 (new editor-canvas%
                    [parent solution-approval]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor solutionapproval]))

;The SOLUTION
(define solution%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-solution1 dc)))

    ))
(define (draw-solution1 dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 30 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "Solution to The Adventure Of The Silver Patch" 330 10)

  (send dc set-brush (send the-brush-list find-or-create-brush "white" 'solid))
  (send dc set-pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (send dc set-font (send the-font-list find-or-create-font 14 'default 'normal 'normal))
  (send dc draw-text "Sir Reginald Cosgrove, in dire need of money, concoted a plot to collect money from his large insurance policy on silver patch. Sir Reginald painted over the" 0 100)
  (send dc draw-text "Silver patch on the mane of his prize horse, and painted a silver patch on the mane of Night Dancer, another one of his horses. He then switched stalls and" 0 130)
  (send dc draw-text "poisoned Night Dancer who now looked like the Silver Patch. Realising That he would have to take Oscar Switt into his confidence, Sir Reginald arranged for his" 0 160)
  (send dc draw-text "trainer to meet him at the stables. When Switt refused to go along with Sir Reginald's plan to kill Night Dancer, Sir Reginald became enraged and killed the " 0 190)
  (send dc draw-text "trainer, hitting him over the head with a beer bottle and then stabbing him repeatedly with the broken bottle." 0 220)
  (send dc draw-text "KILLER: Sir Reginald Cosgrove" 0 250)
  (send dc draw-text "WEAPON: Broken Bottle" 0 280)
  (send dc draw-text "MOTIVE: Insurance" 0 310)


  )
(define solution2(new frame%
                  [label "The Solution"]))
(define solution3 (new solution%))
(define canvas407 (new editor-canvas%
                    [parent solution2]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor solution3]))
(new button% [parent solution-approval]
             [label "YES"]
             [vert-margin 40]
             [callback (lambda (button event)
                         (send solution-approval show #f)
                         (send solution2 show #t)    
                                     )])
(send solution-approval maximize 1)
(send solution2 maximize 1)



;Chemist
(define chemist%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-chemist dc)))

    ))
(define (draw-chemist dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "The floor of Silver Patch's stall contained some freshly black paint" 0 0)
  )
(define chemist(new frame%
                  [label "Chemist"]))
(define chem-clue (new chemist%))
(define canvas1 (new editor-canvas%
                    [parent chemist]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor chem-clue]))

;Bank
(define bank%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-bank dc)))

    ))
(define (draw-bank dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "Sir Reginald Cosgrove had a large insurance policy on his prize horse, Silver Patch." 0 0)
  )
(define bank(new frame%
                  [label "bank"]))
(define bank-clue (new bank%))
(define canvas2 (new editor-canvas%
                    [parent bank]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor bank-clue]))

;Carriage-Depot
(define Carriage-Depot%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-Carriage-Depot dc)))

    ))
(define (draw-Carriage-Depot dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "WEAPON CLUE(Three parts)" 0 0)
  (send dc draw-text "III) Not a Gottle of Gear but a ______ of beer" 0 30)
  )
(define Carriage-Depot(new frame%
                  [label "Carriage-Depot"]))
(define Carriage-Depot-clue (new Carriage-Depot%))
(define canvas3 (new editor-canvas%
                    [parent Carriage-Depot]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor Carriage-Depot-clue]))
;Docks
(define Docks%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-Docks dc)))

    ))
(define (draw-Docks dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "KILLER CLUE(Two Parts)" 0 0)
  (send dc draw-text "II) Group of orange trees" 0 30)
  )
(define Docks(new frame%
                  [label "Docks"]))
(define Docks-clue (new Docks%))
(define canvas4 (new editor-canvas%
                    [parent Docks]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor Docks-clue]))
;Hotel
(define Hotel%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-Hotel dc)))

    ))
(define (draw-Hotel dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "Some fresh silver paint was foundon the stall floor of Night dancer, another of Sir Reginald's horses" 0 0)
  )
(define Hotel(new frame%
                  [label "bank"]))
(define Hotel-clue (new Hotel%))
(define canvas5 (new editor-canvas%
                    [parent Hotel]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor Hotel-clue]))
;Locksmith
(define Locksmith%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-Locksmith dc)))

    ))
(define (draw-Locksmith dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "No Clue :(" 0 0)
  )
(define Locksmith(new frame%
                  [label "Locksmith"]))
(define Locksmith-clue (new Locksmith%))
(define canvas6 (new editor-canvas%
                    [parent Locksmith]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor Locksmith-clue]))
;Museum
(define Museum%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-Museum dc)))

    ))
(define (draw-Museum dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "MOTIVE CLUE(Three Parts)" 0 0)
  (send dc draw-text "II) Another word for positive or certain" 0 30)
  )
(define Museum(new frame%
                  [label "Museum"]))
(define Museum-clue (new Museum%))
(define canvas7 (new editor-canvas%
                    [parent Museum]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor Museum-clue]))
;Newsagent
(define Newsagent%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-Newsagent dc)))

    ))
(define (draw-Newsagent dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "MOTIVE CLUE(Three Parts)" 0 0)
  (send dc draw-text "I) Another name for Tavern" 0 30)
  (send dc draw-text "III) Insects in restless people's underwear." 0 60)
  )
(define Newsagent(new frame%
                  [label "Newsagent"]))
(define Newsagent-clue (new Newsagent%))
(define canvas8 (new editor-canvas%
                    [parent Newsagent]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor Newsagent-clue]))
;Park
(define Park%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-Park dc)))

    ))
(define (draw-Park dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "KILLER CLUE(Two Parts)" 0 0)
  (send dc draw-text "Something that produces an effect" 0 30)
  )
(define Park(new frame%
                  [label "Park"]))
(define Park-clue (new Park%))
(define canvas9 (new editor-canvas%
                    [parent Park]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor Park-clue]))
;Pawnbroker
(define Pawnbroker%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-Pawnbroker dc)))

    ))
(define (draw-Pawnbroker dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "The pawnbroker's ticket at the scene of the crime belonged to Sir Reginald Cosgrove." 0 0)
  )
(define Pawnbroker(new frame%
                  [label "Pawnbroker"]))
(define Pawnbroker-clue (new Pawnbroker%))
(define canvas10 (new editor-canvas%
                    [parent Pawnbroker]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor Pawnbroker-clue]))
;Theatre
(define Theatre%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-Theatre dc)))

    ))
(define (draw-Theatre dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "Footprints at the stables show that the killer wore a size 12 shoe" 0 0)
  )
(define Theatre(new frame%
                  [label "Theatre"]))
(define Theatre-clue (new Theatre%))
(define canvas11 (new editor-canvas%
                    [parent Theatre]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor Theatre-clue]))
;Boar's Head
(define Boars-Head%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-Boars-Head dc)))

    ))
(define (draw-Boars-Head dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "WEAPON CLUE(Three Parts)" 0 0)
  (send dc draw-text "I) When you have no money you are flat ______." 0 30)
  (send dc draw-text "II) An egg layer dropping her H's" 0 60)
  )
(define Boars-Head(new frame%
                  [label "Boar's Head"]))
(define Boars-Head-clue (new Boars-Head%))
(define canvas12 (new editor-canvas%
                    [parent Boars-Head]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor Boars-Head-clue]))
;Scotland Yard
(define scotland-yard%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-scotland-yard dc)))

    ))
(define (draw-scotland-yard dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "Bobby Jansen is now working at the Locksmith" 0 0)
  )
(define scotland-yard(new frame%
                  [label "Scotland Yard"]))
(define scotland-yard-clue (new scotland-yard%))
(define canvas13 (new editor-canvas%
                    [parent scotland-yard]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor scotland-yard-clue]))
;Tobacconist
(define tobacconist%
  (class pasteboard%
    (super-new)

    (define/override (on-paint before? dc . other)
      (when before?
        (draw-tobacconist dc)))

    ))
(define (draw-tobacconist dc)
  (define brush (send the-brush-list find-or-create-brush "white" 'solid))
  (define pen (send the-pen-list find-or-create-pen "silver" 2 'solid))
  (define font (send the-font-list find-or-create-font 20 'default 'normal 'normal))
  (define-values (dc-width dc-height) (send dc get-size))
  (define cell-width (/ dc-width 20))
  (define cell-height (/ dc-height 20))
  (define margin 1)
   
   (send dc clear)
  (send dc set-brush brush)
  (send dc set-pen pen)
  (send dc set-font font)
  (send dc draw-text "Sir Reginald would never kill his prize horse, Silver Patch" 0 0)
  )
(define tobacconist(new frame%
                  [label "tobacconist"]))
(define tobacconist-clue (new tobacconist%))
(define canvas14 (new editor-canvas%
                    [parent tobacconist]
                    [style '(no-hscroll no-vscroll)]
                    [horizontal-inset 0]
                    [vertical-inset 0]
                    [editor tobacconist-clue]))


;Buttons for the Clue Book
(send chemist maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Chemist"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send chemist show #t)
                         (sleep/yield 30)
                         (send chemist show #f)
                                     )])
(send bank maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Bank"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send bank show #t)
                         (sleep/yield 30)
                         (send bank show #f)
                                    )])
(send Carriage-Depot maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Carriage-Depot"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send Carriage-Depot show #t)
                         (sleep/yield 30)
                         (send Carriage-Depot show #f)
                                     )])
(send Docks maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Docks"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send Docks show #t)
                         (sleep/yield 30)
                         (send Docks show #f)
                                     )])
(send Hotel maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Hotel"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send Hotel show #t)
                         (sleep/yield 30)
                         (send Hotel show #f)
                                     )])
(send Locksmith maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Locksmith"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send Locksmith show #t)
                         (sleep/yield 30)
                         (send Locksmith show #f)
                                     )])
(send Museum maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Museum"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send Museum show #t)
                         (sleep/yield 30)
                         (send Museum show #f)
                                     )])
(send Newsagent maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Newsagent"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send Newsagent show #t)
                         (sleep/yield 30)
                         (send Newsagent show #f)
                                     )])
(send Park maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Park"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send Park show #t)
                         (sleep/yield 30)
                         (send Park show #f)
                                     )])
(send Pawnbroker maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Pawnbroker"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send Pawnbroker show #t)
                         (sleep/yield 30)
                         (send Pawnbroker show #f)
                                     )])
(send Theatre maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Theatre"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send Theatre show #t)
                         (sleep/yield 30)
                         (send Theatre show #f)
                                     )])
(send Boars-Head maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Boar's Head"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send Boars-Head show #t)
                         (sleep/yield 30)
                         (send Boars-Head show #f)
                                     )])
(send scotland-yard maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Scotland Yard"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send scotland-yard show #t)
                         (sleep/yield 30)
                         (send scotland-yard show #f)
                                     )])
(send tobacconist maximize 1)
(new button% [parent cluebook]
             [vert-margin 12]
             [label "Tobacconist"]
             [callback (lambda (button event)
                         (send cluebook show #f)
                         (send tobacconist show #t)
                         (sleep/yield 30)
                         (send tobacconist show #f)
                                     )])


;; Insert one of each of the sherlock pieces onto the board, so we can see them
;; and drag them around.
(for ([id (in-hash-keys sherlock-piece-data)])
  (define piece (make-sherlock-piece id))
  (send board insert piece (+ (random 180) 1120) (+ (random 35) 570)))
(for ([id (in-hash-keys piece-data)])
  (define piece (make-piece id))
  (send board2 insert piece (+ (random 180) 1120) (+ (random 35) 570)))