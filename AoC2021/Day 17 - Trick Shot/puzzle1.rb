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
  #print"x" #DEBUG
  x = x_pos(x_velocity,x_velocity)
  (puts".x1";next) if x > 0 && x < target[:x].min
  (puts".x2";next) if x < 0 && x > target[:x].max
  (puts".x3";next) if x == 0 && !(target[:x].min..target[:x].max).include?(x)
  (0..).each do |y_velocity|
    #print"y" #DEBUG
    (puts".x.y1";next) if [x_velocity,y_velocity] == [0,0]
    x = x_pos(y_velocity, x_velocity)
    puts;p([x_velocity,y_velocity,x]) #DEBUG
    (puts".x.y2";break) if x > 0 && x >= target[:x].max
    (puts".x.y3";break) if x < 0 && x <= target[:x].min
    (puts".x.y4";next) if x == 0 && !(target[:x].min..target[:x].max).include?(x)
    #print"." #DEBUG
    #y = y_pos(1, y_velocity)
    #break if y < target[:y].min
    (1..).each do |step|
      x = x_pos(step, x_velocity)
      y = y_pos(step, y_velocity)
      (puts".x.y.s1 #{[x_velocity,y_velocity,step,x,y]}";break) if x > 0 && x > target[:x].max
      (puts".x.y.s2 #{[x_velocity,y_velocity,step,x,y]}";break) if x < 0 && x < target[:x].min
      (puts".x.y.s3 #{[x_velocity,y_velocity,step,x,y]}";break) if x == 0 && !(target[:x].min..target[:x].max).include?(x)
      (puts".x.y.s4 #{[x_velocity,y_velocity,step,x,y]}";break) if y < target[:y].min
      (puts".x.y.s5 #{[x_velocity,y_velocity,step,x,y]}";next) unless (target[:x].min..target[:x].max).include?(x)
      (puts".x.y.s6 #{[x_velocity,y_velocity,step,x,y]}";next) unless (target[:y].min..target[:y].max).include?(y)
      solutions << [step, x_velocity, y_velocity]
    end
  end
end


pp solutions #DEBUG
#p [x_pos(4,9), y_pos(4,0)] #DEBUG


## ANSWER
answer = solutions.map{|_,_,y_velocity| y_velocity }.max
                  .yield_self{|y_velocity| y_pos(y_velocity, y_velocity) }
puts answer
