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
final_numbers = []

numbers_list.each do |snailfish_number|
  puts;p(snailfish_number) #DEBUG

  #NOTE: In this code, each variable named `index` is actually an array of integers.

  # The numbers needs to be put in an extra array for the code to work
  numbers = [snailfish_number]

  ## Find all index combinations for each integer
  integer_refs = []
  queue = [ [0] ]

  while index = queue.shift do
    #p index #DEBUG
    case object = numbers.dig(*index)
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
      partner_index = underlying_array_index + [index.last.+(1) % 2]

      underlying_array = numbers.dig(*underlying_array_index)
      integer = numbers.dig(*index)
      partner = numbers.dig(*partner_index)

      if index.length > 4+1 && partner.kind_of?(Integer)
        ## Explode
        integer_refs.delete_at(i+1)
        #p([underlying_array_index,underlying_array])#DEBUG
        numbers.dig(*integer_refs[i-1][0..-2])[integer_refs[i-1][-1]] += underlying_array[0] if i != 0
        numbers.dig(*integer_refs[i+1][0..-2])[integer_refs[i+1][-1]] += underlying_array[1] if i != integer_refs.length-1
        numbers.dig(*underlying_array_index[0..-2])[underlying_array_index[-1]] = 0
        integer_refs[i] = index[0..-2]
        print"X:";p(snailfish_number) #DEBUG
        break :CONTINUE
      elsif integer > 9
        ## Split
        new_integer_1 = (integer / 2).floor
        new_integer_2 = integer - new_integer_1
        numbers.dig(*index[0..-2])[index[-1]] = [new_integer_1, new_integer_2]
        integer_refs[i] = index+[0]
        integer_refs.insert(i+1, index+[1])
        print"S:";p(snailfish_number) #DEBUG
        break :CONTINUE
      end
    end

    break unless result == :CONTINUE
  end

  p(snailfish_number) #DEBUG
end


## ANSWER
answer = nil
puts answer
