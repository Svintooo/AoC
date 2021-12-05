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
winning_board_ids = []
last_bingo_number = nil

bingo_numbers.each{|bingo_number|
  # Mark numbers equal to bingo_number
  bingo_boards.each_with_index do |bingo_board, board_id|
    next if winning_board_ids.include?(board_id)
    bingo_board.each{|row|
      row.each_with_index{|number, row_id| row[row_id] = :x if number == bingo_number }
    }
  end

  # Check all boards for BINGO
  bingo_boards.each_with_index do |bingo_board, board_id|
    catch :BINGO do
      next if winning_board_ids.include?(board_id)
      column_bingo = [:x,:x,:x,:x,:x]

      bingo_board.each{|row|
        # Check if a row has BINGO
        if row.all?{|n| n == :x}
          winning_board_ids << board_id
          throw :BINGO
        end

        row.each_with_index{|number, row_id|
          column_bingo[row_id] = nil if number != :x
        }
      }

      # Check if a column has BINGO
      if column_bingo.any?{|n| n == :x}
        winning_board_ids << board_id
        throw :BINGO
      end
    end
  end

  if winning_board_ids.count >= bingo_boards.count
    last_bingo_number = bingo_number
    break
  end
}

losing_board_id = winning_board_ids.last

#p last_bingo_number               #DEBUG
#p losing_board_id                 #DEBUG
#pp bingo_boards[losing_board_id]  #DEBUG

unmarked_numbers_sum = bingo_boards[losing_board_id].flatten
                                                    .reject{|n|n==:x}
                                                    .sum
#p unmarked_numbers_sum            #DEBUG

answer = unmarked_numbers_sum * last_bingo_number
puts answer
