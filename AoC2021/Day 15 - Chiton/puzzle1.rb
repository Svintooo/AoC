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
  puts "##{prio.inspect}"
  element = self[prio].shift

  if self[prio].empty?
    self.delete(prio)
    self[:current_prio] = self.keys.reject{|k|k=:current_prio}.min
  end

  return element
end


## CALCULATE
path_queue << [[0,0],[],1]  # initialize
p path_queue

while ((x,y),history = path_queue.pop)
  p x
  p y
  p history
end


## ANSWER
answer = nil
puts answer
