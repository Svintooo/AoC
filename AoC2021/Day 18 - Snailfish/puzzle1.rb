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


## HELP CODE
def explode(number)
end

def split(number)
end


## CALCULATE
numbers_list.each do |numbers|
  puts;p(numbers) #DEBUG

  #NOTE: In this code, each variable named `index` is actually an array of integers.

  ## Find all index combinations for each integer
  integer_refs = []
  queue = [ [0], [1] ]

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

  ## Reduce snailfish number
  loop do
    result =
      integer_refs.each_with_index do |index, i|
        underlying_array_index = index[0..-2]
        partner_index = underlying_array_index + [index.last.+(1) % 2]

        if index.length > 4 && numbers.dig(*partner_index).kind_of?(Integer)
          #explode
        elsif (integer = numbers.dig(*index)) > 9
          #split
        end
      end

    break unless result == :continue
  end
end


## ANSWER
answer = nil
puts answer
