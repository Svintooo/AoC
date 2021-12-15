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
def path_queue.current_prio_key
  self.keys.min
end
def path_queue.<<(path_queue_data)
  xy,history,prio = path_queue_data

  key = [prio,history.length]

  self[key] ||= []
  self[key] << [xy,history]
end
def path_queue.pop
  key = self.current_prio_key
  return nil if key.nil?

  element = self[key].shift
  self.delete(key) if self[key].empty?

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
    path_queue << [[x2,y2], history+[[x,y]], map[y2][x2]]
  end

  # DEBUG
  #print path_queue.inspect;STDIN.gets("\n") #DEBUG
  #pp path_queue
  #puts"##{path_queue.current_prio}" #DEBUG
  p [x,y]
  #asdf = history.+([[x,y]]).inject({}){|h,(x,y)| h[y] ||= []; h[y] << x; h }
  asdf = history           .inject({}){|h,(x,y)| h[y] ||= []; h[y] << x; h }
  #puts map.clone.map{|l| l.clone }.yield_self{|m| asdf.each{|y,xs| m[y].each_index{|x| m[y][x] = '.' unless xs.include?(x) } }; m }.map(&:join).join("\n")
  puts map.clone.map{|l| l.clone }.yield_self{|m| m[y][x] = '*'; asdf.each{|y,xs| m[y].each_index{|x| m[y][x] = '.' if     xs.include?(x) } }; m }.map(&:join).join("\n")
  #puts map.clone.map{|l| l.clone }.yield_self{|m|}.map(&:join).join("\n")
  STDIN.gets("\n")
end

pp final_path #DEBUG


## ANSWER
answer = final_path.map{|x,y| map[y][x] }.sum - map[0][0]
puts answer
