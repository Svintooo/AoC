#!/usr/bin/env ruby
filename = ARGV[0]
data     = IO.read(filename)


## PARSING
lanternfish = data.strip.split(',').map(&:to_i)


## CHECK
raise "Error" if lanternfish.any?{|v| v <= 0 }


## CALCULATE
#puts "Initial state: #{lanternfish.join(',')}" #DEBUG

80.times.each do
#18.times.each do |day| #DEBUG
  lanternfish.count.times do |i|
    if lanternfish[i] == 0
      lanternfish[i] = 6
      lanternfish << 8
    else
      lanternfish[i] -= 1
    end
  end

  # DEBUG
  #puts "After #{(day+1).to_s.ljust(2)} day#{day == 0 ? ": " : "s:"} #{lanternfish.join(',')}"
end


## ANSWER
answer = lanternfish.count
puts answer
