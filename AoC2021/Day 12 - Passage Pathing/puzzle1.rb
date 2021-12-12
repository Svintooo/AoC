#!/usr/bin/env ruby


## INPUT
data = ARGF.read


## PARSING
cave_paths = data.lines.map(&:strip)
                 .map{|path| path.split('-') }
                 .inject({}){|cave,(path_start,path_next)|
                   cave[path_start] ||= []
                   cave[path_start] << path_next
                   cave  # Last row is what is put inside the cave variable on next loop
                 }


## CALCULATE
cave_full_paths = []
queued_paths    = []

initial_cave = "start"
cave_paths[initial_cave].each{|cave|
                          #Data explanation:  Travel        Small Caves   Next
                          #                   Log           Visited       Cave
                          queued_paths << [ [initial_cave], [],           cave ]
                        }


## ANSWER
answer = nil
puts answer
