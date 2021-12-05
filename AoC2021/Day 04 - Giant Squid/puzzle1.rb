#!/usr/bin/env ruby

filename = ARGV[0]
data     = IO.read(filename)
lines    = data.split(/\n\r?|\r/)

# PARSING
bingo_numbers = lines.shift.split(',').map(&:to_i)


#PARSING
#  läs in rad 1
#    splitta på ','
#    spara ner i en Vec: bingo_numbers
#
#  skapa en Vec: bingo_boards
#
#  loop
#    skippa 1 tom rad
#    skapa en Vec: bingo_board
#    läs 5 rader
#      splitta på whitespace till en vec, push:a till bingo_board
#    push:a bingo_board till bingo_boards
#
#CHECK
#  kontrollera hur man accessar ett värde
#    förhoppningsvis med bingo_boards[i][x][y]
#
#
#CALCULATION
#  skapa en funktion: check_if_bingo()
#    som kontrollerar om en board har fått bingo
#    bingo: fem 0 i rad, horisontellt eller vertikalt
#
#  loop: bingo_number in bingo_numbers
#    hitta alla bingo_number i bingo_boards
#      skriv över dom med 0
#    hitta alla bingo_board som fått 5st 0 i rad
#      (horisontellt eller vertikalt)
#      summera alla värden, multiplicera med bingo_number, spara i final_score
#      let boards_got_bingo
#        spara bingo_id
#        spara final_score
