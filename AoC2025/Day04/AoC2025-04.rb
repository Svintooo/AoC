#!/usr/bin/env ruby

input = if !ARGV.empty?
  IO.read(ARGV[0])
elsif !STDIN.tty?
  STDIN.read
else
  ["input", "input.txt", "input.example.txt"]
    .find{|file| File.readable?(file) }
    .yield_self{|file| IO.read(file) }
end

asdf = 0
qwer = -1

while qwer != 0
  qwer = input
    .yield_self{|grid| [grid, grid[/^.*?(?:\r?\n|\r|$)/].length] }
    .yield_self{|(grid,width)| grid.chars.each_index.lazy.map{|index| [grid, width, index] } }
    .select{|(grid,w,roll_index)| grid[roll_index] == '@' }
    .inject([0,[]]){|(acc,indexes),(grid,w,roll_index)|
      [-w-1, -w, -w+1, -1, +1, +w-1, +w, +w+1]
        .map{|dir| roll_index + dir }
        .select{|index| index >= 0 && index < grid.length }
        .map{|index| [index, grid[index]] }
        .count{|(index,char)| char == '@' }
        .yield_self{|count| (acc += 1; indexes << roll_index) if count < 4; [acc, indexes] }
    }
    .tap{|(count, indexes)| indexes.each{|i| input[i] = 'x' } }
    .yield_self{|(count, indexes)| count }
  asdf += qwer
end

p asdf
