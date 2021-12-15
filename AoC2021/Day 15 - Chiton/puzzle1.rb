#!/usr/bin/env ruby


## INPUT
data = ARGF.read


## CHECK
raise "Input contains non-integer characters" if data.match? /[^0-9\r\n]/


## PARSING
map = data.lines.map(&:strip)
                .map{|line| line.chars.map(&:to_i) }


## HELP CODE
# A crude priority queue
path_queue = {}
def path_queue.<<(path_queue_data)
  xy,history,prio = path_queue_data

  if self[:current_prio].nil?
    self[:current_prio] = prio
  else
    self[:current_prio] = [ prio, self[:current_prio] ].min
  end

  self[prio] ||= []
  self[prio] << [xy,history]
end
def path_queue.pop
  return nil if self[:current_prio].nil?

  prio = self[:current_prio]
  element = self[prio].shift

  if self[prio].empty?
    self.delete(prio)
    self[:current_prio] = self.keys.reject{|k|k=:current_prio}.min
  end

  return element
end


## CALCULATE
path_queue << [[0,0],[],1]  # initialize
p path_queue #DEBUG

final_path = []

while ((x,y),history = path_queue.pop)
  if y == map.length-1 && x == map[y].length-1
    final_path = history.push([x,y])
    break
  end

  #NOTE: prioritize down-right by putting those directions first in queue
  [[x,y+1],[x+1,y],[x,y-1],[x-1,y]].each do |x2,y2|
    next if y2<0 || x2<0 || y2>map.length-1 || x2>map[y2].length-1
    next if history.include? [x2,y2]
    path_queue << [[x2,y2], history.push([x,y]), map[y2][x2]]
  end
end


## ANSWER
answer = final_path.map{|x,y| map[y][x] }.sum - map[0][0]
puts answer
