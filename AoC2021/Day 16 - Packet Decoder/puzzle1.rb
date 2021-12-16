#!/usr/bin/env ruby


## INPUT
data = ARGF.read


## PARSING
hexadecimal = data.strip


## HELP CODE


## CHECK


## CALCULATE
binary = hexadecimal.to_i(16).to_s(2).chars.map{|bin| bin.to_i }
p binary.join #DEBUG
package = {}
package[:version] = binary.shift(3).join
package[:type_id] = binary.shift(3)



## ANSWER
answer = nil
puts answer
