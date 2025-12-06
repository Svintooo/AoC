#!/usr/bin/env ruby
newline = /(?:\r?\n|\r)/.source

if !ARGV.empty?
    IO.read(ARGV[0])
elsif !STDIN.tty?
     STDIN.read
else
    ["input", "input.txt", "input.example.txt"]
        .find{|file| File.readable?(file) }  # Select first match
        .yield_self{|file| IO.read(file) }
end
    .yield_self{|input| input.split(/#{newline}+/) }
    .yield_self{|lines| lines.map(&:strip) }
    .yield_self{|lines| lines.map{|line| line.split(/\s+/) } }
    .yield_self{|rows|
        columns = Array.new(rows[0].length){ [] }
        rows.each_with_index do |row, y|
            row.each_with_index do |str, x|
                columns[x][y] = str
            end
        end
        columns
    }
    .map{|column| [ column[0..-2].map(&:to_i), column[-1].to_sym ] }
    #.tap{|o| puts "[D] #{o.inspect}" }  #DEBUG
    .map{|numbers, operator| numbers.inject(operator) }
    .sum
    .tap{|answer| p(answer) }
