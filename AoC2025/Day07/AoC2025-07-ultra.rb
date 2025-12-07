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
    width = input.each_line.first.length
    start_pos = input.index('S')

    beam_splits = 0                      # Part 1
    timelines = Array.new(width - 1, 0)  # Part 2
    timelines[start_pos] = 1             # Part 2

    input
        .enum_for(:scan, '^').map { Regexp.last_match.begin(0) }  # Position for each splitter
        .inject({}) {|map, splitter|
            y = splitter / width
            map[y] ||= []
            map[y] << splitter
            map
        }
        .inject([[start_pos, 1]]) {|xs, (y, splitters)|
            xs.inject([]) {|new_xs, (x, count)|
                beam = y * width + x
                if splitters.include?(beam)
                    beam_splits += 1         # Part 1
                    timelines[ x ] -= count  # Part 2
                    timelines[x-1] += count  # Part 2
                    timelines[x+1] += count  # Part 2
                    new_xs << [x-1, count] << [x+1, count]
                else
                    new_xs << [x, count]
                end
            }
            .lazy
            .group_by {|x, count| x }  # [ [x1,2], [x1,3], [x2,3] ] => {x1 => [[x1,2], [x1,3]], x2 => [[x2,3]]}
            .map {|x, group| [ x, group.map{|x, count| count }.sum ] }
        }

    p [beam_splits, timelines.sum]
end
