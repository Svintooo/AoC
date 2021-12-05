#!/usr/bin/env ruby

filename = ARGV[0]
data     = IO.read(filename)


## PARSING
bingo_numbers, data = data.split(/\n\n/, 2)
bingo_numbers = bingo_numbers.split(',').map(&:to_i)
#p bingo_numbers #DEBUG

bingo_boards = data.split(/\n\n/)
                   .collect{|board|
                     board.split(/\n/)
                          .collect{|row| row.strip.split(/\s+/).collect{|n| n.to_i } }
                   }
#pp bingo_boards           #DEBUG
#pp bingo_boards[1]        #DEBUG
#pp bingo_boards[0] [1][3] #DEBUG
#exit                      #DEBUG


## CALCULATION
winning_board_id = nil
last_bingo_number = nil

catch :BINGO do
  bingo_numbers.each{|bingo_number|
    # Mark numbers equal to bingo_number
    bingo_boards.each do |bingo_board|
      bingo_board.each{|row|
        row.each_with_index{|number, row_id| row[row_id] = :x if number == bingo_number }
      }
    end

    # Check all boards for BINGO
    bingo_boards.each_with_index do |bingo_board, board_id|
      column_bingo = [:x,:x,:x,:x,:x]

      bingo_board.each{|row|
        # Check if a row has BINGO
        if row.all?{|n| n == :x}
          winning_board_id = board_id
          last_bingo_number = bingo_number
          throw :BINGO
        end

        row.each_with_index{|number, row_id|
          column_bingo[row_id] = nil if number != :x
        }
      }

      # Check if a column has BINGO
      if column_bingo.any?{|n| n == :x}
        winning_board_id = board_id
        last_bingo_number = bingo_number
        throw :BINGO
      end
    end
  }
end

#p last_bingo_number               #DEBUG
#p winning_board_id                #DEBUG
#pp bingo_boards[winning_board_id] #DEBUG

unmarked_numbers_sum = bingo_boards[winning_board_id].flatten
                                                     .reject{|n|n==:x}
                                                     .sum
#p unmarked_numbers_sum            #DEBUG

answer = unmarked_numbers_sum * last_bingo_number
puts answer
