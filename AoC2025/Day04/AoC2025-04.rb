#!/usr/bin/env ruby

if !ARGV.empty?
  IO.read(ARGV[0])
elsif !STDIN.tty?
  STDIN.read
else
  ["input", "input.txt", "input.example.txt"]
    .find{|file| File.readable?(file) }
    .yield_self{|file| IO.read(file) }
end
  .yield_self{|input| [input.chars, input[/^.*?(?:\r?\n|\r|$)/].length] }
  .yield_self{|(grid,width)| grid.each_index.lazy.map{|index| [grid, width, index] } }
  .select{|(grid,w,roll_index)| grid[roll_index] == '@' }
  .inject(0){|acc,(grid,w,roll_index)|
    [-w-1, -w, -w+1, -1, +1, +w-1, +w, +w+1]
      .map{|dir| roll_index + dir }
      .select{|index| index >= 0 && index < grid.count }
      .map{|index| grid[index] }
      .count('@')
      #.tap{|o| puts "#{roll_index} #{o.inspect}" } #DEBUG
      .yield_self{|count| acc + (count < 4 ? 1 : 0) }
  }
  .yield_self{|rolls_count| p rolls_count }
