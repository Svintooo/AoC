#!/usr/bin/env ruby
NEWLINE = /(?:\r\n?|\n)/


## INPUT
data = ARGF.read


## CHECK


## PARSING
scanners = data.split(/#{NEWLINE}#{NEWLINE}/)
               .map{|scanner|
                 scanner.gsub(/\A--- scanner . ---/,'')
                        .strip
                        .split(NEWLINE)
                        .map{|beacon|
                          beacon.split(',')
                                .map(&:to_i)
                        }
               }
pp scanners


## CALCULATE


## ANSWER
answer = nil
puts answer
