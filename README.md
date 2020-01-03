# Racket-GUI-Board-Game

## Project Overview
Design, code, and present a GUI game within a group of 1 to 5. During the development phase, a   prototype software will be used to allow a deeper understanding of the final product.   Racket will be the language used to create the game. Since the game will have GUI-the library will be imported `(require racket / gui / base)` - the base library will have the required class, configuration, and method bindings specified in this manual. `#lang racket / gui` — The language of racket / gui integrates all racket code bindings with racket / gui / base and racket / draw plugins.

## Create a GUI game which follows some rules:
* Must have GUI
* Must be a game / allow people to play
* Feedback showing the game state
* Allow players to perform moves
* Disallow illegal moves
* Wining state + notification

## Recommendation 
* With this type of challenge you will want to focus on user friendliness, ease of use (simplicity is key)
* Use a prototype tool (software) to create an idea before coding 

## Game
### Sherlock Holmes 221B Baker Street Board Game
* 2 Player game (Can add more later)
* The game is TBG
* Before the game starts the player is presented a case with 1-3 questions
* You start at 221B
* Player roles a dice (1-6), the player chooses which square to move to
* Specific locations where the player recieves the clues
* Player needs to answer the questions presented in the start, if succesfully answered the game is won, else __game over__.
* Scoring system:
  * 1-4 clues = "Sherlock Holmes"
  * 4-6 clues = "Sleuth"
  * 6-8 clues = "Scotland Yard"
  * 8-10 clues = "Dr Watson"
  
### Rules:
* Once the player is at a specific location, they only recieve 1 clue
* Each player gets 1 turn
* The player can move around the map for ulimited amount of times, to finish the game - the player must return to 221B
* Once the player returns to 221B to solve the case, if the answer is wrong - GAME OVER for the specific player
* Player gets to role the dice and move to any direction they choose
* 30 Second time limit for each clue given
* Present the clue for 1 player only
* Highlight only squares where the player can move

### Optional Rules:
* There may be a location where a clue is not provided

#### Board Settings:
* Board size is __23x23 squares__
* There are __14 locations__
* Each location has __1 entrance__

### If there is time (For extra SOBs)
* Add Racket library which allows LAN play

