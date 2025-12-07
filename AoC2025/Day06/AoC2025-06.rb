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
    part1 = input
        .each_line(chomp:true)           #  " 12 345 67  \n..."  => [" 12 345 67  ", ...]
        .lazy
        .map(&:strip)                    # [" 12 345 67  ", ...] => ["12 345 67", ...]
        .map{|line| line.split(/\s+/) }  # ["12 345 67", ...]    => [["12", "345", "67"], ...]
        .yield_self{|rows|
            length = rows.first.length
            columns = Array.new(length){ [] }
            rows.each_with_index do |row, y|      # [["12", "345", "67"],    [[ "12", "9", "*"],
                row.each_with_index do |str, x|   #  ["9",    "8",  "7"], =>  ["345", "8", "+"],
                    columns[x][y] = str           #  ["*",    "+",  "*"]]     [ "67", "7", "*"]]
                end
            end
            columns
        }
        .lazy
        .map{|column| [ column[0..-2], column[-1] ] }                        # ["2", "3", "+"] => [["2", "3"], "+"]
        .map{|numbers, operator| [ numbers.map(&:to_i), operator.to_sym ] }  # [["2", "3"], "+"] => [[2, 3], :+]
        .map{|numbers, operator| numbers.inject(operator) }                  # [[2, 3], :+] => 5
        .sum

    part2 = input
        .each_line(chomp:true)       #  "123\n..."  => ["123", ...]
        .lazy
        .map(&:grapheme_clusters)    # ["123", ...] => [["1", "2", "3"], ...]
        .yield_self{|rows|
            length = rows.first.length
            columns = Array.new(length){ [] }
            rows.each_with_index do |row, y|            # [["1", "2", " "],    [[" ", "6", " "],
                row.each_with_index do |str, x|         #  ["4", "5", "6"], =>  ["2", "5", " "],
                    columns[length - 1 - x][y] = str    #  ["+", " ", " "]]     ["1", "4", "+"]]
                end
            end
            columns
        }
        .lazy
        .map{|column| column.join("").strip }  # [["2", "5", "*", " "], [" ", " ", " "], ...] => ["25*", "", ...]
        .chain([""])                           # [..., "14+"] => [..., "14+", ""]
        .slice_after{|column| column == "" }   # [..., "25*", "", "73", "14+", ""] => [[..., "25*", ""], ["73", "14+", ""]]
        .map{|column| column[0..-2] }          # ["73", "14+", ""] => ["73", "14+"]
        .map{|math_problem|
            last_number, operator = math_problem[-1].match(/^(.*)(.)$/).captures  # "123 +" => ["123 ", "+"]
            numbers = math_problem[0..-2] << last_number                          # ["56", "78", "123 +"] => ["56", "78", "123 "]
            [numbers, operator]
        }
        .map{|numbers, operator| [ numbers.map(&:to_i), operator.to_sym ] }
        .map{|numbers, operator| numbers.inject(operator) }
        #.tap{|o| puts "[D] #{o.inspect}" }  #DEBUG
        .sum

    p [part1, part2]
end
