#!/usr/bin/env ruby
require "json"

## INPUT
data = case when File.exists?(ARGV[0])
            then ARGF.read
            else ARGV[0]
            end


## CHECK
raise "Invalid input data" unless data.match? /\A[\[\],0-9\s]+\z/


## PARSING
numbers_list = data.lines.map(&:strip)
                   .map{|line| JSON.parse(line) }
#pp numbers_list


## CALCULATE
final_number = []

#NOTE: In this code, each variable named `index` is actually an array of integers.

numbers_list.each do |snailfish_number|
  puts;print"+";puts"#{snailfish_number.inspect.gsub(' ','')}" #DEBUG

  ## Add new snailfish number
  final_number = final_number.empty? ? snailfish_number : [final_number,snailfish_number]
  puts"#{final_number.inspect.gsub(' ','')}" #DEBUG

  ## The snailfish number needs to be put in an extra array for the loops to work
  number = [final_number]

  ## Find all index combinations for each integer
  integer_refs = []
  queue = [ [0] ]

  while index = queue.shift do
    #p index #DEBUG
    case object = number.dig(*index)
      when Array
        queue.unshift index+[1]
        queue.unshift index+[0]
      when Integer
        integer_refs << index
      else
        $stderr.puts "WARN: Unknown data `#{object.inspect}`"
      #end
    end
  end
  #p integer_refs #DEBUG
  #next #DEBUG

  ## Reduce snailfish number
  loop do
    result = integer_refs.each_with_index do |index, i|
      underlying_array_index = index[0..-2]
      partner_index = underlying_array_index + [(index.last + 1) % 2]

      underlying_array = number.dig(*underlying_array_index)
      integer = number.dig(*index)
      partner = number.dig(*partner_index)

      if index.length > 4+1 && partner.kind_of?(Integer)
        ## Explode
        integer_refs.delete_at(i+1)
        number.dig(*integer_refs[i-1][0..-2])[integer_refs[i-1][-1]] += underlying_array[0] if i != 0
        number.dig(*integer_refs[i+1][0..-2])[integer_refs[i+1][-1]] += underlying_array[1] if i != integer_refs.length-1
        number.dig(*underlying_array_index[0..-2])[underlying_array_index[-1]] = 0
        integer_refs[i] = index[0..-2]
        #print"X:";puts"#{final_number.inspect.gsub(' ','')}" #DEBUG
        break :RESTART_LOOP
      end
    end
    next if result == :RESTART_LOOP

    result = integer_refs.each_with_index do |index, i|
      underlying_array_index = index[0..-2]
      partner_index = underlying_array_index + [(index.last + 1) % 2]

      underlying_array = number.dig(*underlying_array_index)
      integer = number.dig(*index)
      partner = number.dig(*partner_index)

      if integer > 9
        ## Split
        new_integer_1 = (integer / 2).floor
        new_integer_2 = integer - new_integer_1
        number.dig(*index[0..-2])[index[-1]] = [new_integer_1, new_integer_2]
        integer_refs[i] = index+[0]
        integer_refs.insert(i+1, index+[1])
        #print"S:";puts"#{final_number.inspect.gsub(' ','')}" #DEBUG
        break :RESTART_LOOP
      end
    end
    next if result == :RESTART_LOOP

    break
  end

  puts"#{final_number.inspect.gsub(' ','')}" #DEBUG
  #STDIN.gets("\n") #DEBUG
end


## ANSWER
answer = nil
puts answer
