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
#p binary.join #DEBUG

packets = []
bits_to_take = []
packets_to_find = []

loop do
  if !bits_to_take.empty? && bits_to_take[-1][:count] <= 0
    o = bits_to_take.pop
    $stderr.puts "WARN: bits_to_take < 0" if o[:count] < 0
    packet = packets[ o[:packet_index] ]
    packet[:sub_packets] = packets[ (o[:packet_index]+1)..-1 ]
    packet[:sub_packets] = packets.pop(packets.count - o[:packet_index] - 1)

    case
      when '0' #sum
      when '1' #product
      when '2' #minimum
      when '3' #maximum
      when '5' #greater than
      when '6' #less than
      when '7' #equal to
      #end when
    end
  end

  bits_to_take.pop while !bits_to_take.empty?    && bits_to_take   [-1][:count]    <= 0
  packets_to_find  while !packets_to_find.empty? && packets_to_find[-1][:count] <= 0
  break if binary.length < 11

  packet = {}
  packet[:version] = binary.shift(3).join.to_i(2)
  packet[:type_id] = binary.shift(3).join.to_i(2)
  bits_to_take[-1][:count] -= 6 unless bits_to_take.empty?
  #pp packet #DEBUG

  case packet[:type_id]
    when 4
      packet[:value] = []

      loop do
        bits = binary.shift(5)
        bits_to_take[-1][:count] -= 5 unless bits_to_take.empty?

        packet[:value] << bits[1..-1].join

        break if bits[0] == '0'
      end

      packet[:value] = packet[:value].join.to_i(2)
    else
      packet[:length_type_id] = binary.shift
      bits_to_take[-1][:count] -= 1 unless bits_to_take.empty?

      case packet[:length_type_id]
        when '0'
          packet[:sub_packets_lenght] = binary.shift(15).join.to_i(2)
          bits_to_take[-1][:count] -= 15 unless bits_to_take.empty?

          bits_to_take << {packet_index: packets.count, count: packet[:sub_packets_lenght]}
        when '1'
          packet[:number_of_sub_packets] = binary.shift(11).join.to_i(2)
          bits_to_take[-1][:count] -= 11 unless bits_to_take.empty?

          packets_to_find << {packet_index: packets.count, count: packet[:number_of_sub_packets]}
        #when end
      end
    #when end
  end

  packets_to_find[-1][:count] -= 11 unless packets_to_find.empty?
  packets << packet

  # DEBUG
  #puts
  #pp packet
  #p binary.join
  #break
end

# DEBUG
#puts
#puts "   bits_to_take: #{bits_to_take   .inspect}"
#puts "packets_to_find: #{packets_to_find.inspect}"
#pp packets


## ANSWER
answer = nil
puts answer
