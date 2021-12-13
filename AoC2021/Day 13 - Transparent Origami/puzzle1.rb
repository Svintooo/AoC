#!/usr/bin/env ruby


## INPUT
DOT = '#'
EMPTY = '.'

dots  = []
folds = []

ARGF.each_line do |line|
  line = line.strip  # Remove newline character

  if ["0","1","2","3","4","5","6","7","8","9"].include? line.chars[0]
    dots << line
  elsif line == ""
    next
  else#if line.split[0] == "fold"
    folds << line
  end
end
#p dots #DEBUG
#p folds #DEBUG



## PARSING
dots.map!{|dot| dot.split(',').map(&:to_i) }
folds = folds.map{|line| line.split.last.split('=') }
             .map{|x_or_y,number| [x_or_y,number.to_i] }
#p dots #DEBUG
#p folds #DEBUG


## HELP CODE

# Create the paper
paper = []
paper_height = dots.map{|_,y| y }.max + 1
paper_width  = dots.map{|x,_| x }.max + 1
#p paper_height #DEBUG
#p paper_width #DEBUG

paper_height.times do |i|
  paper[i] = Array.new(paper_width, EMPTY)
end
#pp paper #DEBUG


# Fill in dots on paper
dots.each do |x,y|
  paper[y][x] = DOT
end
#pp paper #DEBUG
#puts;paper.each{|line| puts line.join } #DEBUG


## CHECK
raise "Fold-x contains dots" unless folds.select{|char,_| char == 'x'}.all?{|_,x| paper.all?{|line| line[x] == EMPTY } }
raise "Fold-y contains dots" unless folds.select{|char,_| char == 'y'}.all?{|_,y| paper[y].all?{|char| char == EMPTY } }


## CALCULATE

# Fold
folds.each do |char,num|
  case char
  when 'x'
    fold_x = num
    paper.each_index do |y|
      (fold_x+1).upto(paper[y].length-1).each do |x|
        next unless paper[y][x] == DOT
        paper[y][fold_x - x + fold_x] = DOT
      end
    end
    paper.each_index{|y| paper[y] = paper[y][0..fold_x] }

  when 'y'
    fold_y = num
    (fold_y+1).upto(paper.length-1).each do |y|
      paper[y].each_index do |x|
        next unless paper[y][x] == DOT
        paper[(fold_y - y + fold_y)][x] = DOT
      end
    end
    paper = paper[0...fold_y]
  end

  break  # Puzzle 1 is only interested in the first fold
end

#pp paper #DEBUG
#puts;paper.each{|line| puts line.join } #DEBUG


## ANSWER
answer = paper.flatten.select{|char| char == DOT }.count
puts answer
