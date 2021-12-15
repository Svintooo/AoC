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
  xy,history,history_risks,prio = path_queue_data

  #key = prio
  #key = [prio,history.length]
  #key = [history.length,prio]
  key = history_risks.last.to_i

  self[key] ||= []
  self[key] << [xy,history,history_risks]
end
def path_queue.pop
  key = self.current_prio_key
  return nil if key.nil?

  element = self[key].shift
  self.delete(key) if self[key].empty?

  return element
end


## CALCULATE
path_queue << [[0,0],[],[],1]  # initialize
#p path_queue #DEBUG

visited_optimal_paths = {}
final_path = []

while ((x,y),history,history_risks = path_queue.pop)
  if y == map.length-1 && x == map[y].length-1
    final_path = history.push([x,y])
    break
  end

  #if at the end of map: stop if can't reach goal position
  next if y == 0 && history.last == [x+1,y]
  next if x == 0 && history.last == [x,y+1]
  next if y == map.length-1 && history.last == [x+1,y]
  next if x == map[y].length-1 && history.last == [x,y+1]

  #skip if another path has led to here with a more optimal path
  skip = false
  history.each_index do |i|
    x2,y2 = history[i]
    risk  = history_risks[i]
    (skip = true; break) if visited_optimal_paths.has_key?([x2,y2]) && visited_optimal_paths[[x2,y2]] < risk
    #puts"#[#{x2},#{y2}] risk(#{risk}) optimal()" #DEBUG
  end
  next if skip
  #
  risk = history_risks.last.to_i + map[y][x]
  next if visited_optimal_paths.has_key?([x,y]) && visited_optimal_paths[[x,y]] <= risk
  visited_optimal_paths[[x,y]] = risk

  #NOTE: prioritize down-right by putting those directions first in queue
  [[x,y+1],[x+1,y],[x,y-1],[x-1,y]].each do |x2,y2|
    next if y2<0 || x2<0 || y2>map.length-1 || x2>map[y2].length-1
    next if history.include? [x2,y2]
    path_queue << [[x2,y2], history+[[x,y]], history_risks+[history_risks.last.to_i+map[y][x]], map[y2][x2]]
  end

  # DEBUG
  #p [x,y]
  ##p history_risks
  #asdf = history           .inject({}){|h,(x,y)| h[y] ||= []; h[y] << x; h }
  #puts map.clone.map{|l| l.clone }.yield_self{|m| m[y][x] = '*'; asdf.each{|y,xs| m[y].each_index{|x| m[y][x] = '.' if     xs.include?(x) } }; m }.map(&:join).join("\n")
  ##puts
  #STDIN.gets("\n")
end

#pp final_path #DEBUG
#asdf = history           .inject({}){|h,(x,y)| h[y] ||= []; h[y] << x; h }
#puts map.clone.map{|l| l.clone }.yield_self{|m| m[y][x] = '*'; asdf.each{|y,xs| m[y].each_index{|x| m[y][x] = '.' if     xs.include?(x) } }; m }.map(&:join).join("\n")
#pp visited_optimal_paths

## ANSWER
answer = final_path.map{|x,y| map[y][x] }.sum - map[0][0]
puts answer
