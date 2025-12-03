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
    "#{battery1}#{battery2}".to_i
  }
  .sum
  .tap{|result| puts result.inspect }
