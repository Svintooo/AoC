# Trick Shot


## Known values
```
start position: x=0, y=0
example target: x=20..30, y=-10..-5
```

## X
```
accelrtn: x'' = -1
velocity: x'  = -t + V    if t <= V
              = 0         if t >= V
position: x   = -½t² + Vt if t <= V
              = ½V²       if t >= V
t: time (step)
V: start velocity
NOTE: position (x) does not include `+ C`
      since start position it at 0.
```


## Y
```
accelrtn: y'' = -1
velocity: y'  = -t + A
position: y   = -½t² + At
t: time (step)
A: start velocity
NOTE: position (y) does not include `+ C`
      since start position it at 0.
```


## Start velocity V (for X)
```
    targets: T = [20..30]
possible Vs: Vs = T +


x = V+(V-1)+(V-2)+...+(V-(t-1))+(V-t) if t <= V
  = V+ V-1 + V-2 +...+ V-(t-1) + V-t
  = V(t+1) -1-2-...-(t-1)-t
  = V(t+1) - (t*(t+1))/2

x = V+(V-1)+(V-2)+...+(V-(t-1)) if t < V
  = V+ V-1 + V-2 +...+ V-(t-1)
  = Vt -1-2-...-(t-1)
  = Vt - (t(t-1))/2
  = Vt - (t²-t)/2
```
