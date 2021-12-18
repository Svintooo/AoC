#!/usr/bin/env ruby


## INPUT
data = case when File.exists?(ARGV[0])
            then ARGF.read
            else ARGV[0]
            end


## PARSING
asdf = data.lines.map(&:strip)


## HELP CODE


## CHECK


## CALCULATE


## ANSWER
answer = nil
puts answer
