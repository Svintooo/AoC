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

#all [V,t] where t=V..1 and V=(Tx.last)..1 and x(t)=(Tx.last)..(Tx.first)
x_solutions = []
#TODO: support for negative values in target[:x]
1.upto(target[:x].last).each do |x_velocity| #V=(Tx.last)..1
  1.upto(x_velocity).each do |step| #t=V..1
    x = x_pos(step, x_velocity)
    x_solution = [step, x_velocity]
    x_solutions << x_solution if x >= target[:x].first && x <= target[:x].last
  end
end
#pp x_solutions #DEBUG

#all [A,t] where t in Vts and A=1..t and y(t)=(Ty.last)..(Ty.first)
x_solutions.each do |step, x_velocity| #t in Vts
  1.upto(step) do |y_velocity| #A=1..t
    y = y_pos(step, y_velocity)
    solution = [step, x_velocity, y_velocity]
    solutions << solution if y >= target[:y].first && y <= target[:y].last
  end
end
pp solutions #DEBUG


## ANSWER
answer = solutions.map{|_,_,y_velocity| y_velocity }.max
              .yield_self{|y_velocity| y_pos(y_velocity, y_velocity) }
puts answer
