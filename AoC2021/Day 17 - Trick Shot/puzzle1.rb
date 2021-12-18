#!/usr/bin/env ruby


## INPUT
data = File.exists?(ARGV[0]) \
     ? ARGF.read \
     : ARGV[0]


## PARSING
target = data.gsub("target area: ","")
             .split(/, */)
             .map{|str|
               str = str.split('=')
               str[-1] = str[-1].split('..')
                                .map(&:to_i)
                                .sort
             }
             .yield_self{|d| [:xr,:yr].zip(d).to_h }
p target #DEBUG


## HELP CODE


## CHECK


## CALCULATE


## ANSWER
answer = nil
puts answer
