#!/usr/bin/env ruby


## INPUT
if File.exists? ARGV[0]
  data = ARGF.read
else
  data = ARGV[0]
end


## PARSING
hexadecimal = data.strip


## HELP CODE


## CHECK
raise "Data contains non-hexadecimal characters" unless hexadecimal.match?  /\A[0-9A-Z]+\z/i


## CALCULATE
#binary = hexadecimal.to_i(16).to_s(2).chars#.map(&:to_i)
binary = hexadecimal.chars.map{|hex| hex.to_i(16).to_s(2).rjust(4,'0') }.join.chars#.map(&:to_i)
#p binary.join #DEBUG

packets = []
bits_to_take = []#
packets_to_find = []#
decrementers = []

loop do
  while !decrementers.empty? && decrementers[-1][:count] <= 0 do
    decr = decrementers.pop

    $stderr.puts "WARN: decrementer count < 0" if decr[:count] < 0
    #if decr[:count] < 0 #DEBUG
    #  table = [:sum,:pro,:min,:max,:val,:grt,:lst,:eq]
    #  #inc = 0
    #  queue = [ [0,packets[0]] ]
    #  while (inc,pkt = queue.shift)
    #    print "".ljust(inc*2)
    #    pkt[:type_id]
    #    pkt[:length_type_id]
    #    pkt[:sub_packets_lenght]
    #    pkt[:number_of_sub_packets]
    #    puts "- #{table[pkt[:type_id]]}: #{pkt[:value].inspect}, #{(pkt[:length_type_id]==0)?("b"):("")}#{(pkt[:sub_packets_lenght])?(pkt[:sub_packets_lenght]):(pkt[:number_of_sub_packets])}"
    #    pkt[:sub_packets].reverse_each{|o| queue.unshift [inc+1,o] } if pkt[:sub_packets]
    #  end
    #  exit
    #end #DEBUG

    packet = packets[ decr[:packet_index] ]
    packets.pop(packets.count - decr[:packet_index] - 1)

    packet[:value] = packet[:sub_packets].map{|pkt| pkt[:value] }
    case packet[:type_id]
      when 0 #sum
        packet[:value] = packet[:value].sum
      when 1 #product
        packet[:value] = packet[:value].inject(&:*)
      when 2 #minimum
        packet[:value] = packet[:value].min
      when 3 #maximum
        packet[:value] = packet[:value].max
      when 5 #greater than
        packet[:value] = (packet[:value].first > packet[:value].last) ? 1 : 0
      when 6 #less than
        packet[:value] = (packet[:value].first < packet[:value].last) ? 1 : 0
      when 7 #equal to
        packet[:value] = (packet[:value].first == packet[:value].last) ? 1 : 0
      #end when
    end
  end

  break if binary.length < 11

  packet = {}
  packet[:version] = binary.shift(3).join.to_i(2)
  packet[:type_id] = binary.shift(3).join.to_i(2)
  #pp packet #DEBUG

  decrementers.select{|d| d[:type] == "bits" }.each{|d| d[:count] -= 6 }
  decrementers.last.yield_self{|d| d[:count] -= 1 if d[:type] == "pkts" } if !decrementers.empty?
  if !decrementers.empty?
    pkt = packets[ decrementers[-1][:packet_index] ]
    pkt[:sub_packets] ||= []
    pkt[:sub_packets] << packet
  end

  case packet[:type_id]
    when 4
      packet[:value] = []

      loop do
        bits = binary.shift(5)
        decrementers.select{|d| d[:type] == "bits" }.each{|d| d[:count] -= 5 }

        packet[:value] << bits[1..-1].join

        break if bits[0] == '0'
      end

      packet[:value] = packet[:value].join.to_i(2)
    else
      packet[:length_type_id] = binary.shift.to_i(2)
      decrementers.select{|d| d[:type] == "bits" }.each{|d| d[:count] -= 1 }

      case packet[:length_type_id]
        when 0
          packet[:sub_packets_lenght] = binary.shift(15).join.to_i(2)
          decrementers.select{|d| d[:type] == "bits" }.each{|d| d[:count] -= 15 }

          bits_to_take << {packet_index: packets.count, count: packet[:sub_packets_lenght]}
          decrementers << {packet_index: packets.count, count: packet[:sub_packets_lenght], type: "bits"}
        when 1
          packet[:number_of_sub_packets] = binary.shift(11).join.to_i(2)
          decrementers.select{|d| d[:type] == "bits" }.each{|d| d[:count] -= 11 }

          decrementers << {packet_index: packets.count, count: packet[:number_of_sub_packets], type: "pkts"}
        #when end
      end
    #when end
  end

  packets << packet

  # DEBUG
  #puts
  #pp decrementers
  #p binary.count
  ##p binary.join
  #p packet
  #
  #puts
  #STDIN.gets("\n")  # Step each loop by pressing enter
end

# DEBUG
#puts
#pp decrementers
#p binary.count
#pp packets
#puts


## ANSWER
answer = packets[0][:value]
puts answer
