#!/usr/bin/env ruby
IO.read("input")
  .gsub(/\r?\n|\r/,"")  # Handle all possible kinds of newlines
  .tap{|input| raise "Invalid input" unless input =~ /^(\d+-\d+)(,\d+-\d+)*$/ }
  .split(',')  # "abc,def" => ["abc", "def"]
  .map{|range_str| range_str.split("-") }  # "123-456" => ["123", "456"]
  .each{|range_arr| raise "Invalid input range: #{range_arr.inspect}" unless range_arr.first.to_i < range_arr.last.to_i }
  .map{|range_arr| Range.new( *range_arr ) }  # ["123", "456"] => "123".."456"
  .inject([[],[]]){|invalid_ids, id_range|
    id_range.each{|id|
      invalid_ids[0].push(id.to_i) if id =~ /^(.+)\1$/
      invalid_ids[1].push(id.to_i) if id =~ /^(.+)\1+$/
    }
    invalid_ids
  }
  .map(&:sum)
  .tap{|result| puts result.inspect }
