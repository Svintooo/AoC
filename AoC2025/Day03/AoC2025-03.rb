#!/usr/bin/env ruby

if !ARGV.empty?
  IO.read(ARGV[0])
elsif !STDIN.tty?
  STDIN.read
else
  IO.read("input.txt")  # Default
end
  .split(/\r?\n|\r/)
  .map{|line| line.chars }
  .map{|bank|
    battery1, i = bank[0..-2].each_with_index.max_by{|jolt,| jolt }
    battery2 = bank[(i+1)..-1].max
    jolt1 = "#{battery1}#{battery2}".to_i
    #
    batteries = []
    12.downto(1).each do |num|
      battery, i = bank[0..-num].each_with_index.max_by{|jolt,| jolt }
      batteries << battery
      bank = bank[(i+1)..-1]
    end
    jolt2 = batteries.join("").to_i
    #
    [jolt1, jolt2]
  }
  .inject([0,0]){|(solution1, solution2), (jolt1, jolt2)| [solution1+jolt1, solution2+jolt2] }
  .tap{|result| puts result.inspect }
