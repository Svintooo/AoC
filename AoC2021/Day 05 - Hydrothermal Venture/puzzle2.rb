#!/usr/bin/env ruby

filename = ARGV[0]
data     = IO.read(filename)


## PARSING
vents_lines = data.split(/\n/)
                  .collect{|vents_line|
                    vents_line.strip
                              .split(/ *-> */)
                              .collect{|coordinate|
                                coordinate.split(/,/)
                                          .map{|xy| xy.to_i }
                              }
                  }
#pp vents_lines #DEBUG


## CALCULATION
vent_map = [[]]

vents_lines.each do |start, stop|
  # Extend map
  vent_map.count.upto(start[0]).each{|x| vent_map[x] = []} if vent_map.count <= start[0]
  vent_map.count.upto(stop [0]).each{|x| vent_map[x] = []} if vent_map.count <= stop [0]

  # Mark vent lines on map
  if start[0] == stop[0] || start[1] == stop[1]
    ## Horizontal and Vertival
    #NOTE: Hah! Good luck understanding this code lol!

    # Get direction
    xy = (start[0] == stop[0]) ? [0,1] : [1,0]
    xy1 = start[xy[0]]
    direction = (start[xy[1]] < stop[xy[1]]) ? (:upto) : (:downto)

    # Mark vents
    start[xy[1]].send(direction, stop[xy[1]])
                .each{|xy2|
                  x,y = (xy == [0,1]) ? [xy1,xy2] : [xy2,xy1]
                  vent_map[x][y] ||= 0
                  vent_map[x][y] += 1
                }
  else
    ## Diagonal

    # Get x and y directions
    x_direction = (start[0] < stop[0]) ? (:+) : (:-)
    y_direction = (start[1] < stop[1]) ? (:+) : (:-)

    # Mark vents
    move = start.clone
    vent_map[move[0]][move[1]] ||= 0
    vent_map[move[0]][move[1]] += 1
    while move != stop
      move[0] = move[0].send(x_direction,1)
      move[1] = move[1].send(y_direction,1)
      vent_map[move[0]][move[1]] ||= 0
      vent_map[move[0]][move[1]] += 1
    end
  end
end

#NOTE: The printed map has the x,y coordinates flipped lol!
#pp vent_map.collect{|array| array.collect{|o| o == nil ? 0 : o} } #DEBUG


## ANSWER
answer = vent_map.flatten.select{|v| v != nil && v >= 2 }.count
puts answer
