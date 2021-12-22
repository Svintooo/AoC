# image enhancement algorithm
algorithm = "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#"
algorithm = algorithm.chars


# input image
input_image = "#..#." +"\n"+
              "#...." +"\n"+
              "##..#" +"\n"+
              "..#.." +"\n"+
              "..###"
input_image = input_image.lines.map{|line| line.strip.chars }
input_image.each{|line| puts line.join };puts#PRINT


output_image = input_image

2.times do
  work_image = output_image.map{|line| ["."]+line+["."] }
  work_image.unshift Array.new(work_image[0].length, ".")
  work_image.push    Array.new(work_image[0].length, ".")
  #work_image.each{|line| puts line.join };puts#PRINT

  output_image = work_image.map{|line| Array.new(line.length, ".") }
  #work_image.each{|line| puts line.join };puts#PRINT

  m=work_image.length-1
  work_image.each_with_index do |line, i|
    w=line.length-1
    line.each_index do |j|
      index = [[],[],[]]
      index[0][0] = (i==0||j==0) ? (".") : (work_image[i-1][j-1])
      index[0][1] = (i==0      ) ? (".") : (work_image[i-1][j  ])
      index[0][2] = (i==0||j==w) ? (".") : (work_image[i-1][j+1])
      index[1][0] = (      j==0) ? (".") : (work_image[i  ][j-1])
      index[1][1] =                        (work_image[i  ][j  ])
      index[1][2] = (      j==w) ? (".") : (work_image[i  ][j+1])
      index[2][0] = (i==m||j==0) ? (".") : (work_image[i+1][j-1])
      index[2][1] = (i==m      ) ? (".") : (work_image[i+1][j  ])
      index[2][2] = (i==m||j==w) ? (".") : (work_image[i+1][j+1])

      index = index.flatten.map{|char| char=="." ? 0 : 1 }.join.to_i(2)
      output_image[i][j] = algorithm[index]
    end
  end

  output_image.each{|line| puts line.join };puts#PRINT
end




