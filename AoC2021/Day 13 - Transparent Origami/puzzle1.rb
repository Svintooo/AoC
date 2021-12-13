#!/usr/bin/env ruby


## INPUT
dots = []
fold = []

ARGF.each_line do |line|
  line = line.strip  # Remove newline character

  if [0,1,2,3,4,5,6,7,8,9].include? line.chars[0]
    dots << line
  elsif line == ""
    next
  else#if line.split[0] == "fold"
    fold << line
  end
end



## PARSING
dots.map!{|dot| dot.split(',').map(&:to_i) }

fold_x = nil
fold_y = nil
fold.each{|line|
           key,val = line.split.last.split('=')
           fold_x = val.to_i if key == 'x'
           fold_y = val.to_i if key == 'y'
         }


## HELP CODE
# Create the paper
paper = []
paper_height = dots.map{|_,y| y }.max
paper_width  = dots.map{|x,_| x }.max

paper_height.each do |i|
  paper[i] == Array.new(paper_width, '.')
end
pp paper #DEBUG

# Fill in dots on paper
dots.each do |x,y|
  paper[y][x] = '#'
end
pp paper #DEBUG


## CHECK


## CALCULATE


## ANSWER
answer = nil
puts answer
