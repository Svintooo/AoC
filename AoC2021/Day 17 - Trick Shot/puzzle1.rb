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
def pos_x(t, v)
  negate = v < 0
  v = -v if negate

  x = (t <= v) ? ( v*t - (t**2)/2 - t/2 ) \
               : ( (v**2)/2 - v/2 )

  x = -x if negate
  return x
end

def pos_y(t, v)
  v*t - (t**2)/2 - t/2
end


## CHECK


## CALCULATE


## ANSWER
answer = nil
puts answer
