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

chunk_pairs = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>',
}

incomplete_count = 0
corrupted_count  = 0
total_score      = 0

open_chunks = []

navigation_subsystem.each do |line|
  line.each do |char|
    case char
      when '(','[','{','<'
        open_chunks << char
      when ')',']','}','>'
        if open_chunks.empty?
          incomplete_count += 1
        elsif open_chunks.last != chunk_pairs[char]
          corrupted_count += 1
          total_score += score_points[char]
        else
          open_chunks.pop
        end
    end
  end
end
p incomplete_count #DEBUG
p corrupted_count #DEBUG
p total_score #DEBUG


## ANSWER
answer = total_score
puts answer
