#!/usr/bin/env ruby
NEWLINE = /(?:\r\n?|\n)/
SCANNER_RANGE = 1000
MINIMUM_MATCHING_BEACONS = 12


## INPUT
data = ARGF.read


## CHECK


## PARSING
scanners_readings =
  data.split(/#{NEWLINE}#{NEWLINE}/)
      .map{|scanner|
        scanner.gsub(/\A--- scanner . ---/,'')
               .strip
               .split(NEWLINE)
               .map{|beacon| beacon.split(',').map(&:to_i) }
               .unshift([0,0,0])  # Add the scanner coordinates
      }
#pp scanners_readings #DEBUG
#exit #DEBUG


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
#exit #DEBUG

# Check if the new scanner clashes with an already occupied coordinate
def new_scanner_clashes_with_an_occupied_coordinate(beacon_map, readings)
  new_scanner = readings[0]
  return beacon_map.include?(new_scanner)
end

# Check if any reachable new beacon doesn't exist in beacon_map
def has_unmatching_beacons(beacon_map, scanners_c, readings)
  scanners = beacon_map[0...scanners_c]
  beacons  = beacon_map[scanners_c..-1]
  new_beacons = readings[1..-1]

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
#exit #DEBUG

def count_matching_beacons(beacon_map, scanners_c, moved_readings)
  (beacon_map[scanners_c..-1] & moved_readings[1..-1]).count
end
#p count_matching_beacons([[0,0,0],[1,2,3],[-1,-2,-3]],1,[[9,9,9],[1,2,3],[1009,1009,1009]]) #DEBUG 1
#p count_matching_beacons([[0,0,0],[1,2,3],[-1,-2,-3]],1,[[9,9,9],[1,2,3],[-1,-2,-3]])       #DEBUG 2
#p count_matching_beacons([[0,0,0],[1,2,3],[-1,-2,-3]],1,[[9,9,9],[2,3,4],[1009,1009,1009]]) #DEBUG 0
#exit #DEBUG

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
#exit #DEBUG

# Enumerator for all moved scanner_readings where two (2) beacons share positions
class Movements
  include Enumerable

  def initialize(beacon_map, scanners_c, scanner_readings)
    #@scanners    = beacon_map[0...scanners_c]
    #@new_scanner = scanner_readings[0]
    @beacons     = beacon_map[scanners_c..-1]
    @readings    = copy(scanner_readings)
  end

  def move_readings_so_beacons_share_coordinates(beacon, new_beacon)
    movement = beacon.zip(new_beacon).map{|a,b|a-b}

    @readings.each_with_index do |coordinate, i|
      @readings[i] = coordinate.zip(movement).map{|a,b|a+b}
    end
  end

  def each
    @beacons.each do |beacon|
      @readings.each_index do |i|
        next if i == 0  # Skip scanner
        new_beacon = @readings[i]
        move_readings_so_beacons_share_coordinates(beacon, new_beacon)
        yield copy(@readings)
      end
    end
  end
end
#Movements.new([[0,0,0],[1,2,3]],           1,[[9,9,9],[1,2,3]]        ).each{|moved_readings| pp moved_readings };puts #DEBUG
#Movements.new([[0,0,0],[1,2,3]],           1,[[9,9,9],[1,2,3],[2,3,4]]).each{|moved_readings| pp moved_readings };puts #DEBUG
#Movements.new([[0,0,0],[1,2,3],[ 3, 4, 5]],1,[[9,9,9],[1,2,3],[2,3,4]]).each{|moved_readings| pp moved_readings };puts #DEBUG
#Movements.new([[0,0,0],[1,2,3],[-1,-2,-3]],1,[[9,9,9],[1,2,3],[2,3,4]]).each{|moved_readings| pp moved_readings };puts #DEBUG
#Movements.new([[0,0,0],[1,2,3],[-1,-2,-3]],1,[[9,9,9],[1,2,3],[1009,1009,1009]]).each{|moved_readings| pp moved_readings };puts #DEBUG
#exit #DEBUG


## CALCULATE

# Initialize Map
beacon_map = copy(scanners_readings[0])
scanners_c = 1
#pp scanners_n_beacons #DEBUG
#p scanners_c #DEBUG

# Loop queue
queue = scanners_readings[1..-1]

# Build map
#WARN: This can loop forewer if not all readings can be matched together
while scanner_readings = queue.shift
  catch :MATCH_FOUND do
    Rotations.new(scanner_readings).each do |rotated_readings|
      Movements.new(beacon_map, scanners_c, rotated_readings).each do |moved_readings|
        next if new_scanner_clashes_with_an_occupied_coordinate(beacon_map, moved_readings)
        next if has_unmatching_beacons(beacon_map, scanners_c, moved_readings)
        matching_beacon_count = count_matching_beacons(beacon_map, scanners_c, moved_readings)

        if matching_beacon_count >= MINIMUM_MATCHING_BEACONS
          # Scanners are placed at the top of beacon_map
          scanner = moved_readings.shift
          beacon_map.insert(scanners_c, scanner)
          scanners_c += 1

          # Only add the beacons that is not already included in beacon_map
          beacon_map |= moved_readings

          throw :MATCH_FOUND
        end
      end
    end

    # No match found, put back into queue again
    queue << scanner_readings
  end
end


## ANSWER
answer = beacon_map[scanners_c..-1].count
puts answer
