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

basin_sizes = []

low_points.each do |point|
  #print"#";p(point) #DEBUG

  points = []
  visited_points = {}

  points << point
  basin_size  = 0

  while (x,y = points.shift)
    next if heightmap[y][x] == 9
    next if visited_points[ [x,y] ]
    basin_size += 1
    visited_points[ [x,y] ] = true

    points << [x-1,y] if x != 0
    points << [x+1,y] if x < heightmap[y].count-1
    points << [x,y-1] if y != 0
    points << [x,y+1] if y < heightmap.count-1
  end

  basin_sizes << basin_size
end


## ANSWER
answer = basin_sizes.sort.reverse[0..2].reject(&:zero?).inject(:*)
puts answer
