#!/usr/bin/env ruby


## INPUT
data = ARGF.read


## PARSING
navigation_subsystem = data.split(/\r\n?|\n/)
                           .map{|line| line.chars }



## CHECK
unknown_chars =
  navigation_subsystem.all?{|line|
                        line.all?{|char|
                          ['(',')','[',']','{','}','<','>'].include?(char)
                        }
                      }
raise "Input data error" unless unknown_chars


## CALCULATE
score_points = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137,
}

total_score = 0

open_chunks = []

navigation_subsystem.each do |line|
  line.each do |char|

  end
end


## ANSWER
answer = total_score
puts answer
