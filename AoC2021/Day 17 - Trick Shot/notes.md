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
position: x   = Vt - ½t²  if t <= V         # This would've been correct
              = ½V²       if t >= V         # if we weren't stepping.
position: x   = V+(V-1)+(V-2)+...+(V-(t-1))  if t < V
              = V+ V-1 + V-2 +...+ V-(t-1)
              = Vt -1-2-...-(t-1)
              = Vt - (t(t-1))/2             # This is the correct formula for the
              = Vt - t²/2 - t/2  if t <= V  # simulation we do in this puzzle.
              = V²/2 - V/2       if t >= V
t: time (step)
V: start velocity
```


## Y
```
accelrtn: y'' = -1
velocity: y'  = A - t
position: y   = At - ½t²         # Nope (see X)
position: y   = At - t²/2 - t/2  # Yes  (see X)
t: time (step)
A: start velocity
```


## Start velocities (for X and Y)
```
     targets: Tx  = [20..30]   # Example
              Ty  = [-10..-5]  # Example

possible Vts: Vts = all [V,t] where t=V..1 and V=30..1 and x(t)=30..20
                  = all [V,t] where t=V..1 and V=(Tx.last)..1 and x(t)=(Tx.last)..(Tx.first)

possible Ats: Ats = all [A,t] where t in Vts and A=1..? and y(t)=-10..-5
                  = all [A,t] where t in Vts and A=1..? and y(t)=(Ty.last)..(Ty.first)
```
