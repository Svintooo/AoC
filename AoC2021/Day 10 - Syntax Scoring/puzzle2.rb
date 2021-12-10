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
  corrupted = false
  #p line.join #DEBUG

  line.each do |char|
    case char
      when '(','[','{','<'
        open_chunks << char
        #puts"#{char.inspect}: #{open_chunks.map{|c|c.inspect}.join(",")}" #DEBUG
      when ')',']','}','>'
        #puts"#{char.inspect}: #{open_chunks.map{|c|c.inspect}.join(",")}" #DEBUG
        if open_chunks.empty? || open_chunks.last != chunk_pairs[char]
          corrupted_count += 1
          corrupted = true
          break
        else
          open_chunks.pop
        end
    end
  end
  next if corrupted

  if !open_chunks.enpty?
    incomplete_count += 1

    #
  end
end
p incomplete_count #DEBUG
p corrupted_count #DEBUG
p total_score #DEBUG


## ANSWER
answer = total_score
puts answer
