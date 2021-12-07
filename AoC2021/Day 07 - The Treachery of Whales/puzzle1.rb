#!/usr/bin/env ruby
data = ARGF.read


## PARSING
crab_subs = data.strip.split(',').map(&:to_i).sort
#p crab_subs #DEBUG


## CHECK
#N/A


## CALCULATE
position = crab_subs[(crab_subs.count/2).floor]  # Median value
#p position #DEBUG

fuel = crab_subs.map{|v| (v-position).abs }.sum
#p fuel #DEBUG


## ANSWER
answer = fuel
puts answer
