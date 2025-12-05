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
  .tap{|fresh, avail| raise "Invalid fresh: #{fresh}" unless fresh =~ /^(\d+-\d+)(#{newline}\d+-\d+)+$/ }
  .tap{|fresh, avail| raise "Invalid avail: #{avail}" unless avail =~ /^(\d+)(#{newline}\d+)+$/ }
  .yield_self{|array| array.map{|str| str.split(/#{newline}/) } }
  .yield_self{|fresh, avail| [fresh.map{|str| str.split("-",2).map(&:to_i).yield_self{|pair| Range.new(*pair)} }, avail] }
  .yield_self{|fresh, avail| [fresh, avail.map{|str| str.to_i }] }
  .yield_self{|fresh, avail| avail.select{|ingr| fresh.any?{|range| range.cover?(ingr)} } }
  #.tap{|o| puts "[D] #{o.inspect}" }  # DEBUG
  .tap{|available_fresh| p available_fresh.count }
