#!/usr/bin/env ruby


## INPUT
data = ARGF.read


## PARSING
heightmap = data.split(/\r\n?|\n/)
                .map{|line| line.chars.map{|c| c.to_i } }
pp heightmap #DEBUG


## CALCULATE
low_points = []
heightmap.each_with_index do |horizontal,y|
  horizontal.each_with_index do |height, x|
    is_lowpoint = true
    is_lowpoint &= y == 0                    || height < heightmap[y-1][x]
    is_lowpoint &= y == heightmap.count-1    || height < heightmap[y+1][x]
    is_lowpoint &= x == 0                    || height < heightmap[y][x-1]
    is_lowpoint &= x == heightmap[y].count-1 || height < heightmap[y][x+1]
    low_points << [x,y] if is_lowpoint
  end
end
#p low_points #DEBUG

basin_sizes = []

low_points.each do |x,y|
  print"#";p([x,y]) #DEBUG

  f = ->(y2) {
    tmp = 0
    p([x,y2]);(heightmap[y2][x] == 9) ? (throw :STOP) : (tmp += 1)
    x.-(1).downto(0)                  .each{|x2| p([x2,y2]);break if heightmap[y2][x2] == 9; tmp += 1 }
    x.+(1).upto(heightmap[y2].count-1).each{|x2| p([x2,y2]);break if heightmap[y2][x2] == 9; tmp += 1 }
    return tmp
  }

  size  = 0
  #size += 1
  catch :STOP do ( size += f.call(y) ) end
  catch :STOP do ( size += y.-(1).downto(0)              .map{|y2| f.call(y2) }.sum ) end
  catch :STOP do ( size += y.+(1).upto(heightmap.count-1).map{|y2| f.call(y2) }.sum ) end

  basin_sizes << size
end


## ANSWER
answer = basin_sizes.sort.reverse[0..2].reject(&:zero?).inject(:*)
puts answer
