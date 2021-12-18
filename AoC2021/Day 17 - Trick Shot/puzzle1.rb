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
def x_pos(t, v)
  negate = v < 0
  v = -v if negate

  x = (t <= v)  \
      ? v*t - (t**2 - t)/2  \
      : (v**2 - v)/2

  x = -x if negate
  return x
end

def y_pos(t, v)
  v*t - (t**2 - t)/2
end


## CHECK


## CALCULATE
solutions = []

x_enumerator = if target[:x].all?{|x| x >= 0}
                 0..target[:x].max
               elsif target[:x].all?{|x| x < 0}
                 target[:x].min..0
               else
                 target[:x].min..target[:x].max
               end

x_enumerator.each do |x_velocity|
  (0..).each do |y_velocity|
    x = x_pos(y_velocity, x_velocity)
    break if x_velocity >= 0 && x >= target[:x].max
    break if x_velocity <  0 && x >= target[:x].min
    (0..).each do |step|
      x = x_pos(step, x_velocity)
      y = y_pos(step, y_velocity)
      break if x_velocity >= 0 && x > target[:x].max
      break if x_velocity <  0 && x < target[:x].min
      break if                    y > target[:y].min
      next unless (target[:x].min..target[:x].max).include?(x)
      next unless (target[:y].min..target[:y].max).include?(y)
      solutions << [step, x_velocity, y_velocity]
    end
  end
end


pp solutions #DEBUG
p [x_pos(4,9), y_pos(4,0)] #DEBUG


## ANSWER
answer = solutions.map{|_,_,y_velocity| y_velocity }.max
              .yield_self{|y_velocity| y_pos(y_velocity, y_velocity) }
puts answer
