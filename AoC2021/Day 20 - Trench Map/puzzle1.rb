#!/usr/bin/env ruby
NEWLINE = /(?:\r\n?|\n)/


## INPUT
data = ARGF.read


## PARSING
algorithm, input_image = data.split(/#{NEWLINE}#{NEWLINE}/)
#puts algorithm;puts #DEBUG
#puts input_image;puts #DEBUG
#exit #DEBUG EXIT

algorithm = algorithm.strip.chars

DEFAULT = algorithm[0]

input_image = input_image.lines.map{|line| line.strip.chars }
input_image.each{|line| puts line.join };puts #DEBUG
#exit #DEBUG EXIT


## CHECK
#exit #DEBUG EXIT


## HELP CODE
#exit #DEBUG EXIT


## CALCULATE
output_image = input_image

2.times do |step|
  #puts"### #{step} ###"

  work_image = output_image.map{|line| [DEFAULT]+line+[DEFAULT] }
  work_image.unshift Array.new(work_image[0].length, DEFAULT)
  work_image.push    Array.new(work_image[0].length, DEFAULT)
  #work_image.each{|line| puts line.join };puts #DEBUG

  output_image = work_image.map{|line| Array.new(line.length, DEFAULT) }
  #output_image.each{|line| puts line.join };puts #DEBUG

  m=work_image.length-1
  work_image.each_with_index do |line, i|
    w=line.length-1
    line.each_index do |j|
      index = [[],[],[]]
      index[0][0] = (i==0||j==0) ? (DEFAULT) : (work_image[i-1][j-1])
      index[0][1] = (i==0      ) ? (DEFAULT) : (work_image[i-1][j  ])
      index[0][2] = (i==0||j==w) ? (DEFAULT) : (work_image[i-1][j+1])
      index[1][0] = (      j==0) ? (DEFAULT) : (work_image[i  ][j-1])
      index[1][1] =                        (work_image[i  ][j  ])
      index[1][2] = (      j==w) ? (DEFAULT) : (work_image[i  ][j+1])
      index[2][0] = (i==m||j==0) ? (DEFAULT) : (work_image[i+1][j-1])
      index[2][1] = (i==m      ) ? (DEFAULT) : (work_image[i+1][j  ])
      index[2][2] = (i==m||j==w) ? (DEFAULT) : (work_image[i+1][j+1])

      index = index.flatten.map{|char| char==DEFAULT ? 0 : 1 }.join.to_i(2)
      output_image[i][j] = algorithm[index]
    end
  end

  output_image.each{|line| puts line.join };puts #DEBUG
end


## ANSWER
answer = output_image.flatten.count("#")
puts answer
