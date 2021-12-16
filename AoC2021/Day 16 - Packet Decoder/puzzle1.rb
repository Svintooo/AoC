#!/usr/bin/env ruby


## INPUT
data = ARGF.read


## PARSING
hexadecimal = data.strip


## HELP CODE


## CHECK


## CALCULATE
#binary = hexadecimal.to_i(16).to_s(2).chars#.map(&:to_i)
binary = hexadecimal.chars.map{|hex| hex.to_i(16).to_s(2).rjust(4,'0') }.join.chars#.map(&:to_i)
p binary.join #DEBUG

package = {}
package[:version] = binary.shift(3).join.to_i(2)
package[:type_id] = binary.shift(3).join.to_i(2)
#pp package #DEBUG

case package[:type_id]
  when 4
    package[:value  ] = []

    loop do
      bits = binary.shift(5)
      package[:value] << bits[1..-1].join

      break if bits[0] == '0'
    end
    package[:value] = package[:value].join.to_i(2)
  #when end
end
pp package #DEBUG


## ANSWER
answer = nil
puts answer
