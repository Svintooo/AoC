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
    lines = input.lines(chomp:true)  #  " 12 345 67  \n..."  => [" 12 345 67  ", ...]
    operators = lines.pop.strip.split(/\s+/).map(&:to_sym)  # "+  *  +  " => [:+, :*, :+]

    part1 = lines                                            #    " 12  3 "
        .map(&:strip)                                        # => "12  3"
        .map{|line| line.split(/\s+/) }                      # => ["12", "3"]
        .map{|line| line.map(&:to_i) }                       # => [12, 3]
        .transpose                                           # [[a1,a2],[b1,b2]] => [[a1,b1],[a2,b2]]
        .lazy
        .zip(operators)                                      # [12, 8] => [[12, 8], :+]
        .map{|numbers, operator| numbers.inject(operator) }  #         => 20
        .sum

    part2 = lines                           #    [" 45 ", ...]
        .map(&:grapheme_clusters)           # => [[" ", "4", "5", " "], ...]
        .transpose                          # [[a1,a2],[b1,b2]] => [[a1,b1],[a2,b2]]
        .lazy
        .map(&:join)                        #    [ [" 12 ", "  8  ", "    "],         ...]
        .map(&:strip)                       # => [ ["12", "8", ""], ..., ["9", "23"]     ]
        .chain([""])                        # => [ ["12", "8", ""], ..., ["9", "23", ""] ]
        .slice_after("")                                     # => [ ["12", "8", ""], ... ]
        .map{|column| column[..-2] }                         # => [ ["12", "8"]    , ... ]
        .map{|column| column.map(&:to_i) }                   # => [ [12, 8]        , ... ]
        .zip(operators)                                      # => [ [[12, 8], :+]  , ... ]
        .map{|numbers, operator| numbers.inject(operator) }  # => [ 20             , ... ]
        .sum

    p [part1, part2]
end
