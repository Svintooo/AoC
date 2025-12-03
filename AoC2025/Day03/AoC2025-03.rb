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
    battery1, i = bank[0..-12].each_with_index.max_by{|jolt,| jolt }
    bank = bank[(i+1)..-1]
    battery2, i = bank[0..-11].each_with_index.max_by{|jolt,| jolt }
    bank = bank[(i+1)..-1]
    battery3, i = bank[0..-10].each_with_index.max_by{|jolt,| jolt }
    bank = bank[(i+1)..-1]
    battery4, i = bank[0..-9].each_with_index.max_by{|jolt,| jolt }
    bank = bank[(i+1)..-1]
    battery5, i = bank[0..-8].each_with_index.max_by{|jolt,| jolt }
    bank = bank[(i+1)..-1]
    battery6, i = bank[0..-7].each_with_index.max_by{|jolt,| jolt }
    bank = bank[(i+1)..-1]
    battery7, i = bank[0..-6].each_with_index.max_by{|jolt,| jolt }
    bank = bank[(i+1)..-1]
    battery8, i = bank[0..-5].each_with_index.max_by{|jolt,| jolt }
    bank = bank[(i+1)..-1]
    battery9, i = bank[0..-4].each_with_index.max_by{|jolt,| jolt }
    bank = bank[(i+1)..-1]
    battery10, i = bank[0..-3].each_with_index.max_by{|jolt,| jolt }
    bank = bank[(i+1)..-1]
    battery11, i = bank[0..-2].each_with_index.max_by{|jolt,| jolt }
    bank = bank[(i+1)..-1]
    battery12, i = bank[0..-1].each_with_index.max_by{|jolt,| jolt }
    bank = bank[(i+1)..-1]
    jolt2 = [battery1,battery2,battery3,battery4,battery5,battery6,battery7,battery8,battery9,battery10,battery11,battery12].join("").to_i
    #
    [jolt1, jolt2]
  }
  .inject([0,0]){|(solution1, solution2), (jolt1, jolt2)| [solution1+jolt1, solution2+jolt2] }
  .tap{|result| puts result.inspect }
