#!/usr/bin/env ruby


## INPUT
data = File.exists?(ARGV[0])  \
       ? ARGF.read \
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
             .yield_self{|d| [:x,:y].zip(d).to_h }
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
  alias :pos :position

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

def x_pos(v, t)
  negate = v < 0
  v = -v if negate

  x = (t <= v)  \
      ? v*t - (t**2 - t)/2  \
      : (v**2 - v)/2

  x = -x if negate
  return x
end

def y_pos(v, t)
  v*t - (t**2 - t)/2
end


## CHECK


## CALCULATE
#all [V,t] where t=V..1 and V=(Tx.last)..1 and x(t)=(Tx.last)..(Tx.first)
x_v_t = []
1.upto(target[:x].last).each do |velocity|
  1.upto(velocity).each do |step|
    x = x_pos(velocity,step)
    x_v_t << [velocity,step] if x >= target[:x].first && x <= target[:x].last
  end
end


## ANSWER
answer = nil
puts answer
