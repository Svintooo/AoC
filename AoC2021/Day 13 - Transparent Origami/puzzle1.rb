#!/usr/bin/env ruby


## INPUT
dots = []
fold = []

ARGF.each_line do |line|
  line = line.strip

  if [0123456789].include? line.chars[0]
    dots << line
  elsif line == ""
    next
  else#if line.split[0] == "fold"
    fold << line
  end
end



## PARSING
dots.map!{|dot| dot.split(',').map(&:to_i) }
fold_x
fold_y
fold.each{|line|
           key,val = line.split.last.split('=')
           fold_x = val.to_i if key == 'x'
           fold_y = val.to_i if key == 'y'
         }


## HELP CODE


## CHECK


## CALCULATE


## ANSWER
answer = nil
puts answer
