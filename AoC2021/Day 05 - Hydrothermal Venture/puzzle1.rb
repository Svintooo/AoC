#!/usr/bin/env ruby

filename = ARGV[0]
data     = IO.read(filename)


## PARSING
vents_lines = data.split(/\n/)
                  .collect{|vents_line|
                    vents_line.strip
                              .split(/ *-> */)
                              .collect{|coordinate|
                                coordinate.split(/,/)
                                          .map{|xy| xy.to_i }
                              }
                  }
pp vents_lines #DEBUG


## CALCULATION
## ANSWER
