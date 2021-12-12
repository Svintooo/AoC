#!/usr/bin/env ruby


## INPUT
data = ARGF.read
start_cave = "start"
end_cave   = "end"


## PARSING
cave_paths = data.lines.map(&:strip)
                 .map{|path| path.split('-') }
                 .inject({}){|caves,(cave_start,cave_end)|
                   [[cave_start,cave_end],[cave_end,cave_start]].each do |cave_a,cave_b|
                     caves[cave_a] ||= []
                     caves[cave_a] << cave_b
                   end
                   caves  # Last row is what is put inside the cave variable on next loop
                 }
pp cave_paths #DEBUG


## HELP CODE
class String
  def upcase?
    # Only uppercase characters
    self.match? /\A\p{Upper}+\z/
  end
  def downcase?
    # Only lowercase characters
    self.match? /\A\p{Lower}+\z/
  end
end


## CHECK
# Check that all caves are not written with a mix of uppercase and lowercase characters
raise "Input Error: Character Case" unless cave_paths.keys.all?{|cave| cave.upcase? || cave.downcase? }

raise "Input Error: Start cave not found: #{start_cave}" unless cave_paths.has_key?(start_cave)
raise "Input Error: End cave not found: #{end_cave}"     unless cave_paths.values.any?{|caves| caves.include?(end_cave) }


## CALCULATE
cave_full_paths = []
queued_paths    = []

# Initialize queue
#Explanation:     Travel   Small Caves   Next
#                 Log      Visited       Cave
queued_paths << [ [],      [],           start_cave ]

# Find all paths
while (travel_log, small_caves_visited, cave = queued_paths.shift)
  # End cave reached
  if cave == end_cave
    cave_full_paths << cave_full_paths + [cave]
    next
  end

  # Explore new caves
  travel_log = travel_log.clone
  travel_log << cave

  if cave.downcase?
    small_caves_visited = small_caves_visited.clone
    small_caves_visited << cave
  end

  p cave #DEBUG
  cave_paths[cave].each{|next_cave|
    next if small_caves_visited.include?(next_cave)
    queued_paths << [travel_log, small_caves_visited, next_cave]
  }
end


## ANSWER
answer = cave_full_paths.count
puts answer
