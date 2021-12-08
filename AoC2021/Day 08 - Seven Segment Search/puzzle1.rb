#!/usr/bin/env ruby


## INPUT
data = ARGF.read


## PARSING
signals = data.split(/\r\n?|\n/)
              .map{|line|
                line.split('|')
                    .map{|numbers|
                      numbers.split.map(&:strip)
                    }
              }
              .map{|entry| [:patterns,:output].zip(entry).to_h }
#pp signals  #DEBUG


## CHECK
#N/A


## CALCULATE
count_1_4_7_8 = 0

signals.each do |entry|
  entry[:output].each{|abcdefg| count_1_4_7_8 += 1 if [2,3,4,7].include?(abcdefg.length) }
end


## ANSWER
answer = count_1_4_7_8
puts answer
