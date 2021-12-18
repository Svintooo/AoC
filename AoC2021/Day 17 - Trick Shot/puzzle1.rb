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
p target; puts #DEBUG


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


## CHECK


## CALCULATE
solutions = []

DEBUG = true

x_enumerator = if target[:x].all?{|x| x >= 0}
                 0..target[:x].max
               elsif target[:x].all?{|x| x < 0}
                 target[:x].min..0
               else
                 target[:x].min..target[:x].max
               end

x_enumerator.each do |x_velocity|
  puts if DEBUG
  x = x_pos(x_velocity,x_velocity)
  (puts".x1 #{[x_velocity]}" if DEBUG;next) if x > 0 && x < target[:x].min
  (puts".x2 #{[x_velocity]}" if DEBUG;next) if x < 0 && x > target[:x].max
  (puts".x3 #{[x_velocity]}" if DEBUG;next) if x == 0 && !(target[:x].min..target[:x].max).include?(x)
  [ 0.step(nil,+1), (-1).step(nil,-1) ].each do |y_enumerator|
    y_enumerator.each do |y_velocity|
      (puts".x.y1 #{[x_velocity,y_velocity]}" if DEBUG;break) if y_velocity < target[:y].min
      (puts".x.y2 #{[x_velocity,y_velocity]}" if DEBUG;next) if [x_velocity,y_velocity] == [0,0]
      x = x_pos(y_velocity, x_velocity)
      #puts;p([x_velocity,y_velocity,x]) #DEBUG
      (puts".x.y3 #{[x_velocity,y_velocity]}" if DEBUG;break) if x > 0 && x >= target[:x].max &&
      (puts".x.y4 #{[x_velocity,y_velocity]}" if DEBUG;break) if x < 0 && x <= target[:x].min
      (puts".x.y5 #{[x_velocity,y_velocity]}" if DEBUG;next) if x == 0 && y_velocity != 0 && !(target[:x].min..target[:x].max).include?(x)
      start_step = step_where_y_is_zero(y_velocity)
      start_step = 0 if start_step < 0
      start_step += 1
      (puts".x.y6 #{[x_velocity,y_velocity]}" if DEBUG;break) if y_pos(start_step, y_velocity) < target[:y].min
      (start_step..).each do |step|
        x = x_pos(step, x_velocity)
        y = y_pos(step, y_velocity)
        (puts".x.y.s1 #{[x_velocity,y_velocity,step,x,y]}" if DEBUG;break) if x > 0 && x > target[:x].max
        (puts".x.y.s2 #{[x_velocity,y_velocity,step,x,y]}" if DEBUG;break) if x < 0 && x < target[:x].min
        (puts".x.y.s3 #{[x_velocity,y_velocity,step,x,y]}" if DEBUG;break) if x == 0 && !(target[:x].min..target[:x].max).include?(x)
        (puts".x.y.s4 #{[x_velocity,y_velocity,step,x,y]}" if DEBUG;break) if y < target[:y].min
        (puts".x.y.s5 #{[x_velocity,y_velocity,step,x,y]}" if DEBUG;next) unless (target[:x].min..target[:x].max).include?(x)
        (puts".x.y.s6 #{[x_velocity,y_velocity,step,x,y]}" if DEBUG;next) unless (target[:y].min..target[:y].max).include?(y)
        #solutions << [x_velocity, y_velocity, step]
        DEBUG ? (puts".x.y.sG #{[x_velocity,y_velocity,step,x,y]}";solutions << [x_velocity, y_velocity, step];next) : solutions << [x_velocity, y_velocity, step]
        puts".x.y.sE #{[x_velocity,y_velocity,step,x,y]}" if DEBUG
      end
    end
  end
end
puts if DEBUG

#DEBUG
pp solutions
#p [x_pos(4,9), y_pos(4,0)]
puts


## ANSWER
answer = solutions.map{|_,y_velocity,_| y_velocity }.max
                  .yield_self{|y_velocity| y_pos(y_velocity, y_velocity) }
puts answer
