#!/usr/bin/env ruby
require "json"

## INPUT
data = case when File.exists?(ARGV[0])
            then ARGF.read
            else ARGV[0]
            end


## PARSING
numbers_list = data.lines.map(&:strip)
                   .map{|line| JSON.parse(line) }
#pp numbers_list


## HELP CODE
def explode(number)
end

def split(number)
end


## CHECK


## CALCULATE
numbers_list.each do |numbers|
  integer_indexes = []
  queue = [ [0], [1] ]
  while index = queue.unshift do
    #
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
