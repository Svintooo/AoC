#!/usr/bin/env ruby


## INPUT
data = ARGF.read


## PARSING
signals = data.split(/\r\n?|\n/)
              .map{|line|
                line.split('|')
                    .map{|patterns|
                      patterns.split
                              .map(&:strip)
                              .map{|pattern| pattern.chars.sort.join }
                    }
                    #.append(line) #DEBUG
              }
              .map{|entry|
                [
                  :patterns,
                  :output,
                  #:line #DEBUG
                ].zip(entry).to_h
              }
#pp signals  #DEBUG


## CALCULATE
# 2 chars => 1,
# 4 chars => 4,
# 5 chars => [2,3,5],
# 6 chars => [0,6,9],
# 3 chars => 7,
# 7 chars => 8,
output_numbers = []


signals.each do |entry|

  pattern_to_number = {}
  number_to_pattern = {}

  entry[:patterns].each{|pattern|
    case pattern.length
      when 2 then pattern_to_number[pattern] = 1
      when 4 then pattern_to_number[pattern] = 4
      when 3 then pattern_to_number[pattern] = 7
      when 7 then pattern_to_number[pattern] = 8
    end
  }
  number_to_pattern.merge! pattern_to_number.to_a.map{|a,b|[b,a]}.to_h

  entry[:patterns].-(pattern_to_number.keys).each{|pattern|
    (pattern_to_number[pattern] = 3; next) if pattern.length == 5 &&  number_to_pattern[1].chars.all?{|c| pattern.include?(c) }
    (pattern_to_number[pattern] = 6; next) if pattern.length == 6 && !number_to_pattern[7].chars.all?{|c| pattern.include?(c) }
    (pattern_to_number[pattern] = 9; next) if pattern.length == 6 &&  number_to_pattern[4].chars.all?{|c| pattern.include?(c) }
  }
  number_to_pattern.merge! pattern_to_number.to_a.map{|a,b|[b,a]}.to_h

  entry[:patterns].-(pattern_to_number.keys).each{|pattern|
    (pattern_to_number[pattern] = 0; next) if pattern.length == 6 && (number_to_pattern[6].chars - pattern.chars).count == 1
    (pattern_to_number[pattern] = 5; next) if pattern.length == 5 && (number_to_pattern[6].chars - pattern.chars).count == 1
  }

  last_pattern = entry[:patterns].-(pattern_to_number.keys).first
  pattern_to_number[last_pattern] = 2

  #p pattern_to_number #DEBUG

  number = entry[:output].map{|pattern| pattern_to_number[pattern].to_s }.join.to_i
  output_numbers << number

  #puts "#{entry[:line].ljust(92)} = #{number}" #DEBUG
end


## ANSWER
answer = output_numbers.sum
puts answer
