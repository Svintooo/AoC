#!/usr/bin/env ruby


## INPUT
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

fold_x = nil
fold_y = nil
folds.each{|line|
            key,val = line.split.last.split('=')
            fold_x = val.to_i if key == 'x'
            fold_y = val.to_i if key == 'y'
          }
#p dots #DEBUG
#p [fold_x,fold_y] #DEBUG


## HELP CODE

# Create the paper
paper = []
paper_height = dots.map{|_,y| y }.max + 1
paper_width  = dots.map{|x,_| x }.max + 1
#p paper_height #DEBUG
#p paper_width #DEBUG

paper_height.times do |i|
  paper[i] = Array.new(paper_width, '.')
end
#pp paper #DEBUG


# Fill in dots on paper
dots.each do |x,y|
  paper[y][x] = '#'
end
#pp paper #DEBUG
#paper.each{|line| puts line.join } #DEBUG


## CHECK


## CALCULATE


## ANSWER
answer = nil
puts answer
