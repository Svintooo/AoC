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
  .yield_self{|fresh, avail| [fresh.map{|str| str.split("-",2).map(&:to_i).yield_self{|pair| Range.new(*pair)} }, avail] }
  .yield_self{|fresh, avail| [fresh, avail.map{|str| str.to_i }] }
  .yield_self{|fresh, avail|
    part1 = avail.select{|ingr| fresh.any?{|range| range.cover?(ingr)} }.count

    go_on = true
    while go_on
      go_on = false
      fresh = fresh.inject([]) do |arr, r1|
        r2, index = arr.each_with_index.find{|r,i| r.end >= r1.begin && r1.end >= r.begin }
        if index
          go_on = true
          arr[index] = [r1.begin, r2.begin].min .. [r1.end, r2.end].max
        else
          arr << r1
        end
        arr
      end
    end
    part2 = fresh.map{|range| range.count }.sum

    [part1, part2]
  }
  .tap{|answers| p answers }
