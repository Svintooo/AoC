# INFO
This puzzle solution is implemented in Ruby (www.ruby-lang.org).

# HOW TO USE
- Install ruby.
- Download the puzzle input to a file namned `input` (https://adventofcode.com/2021/day/15/input).
- For puzzle 1, run: `ruby puzzle1.rb input`
- For puzzle 2, run: `ruby puzzle2.rb input`

# RANT
The puzzles of today was all about pathfinding. I have never used or written a pathfinding algorithm before.

In the end I just garbled some code together to make pathfinding work. I also felt the pathfinding code needed a priority queue so I crudely made one up.

I continued to hack on the code until it worked. Then I hacked a little bit more to optimize it enough for it to finish executing in a couple of seconds for puzzle 1.

For puzzle 2 I got lucky! The code actually managed to finish executing after 10-20 minutes. I had some plans to try parallelize the code to make it quicker, but in the end I didn't have to.

The code is a mess. It made sense at the time, but I don't expect me to understand this code if I look back to it after a while.
