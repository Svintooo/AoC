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
#TODO: support for negative values in target[:x]
1.upto(target[:x].last).each do |velocity| #V=(Tx.last)..1
  1.upto(velocity).each do |step| #t=V..1
    x = x_pos(velocity, step)
    x_v_t << [velocity, step] if x >= target[:x].first && x <= target[:x].last
  end
end
pp x_v_t #DEBUG

#all [A,t] where t in Vts and A=1..t and y(t)=(Ty.last)..(Ty.first)
y_v_t = []
x_v_t.each do |_,step| #t in Vts
  1.upto(step) do |velocity| #A=1..t
    y = y_pos(velocity, step)
    y_v_t << [velocity, step] if y >= target[:y].first && y <= target[:y].last
  end
end


## ANSWER
answer = nil
puts answer
