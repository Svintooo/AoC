#!/usr/bin/env ruby
#DEBUG = false


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
#(p target; puts) if DEBUG


## HELP CODE
def x_pos(step, velo)
  negate = velo < 0
  velo = -velo if negate

  x = (step <= velo)  \
      ? velo*step - (step**2 - step)/2  \
      : velo*velo - (velo**2 - velo)/2

  x = -x if negate
  return x
end

def y_pos(step, velo)
  velo*step - (step**2 - step)/2
end

def step_where_y_is_zero(velo)
  2*velo + 1
end


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
  x = x_pos(x_velocity,x_velocity)
  next if x > 0 && x < target[:x].min
  next if x < 0 && x > target[:x].max
  next if x == 0 && !(target[:x].min..target[:x].max).include?(x)
  [ 0.step(nil,+1), (-1).step(nil,-1) ].each do |y_enumerator|
    y_enumerator.each do |y_velocity|
      break if y_velocity < target[:y].min
      next if [x_velocity,y_velocity] == [0,0]
      x = x_pos(y_velocity, x_velocity)
      break if x > 0 && x >= target[:x].max &&
      break if x < 0 && x <= target[:x].min
      next if x == 0 && y_velocity != 0 && !(target[:x].min..target[:x].max).include?(x)
      start_step = step_where_y_is_zero(y_velocity)
      start_step = 0 if start_step < 0
      start_step += 1
      break if y_pos(start_step, y_velocity) < target[:y].min
      (start_step..).each do |step|
        x = x_pos(step, x_velocity)
        y = y_pos(step, y_velocity)
        break if x > 0 && x > target[:x].max
        break if x < 0 && x < target[:x].min
        break if x == 0 && !(target[:x].min..target[:x].max).include?(x)
        break if y < target[:y].min
        next unless (target[:x].min..target[:x].max).include?(x)
        next unless (target[:y].min..target[:y].max).include?(y)
        solutions << [x_velocity, y_velocity, step]
      end
    end
  end
end

#(pp solutions;puts) if DEBUG


## ANSWER
answer = solutions.map{|_,y_velocity,_| y_velocity }.max
                  .yield_self{|y_velocity| y_pos(y_velocity, y_velocity) }
puts answer
