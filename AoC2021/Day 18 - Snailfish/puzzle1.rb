#!/usr/bin/env ruby
require "json"

## INPUT
EXPLODE_DEPTH   = 4
SPLIT_MIN_VALUE = 10
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
raise "Invalid input data" unless data.match? /\A[\[\],0-9\s]+\z/


## PARSING
numbers_list = data.lines.map(&:strip)
                   .map{|line| JSON.parse(line) }
#pp numbers_list


## CALCULATE
final_number = []

#NOTE: In this code, each variable named `index` is actually an array of integers.

# Add all snailfish numbers together
numbers_list.each do |snailfish_number|
  #puts;print"+";puts"#{snailfish_number.inspect.gsub(' ','')}" #DEBUG

  ## Add new snailfish number
  final_number = final_number.empty? ? snailfish_number : [final_number,snailfish_number]
  #puts"#{final_number.inspect.gsub(' ','')}" #DEBUG

  ## The snailfish number needs to be put in an extra array for the loops to work
  number = [final_number]

  ## Find all index combinations for each integer
  integer_refs = []
  queue = [ [0] ]  # Initialize queue

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
    ## Explode loop
    result = integer_refs.each_with_index do |index, i|
      next if not index.length > EXPLODE_DEPTH+1  # +1 since we put final_number inside number
      underlying_array = number.dig(*index[0..-2])
      next if not underlying_array.all?{|o| o.kind_of? Integer }

      integer_refs.delete_at(i+1)
      number.dig(*integer_refs[i-1][0..-2])[integer_refs[i-1][-1]] += underlying_array[0] if i != 0
      number.dig(*integer_refs[i+1][0..-2])[integer_refs[i+1][-1]] += underlying_array[1] if i != integer_refs.length-1
      number.dig(*index[0..-3])[index[-2]] = 0
      integer_refs[i] = index[0..-2]
      #print"X:";puts"#{final_number.inspect.gsub(' ','')}" #DEBUG
      break :RESTART_LOOP
    end
    next if result == :RESTART_LOOP

    ## Split loop
    result = integer_refs.each_with_index do |index, i|
      integer = number.dig(*index)
      next if integer < SPLIT_MIN_VALUE

      new_integer_1 = (integer / 2).floor
      new_integer_2 = integer - new_integer_1
      number.dig(*index[0..-2])[index[-1]] = [new_integer_1, new_integer_2]
      integer_refs[i] =        index+[0]
      integer_refs.insert(i+1, index+[1])
      #print"S:";puts"#{final_number.inspect.gsub(' ','')}" #DEBUG
      break :RESTART_LOOP
    end
    next if result == :RESTART_LOOP

    break
  end

  #puts"#{final_number.inspect.gsub(' ','')}" #DEBUG
  #STDIN.gets("\n") #DEBUG
end

#puts"#{final_number.inspect.gsub(' ','')}" #DEBUG

# Calculate the magnitude of the final snail number
magnitudes = [[final_number]]  # needs to be put in two extra arrays for the loop to work
queue = [ [0,0] ]  # Initialize queue
while index = queue.first do
  object = magnitudes.dig(*index)
  break if object.kind_of? Integer

  array = object
  if array.any?{|o| o.kind_of? Array }
    queue.unshift index+[1] if array[1].kind_of? Array
    queue.unshift index+[0] if array[0].kind_of? Array
  else #if array.all?{|o| o.kind_of? Integer }
    queue.shift
    magnitude = array[0]*3 + array[1]*2
    underlying_array = magnitudes.dig(*index[0..-2])
    underlying_array[index[-1]] = magnitude
  end
end


## ANSWER
answer = magnitudes.flatten.first
puts answer
