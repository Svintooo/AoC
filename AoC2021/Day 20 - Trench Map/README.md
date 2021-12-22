# INFO
This puzzle solution is implemented in Ruby (www.ruby-lang.org).

# HOW TO USE
- Install ruby.
- Download the puzzle input to a file namned `input` (https://adventofcode.com/2021/day/20/input).
- For puzzle 1, run: `ruby puzzle1.rb input`
- For puzzle 2, run: `ruby puzzle2.rb input`

# RANT
This puzzle looked super simple. But it contained a trap which I and many others caught in (at elast one other guy on reddit).

Since the image is infinite you can't just apply the algorithm on the image data. You have to apply the algorithm on the whole infinite image!

In the example input data this was easy. The algorithm converted value 0 to an empty pixel. BUT for the real input the algorithm converted value 0 to a lit pixel (and value MAX to an empty pixel).

It's hard to explain properly, and I'm afraid I didn't manage to figure this out myself. I got my needed clue from this reddit reply:
https://www.reddit.com/r/adventofcode/comments/rm43rr/2021_20_part1python_anyone_finds_the_mistake/hpjrz9o/
