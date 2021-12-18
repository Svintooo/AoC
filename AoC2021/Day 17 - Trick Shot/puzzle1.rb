#!/usr/bin/env ruby


## INPUT
data = File.exists?(ARGV[0]) \
     ? ARGF.read \
     : ARGV[0]


## PARSING
asdf = data.gsub("target area: ")
           .split(/, */)
           .map{|xs,ys|
             #
           }


## HELP CODE


## CHECK


## CALCULATE


## ANSWER
answer = nil
puts answer
