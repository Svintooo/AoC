#!/usr/bin/env ruby
require 'json'

DIAL_LENGTH = 100
DIAL_START = 50
zero_stops = 0
zero_clicks = 0

dial_finish =
  IO.read("input")
    .split(/\n/)
    .map{|line| line.split("",2) }  # "abc" => ["a", "bc"]
    .inject(DIAL_START){|dial, (direction, length)|
      case direction
      when 'R'
        new_dial = dial + length.to_i
        divide_me = new_dial  # Easy
      when 'L'
        new_dial = dial - length.to_i
        # FUCK THIS SHIT: Subtraction has edge cases EVERYWHERE!
        #                 Recalculate so we can pretend we go to the right instead.
        mirrored_dial = (dial == 0) ? (0) : (100 - dial)  # 0 => 0, 10 => 90, 49 => 51
        mirrored_new_dial = mirrored_dial + length.to_i
        divide_me = mirrored_new_dial
      end
      zero_clicks += divide_me / DIAL_LENGTH
      new_dial %= DIAL_LENGTH
      zero_stops += 1 if new_dial == 0
      new_dial
    }

puts [zero_stops, zero_clicks].to_json
