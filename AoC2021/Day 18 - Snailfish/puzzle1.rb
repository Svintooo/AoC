#!/usr/bin/env ruby
require "json"

## INPUT
data = case when File.exists?(ARGV[0])
            then ARGF.read
            else ARGV[0]
            end


## PARSING
numbers = data.lines.map(&:strip)
              .map{|line| JSON.parse(line) }
#pp numbers


## HELP CODE
def explode(number)
end

def split(number)
end


## CHECK


## CALCULATE


## ANSWER
answer = nil
puts answer
