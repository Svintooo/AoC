#!/usr/bin/env ruby
NEWLINE = /(?:\r\n?|\n)/


## INPUT
data = ARGF.read


## CHECK


## PARSING
scanners = data.split(/#{NEWLINE}#{NEWLINE}/)
               .map{|scanner|
                 scanner.gsub(/\A--- scanner . ---/,'')
                        .strip
                        .split(NEWLINE)
                        .map{|beacon|
                          beacon.split(',')
                                .map(&:to_i)
                        }
               }
#pp scanners #DEBUG


## HELP CODE
def copy(array)
  array = array.clone

  array.each_with_index do |ary, i|
    array[i] = ary.clone
  end
end
#a1 = scanners[0][0..4] #DEBUG
#a2 = copy(a1) #DEBUG
#a2[0][2] = "asdf" #DEBUG
#a2[1] = "qwer" #DEBUG
#pp(a1,a2) #DEBUG


## CALCULATE


## ANSWER
answer = nil
puts answer
