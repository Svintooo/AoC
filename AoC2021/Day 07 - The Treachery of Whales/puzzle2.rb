#!/usr/bin/env ruby
data = ARGF.read


## PARSING
crab_subs = data.strip.split(',').map(&:to_i).sort
#p crab_subs #DEBUG


## CHECK
#N/A


## CALCULATE
# Mean value
position = crab_subs.map(&:to_f)
                    .yield_self{|a| a.sum/a.count }
                    .to_i
#p position #DEBUG

# One of the surrounding positions of the mean value seems
# to be the most optimal one (according to my tests).
# Though, I am not sure why this is.
positions = [position-1, position, position+1]
#p positions

# Calculate the fuel cost of all positions
fuels = positions.map{|pos|
                   crab_subs.map{|v|
                     # Calculate triangular number (4 -> 1+2+3+4)
                     t = (v-pos).abs
                     (t * (t + 1)) / 2
                   }.sum
                 }
#p fuels

# Take the most optimal fuel cost
fuel = fuels.min
#p fuel #DEBUG


## ANSWER
answer = fuel
puts answer
