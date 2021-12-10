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
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4,
}

chunk_pairs = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<',
}

incomplete_count = 0
corrupted_count  = 0
total_score      = 0

repaired_navigation_subsystem = []

navigation_subsystem.each do |line|
  open_chunks = []
  score = 0
  #p line.join #DEBUG

  line.each do |char|
    case char
      when '(','[','{','<'
        open_chunks << char
        #puts"#{char.inspect}: #{open_chunks.map{|c|c.inspect}.join(",")}" #DEBUG
      when ')',']','}','>'
        #puts"#{char.inspect}: #{open_chunks.map{|c|c.inspect}.join(",")}" #DEBUG
        if open_chunks.empty? || open_chunks.last != chunk_pairs[char]
          break
        else
          open_chunks.pop
        end
    end
  end

  #p open_chunks #DEBUG
  #puts"#{open_chunks.map{|c|c.inspect}.join(",")}" #DEBUG
  if score != 0
    #puts " C" #DEBUG
    corrupted_count += 1
    total_score += score
  elsif !open_chunks.empty?
    #puts " I" #DEBUG
    incomplete_count += 1
  end

  #break #DEBUG
end
#p incomplete_count #DEBUG
#p corrupted_count #DEBUG
#p total_score #DEBUG


## ANSWER
answer = total_score
puts answer
