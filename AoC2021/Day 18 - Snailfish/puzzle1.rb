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

  ## Find all index combinations for each integer
  integer_indexes = []
  queue = [ [0], [1] ]

  while indexes = queue.shift do
    #p indexes #DEBUG
    case o = numbers.dig(*indexes)
      when Array
        queue.unshift indexes+[1]
        queue.unshift indexes+[0]
      when Integer
        integer_indexes << indexes
      else
        $stderr.puts "WARN: Unknown data `#{o.inspect}`"
      #end
    end
  end
  #p integer_indexes #DEBUG

  ## Reduce snailfish number
  loop do
    result =
      integer_indexes.each_with_index do |indexes, i|
        #
      end

    break unless result == :continue
  end
end


## ANSWER
answer = nil
puts answer
