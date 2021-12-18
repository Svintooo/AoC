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
position: x   = Vt - ½t²  if t <= V         # This would've been correct if we weren't
              = ½V²       if t >= V         # stepping.
position: x   = Vt - (t² - t)/2  if t <= V  # This is the correct formula for the simulation
              = (V² + V)/2       if t >= V  # we do in this puzzle.
t: time (step)
V: start velocity
```


## Y
```
accelrtn: y'' = -1
velocity: y'  = A - t
position: y   = At - ½t²         # Nope (see X)
position: y   = At - (t² - t)/2  # Yes  (see X)
t: time (step)
A: start velocity
```


## Start velocities (for X and Y)
```
     targets: Tx  = [20..30]   # Example
              Ty  = [-10..-5]  # Example

possible Vts: Vts = all [V,t] where t=V..1 and V=30..1        and x(t)=30..20
                  = all [V,t] where t=V..1 and V=(Tx.last)..1 and x(t)=(Tx.last)..(Tx.first)

possible Ats: Ats = all [A,t] where t in Vts and A=1..t and y(t)=-10..-5
                  = all [A,t] where t in Vts and A=1..t and y(t)=(Ty.last)..(Ty.first)
```
```
     targets: Ty  = [-10..-5]  # Example
              Tx  = [20..30]   # Example

possible Ats: Ats = all [t,A] where t=1.. and A=1.. and y(t)=-10..-5
                  = all [t,A] where t=1.. and A=1.. and y(t)=(Ty.last)..(Ty.first)

possible Vts: Vts = all [t,V] where t=1.. and V=1..30        and x(t)=30..20
                  = all [t,V] where t=1.. and V=1..(Tx.last) and x(t)=(Tx.last)..(Tx.first)
```


## Proofs
If the acceleration is -1, initial velocity is V, and each step t is a positive integer,
and the acceleration is only changing the velocity at each step t.
Then position x can be calculated like this:
```
x = V + (V-1) + (V-2) + ... + (V-(t-1))
  = V +  V-1  +  V-2  + ... +  V-(t-1)
  = V*t -  1 - 2 - ... - (t-1)
  = V*t - (1 + 2 + ... + (t-1))
  = V*t - (t*(t-1))/2
  = V*t - (t²-t)/2
  = V*t - t²/2 - t/2
```
and when t = V:
```
x = V*V - V²/2 - V/2
  = V² - V²/2 - V/2
  = V²(1-½) - V/2
  = V²/2 - V/2
```
