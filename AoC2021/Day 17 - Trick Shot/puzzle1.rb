#!/usr/bin/env ruby


## INPUT
data = File.exists?(ARGV[0]) ? ARGF.read \
                             : ARGV[0]


## PARSING
target = data.gsub("target area: ","")
             .split(/, */)
             .map{|str|
               str = str.split('=')
               str[-1] = str[-1].split('..')
                                .map(&:to_i)
                                .sort
             }
             .yield_self{|d| [:xr,:yr].zip(d).to_h }
p target #DEBUG


## HELP CODE
class Position
  def initialize(initial_velosity, type)
    @initial_velosity = initial_velosity
    @v = initial_velosity
    @value = 0

    @type = type
  end

  def position(t)
    case @type
      when :x then pos_x(t)
      when :y then pos_y(t)
    end
  end

  def pos_x(t)
    v = @initial_velosity
    negate = v < 0
    v = -v if negate

    x = (t <= v) ? ( v*t - (t**2 - t)/2 ) \
                 : ( (v**2 - v)/2 )

    x = -x if negate
    return x
  end

  def pos_y(t)
    v = @initial_velosity
    v*t - (t**2 - t)/2
  end
end
#p Position.new( 5,:y).position(3)  #  12
#p Position.new( 5,:x).position(3)  #  12
#p Position.new(-5,:x).position(3)  # -12


## CHECK


## CALCULATE


## ANSWER
answer = nil
puts answer
