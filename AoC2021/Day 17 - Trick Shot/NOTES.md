# Trick Shot


## Known values
```
start position: x=0, y=0
example target: x=20..30, y=-10..-5
```

## X
```
          step: t
start velocity: V

accelrtn: x"= -1               if t <= V
            = 0                if t >= V
velocity: x'= V - t            if t <= V
            = 0                if t >= V
position: x = Vt - t²/2        if t <= V  # This would've been the correct formula if we weren't
            = V²/2             if t >= V  # stepping.
position: x = Vt - (t² - t)/2  if t <= V  # This is the correct formula for the simulation that
            = (V² + V)/2       if t >= V  # is done in this puzzle.
```


## Y
```
          step: t
start velocity: V

accelrtn: y"= -1
velocity: y'= V - t
position: y = Vt - t²/2        # Nope (see X)
position: y = Vt - (t² - t)/2  # Yes  (see X)
   y = 0: t = 2V + 1
```


## Proofs

### Formulas
The puzzle instructions tells that acceleration (drag) is -1.
If we use the reverse derivatives we can get the formulas for velocity and position.
```
p"= -1
  = -1*t⁰
  = (-1  )t⁰
P'= (-1/1)t¹ + Vt⁰
  =    -1*t¹ + Vt⁰
  =      -t  + V
  = -t + V
  = V - t
  =     V   -      t
  =     Vt⁰ -      t¹
  = (V  )t⁰ - (2  )t¹/2
p = (V/1)t¹ - (2/2)t²/2
  = (V  )t  - (1  )t²/2
  =     Vt  -      t²/2
  = Vt - t²/2
```
Which gives us:
```
acceleration: p"= -1
    velocity: p'= V - t
    position: p = Vt - t²/2
```

### Formula for position (the real one)
The formula above for position p does not correlate with the actual positions you get in this puzzle.
This is because in the puzzle we are stepping. To get to the next position you add the current velocity to p, then you subtract 1 from the velocity. The formula for this behavior can be seen below.

If the position is p, the acceleration is -1, initial velocity is V, each step t is a positive integer,
and the acceleration is only changing the velocity at each step t.
Then position x can be calculated like this:
```
p = V + (V-1) + (V-2) + ... + (V-(t-1))
  = V +  V-1  +  V-2  + ... +  V-(t-1)
  = V*t -  1 - 2 - ... - (t-1)
  = V*t - (1 + 2 + ... + (t-1))
  = V*t - (t*(t-1))/2
  = V*t - (t²-t)/2
```
and when we have stepped V times (t = V) we get:
```
t = V
p = V*V - (V²-V)/2
  = V²  - (V²/2 - V/2)
  = V²  -  V²/2 + V/2
  = V²(1 - 1/2) + V/2
  = V²(1/2) + V/2
  = V²/2 + V/2
  = (V² + V)/2
```

### When is position = 0
Find the steps t where position p = 0.
```
p = Vt - (t² - t)/2
0 = Vt - (t² - t)/2
(t²  - t)/2 -  Vt = 0
 t²/2 - t/2 -  Vt = 0
 t²   - t   - 2Vt = 0
 t² - t - 2Vt = 0
 t² - 2Vt - t = 0
 t² - (2Vt + t) = 0
 t² - (2V + 1)t = 0
 t² - (2V+1)t = 0
 t² - 2((2V+1)/2)t = 0
 t² - 2((2V+1)/2)t + ((2V+1)/2)² = ((2V+1)/2)²
(t - ((2V+1)/2))² =     ((2V+1)/2)²
 t - ((2V+1)/2)   = ±√( ((2V+1)/2)² )
 t - ((2V+1)/2)   = ±   ((2V+1)/2)
 t - ((2V+1)/2)   = ±((2V+1)/2)
 t = ((2V+1)/2) ± ((2V+1)/2)

((2V+1)/2) + ((2V+1)/2) = 2((2V+1)/2)
                        = (2V+1)
                        = 2V + 1

 t = 0  or  2V + 1
```
