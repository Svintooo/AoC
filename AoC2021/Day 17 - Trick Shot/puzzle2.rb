#!/usr/bin/env ruby
#DEBUG = false


## INPUT
# Example: "target area: x=20..30, y=-10..-5"
data = case when File.exists?(ARGV[0])
            then ARGF.read
            else ARGV[0]
            end


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
# See NOTES.md for explanation on the formulas used here

def x_pos(step, velocity)
  negate = velocity < 0
  velocity = -velocity if negate

  velo = velocity
  x = case when step <= velo
           then velo*step - (step**2 - step)/2
           else velo*velo - (velo**2 - velo)/2
           end

  x = -x if negate
  return x
end

def y_pos(step, velocity)
  velocity*step - (step**2 - step)/2
end

def step_where_y_is_zero(velo)
  2*velo + 1
end


## CALCULATE
solutions = []

x_enumerator = case
    when target[:x].all?{|x| x >= 0}
      # target area is ahead of submarine
      0 .. target[:x].max
    when target[:x].all?{|x| x < 0}
      # target area is behind submarine
      target[:x].min .. 0
    else
      # target area right below submarine
      target[:x].min .. target[:x].max
    end

x_enumerator.each do |x_velocity|
  # Check if x can reach the target area
  furthest_x = x_pos(x_velocity, x_velocity)
  next if x_velocity  > 0 && furthest_x < target[:x].min
  next if x_velocity  < 0 && furthest_x > target[:x].max
  next if x_velocity == 0 && !(target[:x].min..target[:x].max).include?(furthest_x)

  # Use infinite enumerators to test all possible values for y velocity
  [ 0.step(nil,+1), (-1).step(nil,-1) ].each do |y_enumerator|
    y_enumerator.each do |y_velocity|
      # check that (x,y) has movement
      next if x_velocity == 0 && y_velocity == 0

      # when y is at its highest, check that x hasn't gone beyond target area
      x_when_y_is_highest = x_pos(y_velocity, x_velocity)
      break if x_velocity > 0 && x_when_y_is_highest >= target[:x].max
      break if x_velocity < 0 && x_when_y_is_highest <= target[:x].min

      # when x has no velocity, check that target area is right below submarine position
      next if x_velocity == 0 && y_velocity != 0 && !(target[:x].min..target[:x].max).include?(0)

      # start step value where y < 0, since target area is always below submarine position
      start_step = 1
      start_step += step_where_y_is_zero(y_velocity) unless y_velocity < 0

      # check if first step falls below target area
      break if y_pos(start_step, y_velocity) < target[:y].min

      # x and y velocities are set: start stepping
      (start_step..).each do |step|
        x = x_pos(step, x_velocity)
        y = y_pos(step, y_velocity)

        # check that (x,y) hasn't gone beyong target area
        break if x > 0 && x > target[:x].max
        break if x < 0 && x < target[:x].min
        break if x == 0 && !(target[:x].min..target[:x].max).include?(x)
        break if y < target[:y].min

        # store velocities if (x,y) is inside target area
        next unless (target[:x].min..target[:x].max).include?(x)
        next unless (target[:y].min..target[:y].max).include?(y)
        solutions << [x_velocity, y_velocity, step]
      end
    end
  end
end

#(pp solutions;puts) if DEBUG


## ANSWER
answer = solutions.map{|vx,vy,step| [vx,vy] }
                  .uniq
                  .count
puts answer
