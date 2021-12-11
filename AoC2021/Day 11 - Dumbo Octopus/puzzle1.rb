#!/usr/bin/env ruby
require 'set'


## INPUT
data = ARGF.read


## PARSING
octo_grid = data.lines.map(&:strip)
                .map{|o| o.chars.map(&:to_i) }


## HELP CODE
unless Set.method_defined? :shift
  class Set
    def shift
      tmp = self.first
      self.delete(tmp)
      return tmp
    end
  end
end


## CALCULATE
flash_counts = []
#pp octo_grid;puts #DEBUG

100.times do |i|
  #puts "### #{i}" #DEBUG

  will_flash = Set.new  # Cannot contain duplicates
  flashed    = []

  octo_grid.each_with_index do |line, y|
    line.each_index do |x|
      octo_grid[y][x] += 1
      will_flash << [x,y] if octo_grid[y][x] >= 10
    end
  end
  #puts"# Inc";pp octo_grid;STDIN.gets("\n") #DEBUG

  #puts"# Flash" #DEBUG
  while (x,y = will_flash.shift)
    flashed << [x,y]
    octo_grid[y][x] = 0
    [ [x,y-1], [x,y+1], [x-1,y], [x+1,y], [x-1,y-1], [x-1,y+1], [x+1,y-1], [x+1,y+1] ].each do |x2,y2|
      next if x2<0 || y2<0 || x2>octo_grid[y].count-1 || y2>octo_grid.count-1
      next if flashed.include?([x2,y2])
      octo_grid[y2][x2] += 1
      will_flash << [x2,y2] if octo_grid[y2][x2] >= 10
    end
    #pp octo_grid;STDIN.gets("\n") #DEBUG
  end

  flash_counts << flashed.count

  #puts "# Loop Final" #DEBUG
  #pp octo_grid #DEBUG
  #puts "###" #DEBUG
  #puts #DEBUG
end


## ANSWER
answer = flash_counts.sum
puts answer
