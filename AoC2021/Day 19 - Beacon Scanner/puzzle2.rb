#!/usr/bin/env ruby


## INPUT
data = case when File.exists?(ARGV[0])
            then ARGF.read
            else ARGV[0]
            end


## CHECK


## PARSING
asdf = data.lines.map(&:strip)


## CALCULATE


## ANSWER
answer = nil
puts answer
