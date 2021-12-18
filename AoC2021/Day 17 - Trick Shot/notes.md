# Trick Shot


## Known values
```
start position: x=0, y=0
example target: x=20..30, y=-10..-5
```

## X
```
accelrtn: x'' = -1
velocity: x'  = V - t     if t <= V
              = 0         if t >= V
position: x   = Vt - ½t²  if t <= V     # This would've been correct
              = ½V²       if t >= V     # if we weren't stepping.
position: x   = V+(V-1)+(V-2)+...+(V-(t-1)) if t < V
              = V+ V-1 + V-2 +...+ V-(t-1)
              = Vt -1-2-...-(t-1)
              = Vt - (t(t-1))/2         # This is the correct formula for the
              = Vt - (t²-t)/2 if t < V  # simulation we do in this puzzle.
t: time (step)
V: start velocity
NOTE: position (x) does not include `+ C`
      since start position it at 0.
```


## Y
```
accelrtn: y'' = -1
velocity: y'  = A - t
position: y   = At - ½t²
position: y   = At - (t²-t)/2
t: time (step)
A: start velocity
NOTE: position (y) does not include `+ C`
      since start position it at 0.
```


## Start velocity V (for X)
```
    targets: T = [20..30]
possible Vs: Vs = T +


```
