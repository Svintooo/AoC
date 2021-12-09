#!/usr/bin/env ruby


## INPUT
data = ARGF.read


## PARSING
heightmap = data.split(/\r\n?|\n/)
                .map{|line| line.chars.map{|c| c.to_i } }
#pp heightmap #DEBUG


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

low_point_heights = low_points.map{|x,y| heightmap[y][x] }
#p low_point_heights #DEBUG

risk_levels = low_point_heights.map{|h| h+1 }


## ANSWER
answer = risk_levels.sum
puts answer
