#!/usr/bin/env ruby


## INPUT
data = ARGF.read
start_cave = "start"
end_cave   = "end"


## PARSING
cave_paths = data.lines.map(&:strip)
                 .map{|path| path.split('-') }
                 .inject({}){|cave,(path_start,path_next)|
                   cave[path_start] ||= []
                   cave[path_start] << path_next
                   cave  # Last row is what is put inside the cave variable on next loop
                 }


## HELP CODE
class String
  def upcase?
    self.match? /\A\p{Upper}+\z/
  end
  def downcase?
    self.match? /\A\p{Lower}+\z/
  end
end

def travel(travel_log, small_caves_visited, next_cave)
  [
    travel_log << next_cave,
    next_cave
  ]
end


## CHECK
# Check that all caves are not written with a mix of uppercase and lowercase characters
raise "Input Error: Character Case" unless cave_paths.keys.all?{|cave| cave.upcase? || cave.downcase? }

raise "Input Error: Start cave not found: #{start_cave}" unless cave_paths.has_key?(start_cave)
raise "Input Error: End cave not found: #{end_cave}"     unless cave_paths.has_key?(end_cave)


## CALCULATE
cave_full_paths = []
queued_paths    = []

travel = ->() {
  #
}
cave_paths[start_cave].each{|cave|
                        #Data explanation:  Travel        Small Caves   Next
                        #                   Log           Visited       Cave
                        queued_paths << [ [start_cave], [],           cave ]
                      }

while (travel_log, small_caves_visited, cave = queued_paths.shift)
  #
end


## ANSWER
answer = nil
puts answer
