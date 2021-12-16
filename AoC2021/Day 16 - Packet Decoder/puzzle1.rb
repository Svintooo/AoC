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

packets = []
bits_to_take = []
packets_to_find = []

loop do
  bits_to_take.pop while !bits_to_take.empty?    && bits_to_take.last    <= 0
  packets_to_find  while !packets_to_find.empty? && packets_to_find.last <= 0
  break if binary.length < 11

  packet = {}
  packet[:version] = binary.shift(3).join.to_i(2)
  packet[:type_id] = binary.shift(3).join.to_i(2)
  bits_to_take.last -= 6 unless bits_to_take.empty?
  #pp packet #DEBUG

  case packet[:type_id]
    when 4
      packet[:value] = []

      loop do
        bits = binary.shift(5)
        bits_to_take.last -= 5 unless bits_to_take.empty?

        packet[:value] << bits[1..-1].join

        break if bits[0] == '0'
      end

      packet[:value] = packet[:value].join.to_i(2)
    else
      packet[:length_type_id] = binary.shift(1)
      bits_to_take.last -= 1 unless bits_to_take.empty?

      case packet[:length_type_id]
        when '0'
          packet[:sub_packets_lenght] = binary.shift(15).join.to_i
          bits_to_take.last -= 15 unless bits_to_take.empty?

          bits_to_take << packet[:sub_packets_lenght]
        when '1'
          packet[:number_of_sub_packets] = binary.shift(11).join.to_i
          bits_to_take.last -= 11 unless bits_to_take.empty?

          packets_to_find << packet[:number_of_sub_packets]
        #when end
      end
    #when end
  end

  packets << packet

  # DEBUG
  puts
  pp packet
  p binary.join
  #break
end

# DEBUG
puts
puts "   bits_to_take: #{bits_to_take   .inspect}"
puts "packets_to_find: #{packets_to_find.inspect}"
pp packets


## ANSWER
answer = nil
puts answer
