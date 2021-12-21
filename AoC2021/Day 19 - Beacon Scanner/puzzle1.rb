#!/usr/bin/env ruby
NEWLINE = /(?:\r\n?|\n)/
SCANNER_RANGE = 1000
MINIMUM_MATCHING_BEACONS = 12


## INPUT
data = ARGF.read


## PARSING
scanners_readings =
  data.split(/#{NEWLINE}#{NEWLINE}/)
      .map{|scanner|
        scanner.gsub(/\A--- scanner [0-9]+ ---/,'')
               .strip
               .split(NEWLINE)
               .map{|beacon| beacon.split(',').map(&:to_i) }
               .unshift([0,0,0])  # Scanner coordinate added to top of each list
      }
#pp scanners_readings #DEBUG
#exit #DEBUG EXIT


## CHECK
if not scanners_readings.all?{|scanner_readings| scanner_readings.all?{|coordinates| coordinates.count == 3 && coordinates.all?{|num| num.kind_of? Integer } } }
  #pp scanners_readings.reject{|scanner_readings| scanner_readings.all?{|coordinates| coordinates.count == 3 && coordinates.all?{|num| num.kind_of? Integer } } }
  raise "Input error"
end
#exit #DEBUG EXIT


## HELP CODE
def copy(array)
  array = array.clone

  array.each_with_index do |ary, i|
    array[i] = ary.clone
  end
end
#a1 = scanners_readings[0][0..4] #DEBUG
#a2 = copy(a1) #DEBUG
#a2[0][2] = "asdf" #DEBUG
#a2[1] = "qwer" #DEBUG
#a2 << a2.delete_at(3)
#pp(a1,a2) #DEBUG
#exit #DEBUG EXIT

# Check if the new scanner clashes with an already occupied coordinate
def new_scanner_clashes_with_an_occupied_coordinate(beacon_map, readings)
  new_scanner = readings[0]
  return beacon_map.include?(new_scanner)
end

# Check if any reachable new beacon doesn't exist in beacon_map
def has_unmatching_beacons(scanners, beacons, readings)
  new_beacons = readings[1..-1]  # Excluding scanner coordinate at top of list

  new_reachable_beacons =
    new_beacons.select do |beacon|
      scanners.any? do |scanner|
        beacon[0] <= scanner[0] + SCANNER_RANGE &&
        beacon[0] >= scanner[0] - SCANNER_RANGE &&
        beacon[1] <= scanner[1] + SCANNER_RANGE &&
        beacon[1] >= scanner[1] - SCANNER_RANGE &&
        beacon[2] <= scanner[2] + SCANNER_RANGE &&
        beacon[2] >= scanner[2] - SCANNER_RANGE
      end
    end

  return new_reachable_beacons.any?{|beacon| not beacons.include?(beacon) }
end
#p has_unmatching_beacons([[0,0,0],[1,2,3],[-1,-2,-3]],1,[[9,9,9],[1,2,3]]) #DEBUG false
#p has_unmatching_beacons([[0,0,0],[1,2,3],[-1,-2,-3]],1,[[9,9,9],[1,2,3],[1009,1009,1009]]) #DEBUG false
#p has_unmatching_beacons([[0,0,0],[1,2,3],[-1,-2,-3]],1,[[9,9,9],[1,2,3],[1000,1000,1000]]) #DEBUG true
#p has_unmatching_beacons([[0,0,0],[1,2,3],[-1,-2,-3]],1,[[9,9,9],[1,2,3],[-991,-991,-991]]) #DEBUG true
#exit #DEBUG EXIT

def count_matching_beacons(beacons, readings)
  (beacons & readings[1..-1]).count  # Excluding scanner coordinate at top of list
end
#p count_matching_beacons([[0,0,0],[1,2,3],[-1,-2,-3]],1,[[9,9,9],[1,2,3],[1009,1009,1009]]) #DEBUG 1
#p count_matching_beacons([[0,0,0],[1,2,3],[-1,-2,-3]],1,[[9,9,9],[1,2,3],[-1,-2,-3]])       #DEBUG 2
#p count_matching_beacons([[0,0,0],[1,2,3],[-1,-2,-3]],1,[[9,9,9],[2,3,4],[1009,1009,1009]]) #DEBUG 0
#exit #DEBUG EXIT

# Enumerator for all possible rotations for all xyz-coordinates in an array
class Rotations
  include Enumerable

  def initialize(scanner_readings)
    @scanner_readings = copy(scanner_readings)
  end

  def rotate_x
    @scanner_readings.each do |beacon|
      y, z = beacon[2], -beacon[1]
      beacon[1], beacon[2] = y, z
    end
  end

  def rotate_y
    @scanner_readings.each do |beacon|
      x, z = -beacon[2], beacon[0]
      beacon[0], beacon[2] = x, z
    end
  end

  def rotate_z
    @scanner_readings.each do |beacon|
      x, y = beacon[1], -beacon[0]
      beacon[0], beacon[1] = x, y
    end
  end

  def each
    yield copy(@scanner_readings)

    rotate_y(); yield copy(@scanner_readings)
    rotate_y(); yield copy(@scanner_readings)
    rotate_y(); yield copy(@scanner_readings)

    rotate_x(); yield copy(@scanner_readings)

    rotate_z(); yield copy(@scanner_readings)
    rotate_z(); yield copy(@scanner_readings)
    rotate_z(); yield copy(@scanner_readings)

    rotate_y(); yield copy(@scanner_readings)

    rotate_x(); yield copy(@scanner_readings)
    rotate_x(); yield copy(@scanner_readings)
    rotate_x(); yield copy(@scanner_readings)

    rotate_z(); yield copy(@scanner_readings)

    rotate_y(); yield copy(@scanner_readings)
    rotate_y(); yield copy(@scanner_readings)
    rotate_y(); yield copy(@scanner_readings)

    rotate_x(); yield copy(@scanner_readings)

    rotate_z(); yield copy(@scanner_readings)
    rotate_z(); yield copy(@scanner_readings)
    rotate_z(); yield copy(@scanner_readings)

    rotate_y(); yield copy(@scanner_readings)

    rotate_x(); yield copy(@scanner_readings)
    rotate_x(); yield copy(@scanner_readings)
    rotate_x(); yield copy(@scanner_readings)
  end
end
#Rotations.new([[1,2,3],[4,5,6]]).each{|o| p o }#DEBUG
#exit #DEBUG EXIT

# Enumerator for all moved scanner_readings where two (2) beacons share positions
class Movements
  include Enumerable

  def initialize(beacons, readings)
    @beacons  = copy(beacons)
    @readings = copy(readings)
    @w_beacons     = weight_beacons(copy(@beacons))
    @w_new_beacons = weight_beacons(copy(@readings[1..-1]))  # Excluding scanner coordinate at top of list
  end

  def weight_beacons(beacons)
    w_beacons = beacons.map{|beacon| [beacon,[]] }
    imax = w_beacons.length-1

    w_beacons = sort(w_beacons, [ 1, 1, 1])
    w_beacons.each_with_index{|(_,weight),i| weight << [(i>MINIMUM_MATCHING_BEACONS-1), (imax-i>MINIMUM_MATCHING_BEACONS-1)] }

    w_beacons = sort(w_beacons, [-1, 1, 1])
    w_beacons.each_with_index{|(_,weight),i| weight << [(i>MINIMUM_MATCHING_BEACONS-1), (imax-i>MINIMUM_MATCHING_BEACONS-1)] }

    w_beacons = sort(w_beacons, [ 1,-1, 1])
    w_beacons.each_with_index{|(_,weight),i| weight << [(i>MINIMUM_MATCHING_BEACONS-1), (imax-i>MINIMUM_MATCHING_BEACONS-1)] }

    w_beacons = sort(w_beacons, [ 1, 1,-1])
    w_beacons.each_with_index{|(_,weight),i| weight << [(i>MINIMUM_MATCHING_BEACONS-1), (imax-i>MINIMUM_MATCHING_BEACONS-1)] }

    return w_beacons
  end

  def sort(w_beacons, transform)
    raise "transform" unless transform.all?{|n| n == 1 || n == -1 }
    return w_beacons.sort_by{|beacon,_|
             beacon = beacon.zip(transform).map{|a,b|a*b}
             [beacon.sum, beacon]
           }
  end

  def move_readings_so_beacons_share_coordinates(beacon, new_beacon, readings)
    movement = beacon.zip(new_beacon).map{|a,b|a-b}

    readings.each_with_index do |coordinate, i|
      readings[i] = coordinate.zip(movement).map{|a,b|a+b}
    end

    return readings
  end

  def each
    @w_beacons.each do |beacon,weight|
      @w_new_beacons.each do |new_beacon,weight2|
        yield move_readings_so_beacons_share_coordinates(beacon, new_beacon, copy(@readings))
      end
    end
  end
end
#Movements.new([[1,2,3]]           ,[[9,9,9],[1,2,3]]        ).each{|moved_readings| pp moved_readings };puts #DEBUG
#Movements.new([[1,2,3]]           ,[[9,9,9],[1,2,3],[4,5,6]]).each{|moved_readings| pp moved_readings };puts #DEBUG
#Movements.new([[1,2,3],[ 3, 4, 5]],[[9,9,9],[1,2,3],[4,5,6]]).each{|moved_readings| pp moved_readings };puts #DEBUG
#Movements.new([[1,2,3],[-1,-2,-3]],[[9,9,9],[1,2,3],[4,5,6]]).each{|moved_readings| pp moved_readings };puts #DEBUG
#Movements.new([[1,2,3],[-1,-2,-3]],[[9,9,9],[1,2,3],[1009,1009,1009]]).each{|moved_readings| pp moved_readings };puts #DEBUG
#exit #DEBUG EXIT


## CALCULATE

# Initialize Map
beacon_map = copy(scanners_readings[0])
scanners   = [ beacon_map.shift ]  # Remove scanner coordinate from beacon_map
#pp beacon_map #DEBUG
#pp scanners #DEBUG

# Loop queue
queue = scanners_readings[1..-1]

# Build map
#WARN: This can loop forewer if not all readings can be matched together
while scanner_readings = queue.shift
  catch :MATCH_FOUND do
    Rotations.new(scanner_readings).each do |rotated_readings|
      Movements.new(beacon_map, rotated_readings).each do |moved_readings|
        next if new_scanner_clashes_with_an_occupied_coordinate(beacon_map+scanners, moved_readings)
        next if has_unmatching_beacons(scanners, beacon_map, moved_readings)
        matching_beacon_count = count_matching_beacons(beacon_map, moved_readings)

        if matching_beacon_count >= MINIMUM_MATCHING_BEACONS
          # Add new scanner coordinates
          scanners << moved_readings.shift  # Scanner removed from moved_readings

          # Add all new beacons that is not already included in beacon_map
          beacon_map |= moved_readings  # Same as: array1 = array1 | array2

          throw :MATCH_FOUND
        end
      end
    end

    # No match found, put back into queue again
    queue << scanner_readings
  end
end


## ANSWER
answer = beacon_map.count
puts answer
