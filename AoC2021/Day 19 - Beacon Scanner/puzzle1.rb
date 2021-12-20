#!/usr/bin/env ruby
NEWLINE = /(?:\r\n?|\n)/


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
               .unshift([0,0,0])  # scanner coordinates
      }
#pp scanners_readings #DEBUG


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


## CALCULATE
beacon_map = []
scanners_c = 0

# Initialize Map
beacon_map << copy(scanners_readings[0])
scanners_c += 1
#pp scanners_n_beacons #DEBUG
#p scanners_c #DEBUG

# Loop queue
queue = scanners_readings[1..-1]

# Build map
while scanner_readings = queue.shift
  Rotations(scanner_readings).each do |rotated_readings|
    BeaconPairs(beacon_map, scanners_c, rotated_readings).each do |moved_readings|
      #
    end
  end

  # No match, put back into queue
  queue << scanner_readings
end


## ANSWER
answer = nil
puts answer
