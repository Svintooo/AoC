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
    start_pos = input.index('S')

    visited = Set.new()
    queue = [ start_pos + width ]
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


    timelines = Hash.new(0)  # NOTE: Default value for new keys will be zero

    traverse_method = :pop  # :pop, :shift
    queue = [ [start_pos + width, [start_pos]] ]
    while !queue.empty?
        beam_start, history = queue.send(traverse_method)
        beam = beam_start
        next if beam < 0 || beam >= input.length
        loop do
            case input[beam]
            when '^'
                if timelines.has_key?(beam)
                    history.each{|pos| timelines[pos] += timelines[beam] }
                else
                    queue << [beam-1, history + [beam]]
                    queue << [beam+1, history + [beam]]
                end
                break
            when nil  # Out of bounds
                history.each{|pos| timelines[pos] += 1 }
                break
            else
                beam += width
            end
        end
    end

    p [ splits, timelines[start_pos] ]
end
