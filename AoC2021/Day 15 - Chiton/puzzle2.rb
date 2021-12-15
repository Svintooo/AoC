#!/usr/bin/env ruby
#NOTE: The code needs to run for 10-20 minutes before solving the input for puzzle2.

## INPUT
data = ARGF.read


## CHECK
raise "Input contains non-integer characters" if data.match? /[^0-9\r\n]/


## PARSING
map = data.lines.map(&:strip)
                .map{|line| line.chars.map(&:to_i) }

# Pentuple the size of the map
orig_y_len = map.length
orig_x_len = map[0].length
#puts map.map(&:join).join("\n")
#
(orig_y_len).upto(orig_y_len.*(5).-(1)).each do |y|
  map[y] = map[y-orig_y_len].clone.map{|risk| n=(risk+1)%10; n==0?1:n }
end
#puts map.map(&:join).join("\n")
#
(orig_x_len).upto(orig_x_len.*(5).-(1)).each do |x|
  map.each_index do |y|
    map[y][x] = ( n=(map[y][x-orig_x_len] + 1)%10; n==0?1:n )
  end
end
#puts map.map(&:join).join("\n")


## HELP CODE
# A crude priority queue
path_queue = {}
def path_queue.current_prio
  self.keys.min
end
def path_queue.<<(path_queue_data)
  xy,history,history_risks,risk = path_queue_data

  #prio = risk
  #prio = [risk,history.length]
  #prio = [history.length,risk]
  prio = history_risks.last.to_i

  self[prio] ||= []
  self[prio] << [xy,history,history_risks]
end
def path_queue.pop
  prio = self.current_prio
  return nil if prio.nil?

  element = self[prio].shift
  self.delete(prio) if self[prio].empty?

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
  #asdf = history           .inject({}){|h,(x,y)| h[y] ||= []; h[y] << x; h }
  #puts map.clone.map{|l| l.clone }.yield_self{|m| m[y][x] = '*'; asdf.each{|y,xs| m[y].each_index{|x| m[y][x] = '.' if     xs.include?(x) } }; m }.map(&:join).join("\n")

  #puts
  #STDIN.gets("\n")  # Step each loop by pressing enter
end

#pp final_path #DEBUG
#asdf = history           .inject({}){|h,(x,y)| h[y] ||= []; h[y] << x; h }
#puts map.clone.map{|l| l.clone }.yield_self{|m| m[y][x] = '*'; asdf.each{|y,xs| m[y].each_index{|x| m[y][x] = '.' if     xs.include?(x) } }; m }.map(&:join).join("\n")
#puts

## ANSWER
answer = final_path.map{|x,y| map[y][x] }.sum - map[0][0]
puts answer
