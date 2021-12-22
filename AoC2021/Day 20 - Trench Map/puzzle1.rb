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
#algorithm[0]='#';algorithm[-1]='.';#DEBUG DELETEME
#puts algorithm.join;puts #DEBUG
#exit #DEBUG EXIT


input_image = input_image.lines.map{|line| line.strip.chars }
#input_image.each{|line| puts line.join };puts #DEBUG
#exit #DEBUG EXIT


## CHECK
raise "Algorithm is of wrong length" unless algorithm.length == 512
#exit #DEBUG EXIT


## HELP CODE
#exit #DEBUG EXIT


## CALCULATE
translation = {}
translation.default_proc = ->(h,k){ raise "#{k.inspect} not in #{h.keys.inspect}" }
translation['.'] = 0
translation['#'] = 1

inf_char = '.'

inf_flip = {}
inf_flip[0] = algorithm[ 0]
inf_flip[1] = algorithm[-1]

output_image = input_image

2.times do |step|
  #puts"### #{step} ###" #DEBUG

  work_image = output_image.map{|line| [inf_char]+line+[inf_char] }
  work_image.unshift Array.new(work_image[0].length, inf_char)
  work_image.push    Array.new(work_image[0].length, inf_char)
  #work_image.each{|line| puts line.join };puts #DEBUG

  output_image = work_image.map{|line| Array.new(line.length, '_') }
  #output_image.each{|line| puts line.join };puts #DEBUG

  m=work_image.length-1
  work_image.each_with_index do |line, i|
    w=line.length-1
    line.each_index do |j|
      index = [[],[],[]]
      index[0][0] = (i==0||j==0) ? (inf_char) : (work_image[i-1][j-1])
      index[0][1] = (i==0      ) ? (inf_char) : (work_image[i-1][j  ])
      index[0][2] = (i==0||j==w) ? (inf_char) : (work_image[i-1][j+1])
      index[1][0] = (      j==0) ? (inf_char) : (work_image[i  ][j-1])
      index[1][1] =                                (work_image[i  ][j  ])
      index[1][2] = (      j==w) ? (inf_char) : (work_image[i  ][j+1])
      index[2][0] = (i==m||j==0) ? (inf_char) : (work_image[i+1][j-1])
      index[2][1] = (i==m      ) ? (inf_char) : (work_image[i+1][j  ])
      index[2][2] = (i==m||j==w) ? (inf_char) : (work_image[i+1][j+1])

      index = index.flatten.map{|char| translation[char] }.join.to_i(2)
      output_image[i][j] = algorithm[index]
      #output_image.each{|line| puts line.join };$stdin.gets("\n") #DEBUG
    end
  end

  inf_char = inf_flip[ translation[inf_char] ]

  #output_image.each{|line| puts line.join };puts #DEBUG
end


## ANSWER
answer = output_image.flatten.count("#")
puts answer
