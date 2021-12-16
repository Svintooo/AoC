#!/usr/bin/env ruby


## INPUT
data = ARGF.read


## PARSING
hexadecimal = data.strip


## HELP CODE


## CHECK


## CALCULATE
#binary = hexadecimal.to_i(16).to_s(2).chars.map(&:to_i)
binary = hexadecimal.chars.map{|hex| hex.to_i(16).to_s(2).rjust(4,'0') }.join.chars#.map(&:to_i)
p binary.join #DEBUG

package = {}
package[:version] = binary.shift(3).join.to_i(2)
package[:type_id] = binary.shift(3).join.to_i(2)
pp package #DEBUG


## ANSWER
answer = nil
puts answer
