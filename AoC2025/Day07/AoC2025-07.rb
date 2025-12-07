#!/usr/bin/env ruby

if !ARGV.empty?
    IO.read(ARGV[0])
elsif !STDIN.tty?
     STDIN.read
else
    ["input", "input.txt", "input.example.txt"]
        .find{|file| File.readable?(file) }  # Select first match
        .yield_self{|file| IO.read(file) }
end
.yield_self do |input|
    splits = 0
    width = input.each_line.first.length

    visited = Set.new()
    queue = [ input.index('S') + width ]
    while beam = queue.pop
        next if beam < 0 || beam >= input.length
        while input[beam] == '.' && !visited.include?(beam)
            visited << beam
            beam += width
        end
        if input[beam] == '^'
            splits += 1
            [beam-1, beam+1].each{|new_beam| queue << new_beam unless visited.include?(new_beam) }
        end
    end

    p splits
end
