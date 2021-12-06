#!/usr/bin/env ruby
filename = ARGV[0]
data     = IO.read(filename)


## PARSING
#              0 1 2 3 4 5 6 7 8
lanternfish = [0,0,0,0,0,0,0,0,0]

data.strip.split(',')
    .map(&:to_i)
    .each{|v| lanternfish[v] +=1 }


## CHECK
# N/A


## CALCULATE
#puts "Initial state: #{lanternfish.join(',')}" #DEBUG

256.times.each do |day| #DEBUG
  number_of_fishies = lanternfish.shift
  lanternfish << 0

  if number_of_fishies != 0
    lanternfish[6] += number_of_fishies
    lanternfish[8] += number_of_fishies
  end

  # DEBUG
  #puts "After #{(day+1).to_s.ljust(2)} day#{day == 0 ? ": " : "s:"} #{lanternfish.join(',')}"
end


## ANSWER
answer = lanternfish.sum
puts answer
