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

  loop do
    result =
      loop do
        #
      end

    break unless result == :continue
  end
end


## ANSWER
answer = nil
puts answer
