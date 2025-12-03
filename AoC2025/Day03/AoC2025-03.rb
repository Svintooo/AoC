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
    [
      02.downto(1).inject(["",0]){|(str, left), right| bank[left..(-right)].each_with_index.max_by{|(jolt,i)| jolt }.yield_self{|jolt,i| [str+jolt, left+i+1] } }[0].to_i,
      12.downto(1).inject(["",0]){|(str, left), right| bank[left..(-right)].each_with_index.max_by{|(jolt,i)| jolt }.yield_self{|jolt,i| [str+jolt, left+i+1] } }[0].to_i
    ]
  }
  .inject([0,0]){|(solution1, solution2), (jolt1, jolt2)| [solution1+jolt1, solution2+jolt2] }
  .tap{|result| puts result.inspect }
