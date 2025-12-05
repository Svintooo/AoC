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
    .yield_self{|input| input.strip.split(/#{newline}{2,}/, 2) }
    #.tap{|o| puts "[D] #{o.inspect}" }  # DEBUG
    .tap{|fresh, avail| raise "Invalid fresh: #{fresh}" unless fresh =~ /^(\d+-\d+)(#{newline}\d+-\d+)+$/ }
    .tap{|fresh, avail| raise "Invalid avail: #{avail}" unless avail =~ /^(\d+)(#{newline}\d+)+$/ }
    .yield_self{|array| array.map{|str| str.split(/#{newline}/) } }
    .yield_self{|fresh, avail|
        [
            fresh.map{|str| str.split("-",2).map(&:to_i).yield_self{|pair| Range.new(*pair)} },
            avail.map{|str| str.to_i }
        ]
    }
    .yield_self{|fresh, avail|
        part1 = avail.select{|ingr| fresh.any?{|range| range.cover?(ingr)} }.count
        part2 =
            fresh.inject([]){|arr, r1|
                loop do
                    loop_again = false
                    arr.each{|r2|
                        if r2.end >= r1.begin && r1.end >= r2.begin && !(r1.begin <= r2.begin && r1.end >= r2.end)
                            loop_again = true
                            r1 = [r1.begin, r2.begin].min .. [r1.end, r2.end].max
                        end
                    }
                    break unless loop_again
                end
                arr.reject{|r2| r2.end >= r1.begin && r1.end >= r2.begin }
                .push(r1)
            }
            .map{|range| range.count }
            .sum
        [part1, part2]
    }
    .tap{|answers| p answers }
