# INFO
This puzzle solution is implemented in Ruby (www.ruby-lang.org).

# HOW TO USE
- Install ruby.
- Download the puzzle input to a file namned `input` (https://adventofcode.com/2021/day/16/input).
- For puzzle 1, run: `ruby puzzle1.rb input`
- For puzzle 2, run: `ruby puzzle2.rb input`

# RANT
This puzzle should realy be solved with recursive functions IMO. The code should end up easy-to-read and understand.

I did not do that. Because I am used to code iterative solutions. The code complexity suffered as a consequence.

I also almost didn't finish puzzle2 before day end because of one tiny misunderstanding: when "length type ID" represents a count for the number of packages, I thought all sub-packages was included, not only the ones right under the package.

  package1       <- This package includes 2 packages
    package1.1      <- This package is included in the count for package1
    package1.2      <- Also this one
      package1.2.1  <- BUT not this one.

Because of this error the parser failed to parse the input, even though it worked great for all the example inputs that the puzzle provided.
