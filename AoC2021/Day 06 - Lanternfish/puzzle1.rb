#!/usr/bin/env ruby
filename = ARGV[0]
days     = ARGV[1] || 80

data = IO.read(filename)
days = days.to_i


## PARSING
lanternfish = data.strip.split(',').map(&:to_i)


## CHECK
raise "Error" if lanternfish.any?{|v| v <= 0 }


## CALCULATE
#puts "Initial state: #{lanternfish.join(',')}" #DEBUG

days.times.each do
#days.times.each do |day| #DEBUG
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
