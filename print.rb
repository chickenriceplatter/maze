def print_maze

  string = "+"

  string << "-+" * maze.first.size
  string << "\n"

  maze.each do |row|

    vertical_walls = ""

    bottom_walls = "+"

    row.each do |cell|

      vertical_walls << "| " if cell.west == 1
      vertical_walls << "  " if cell.west == 0
      bottom_walls << "-+" if cell.south == 1
      bottom_walls << " +" if cell.south == 0

    end

    vertical_walls << "|\n" if row.last.east == 1
    vertical_walls << " \n" if row.last.east == 0
    bottom_walls << "\n"

    string << vertical_walls
    string << bottom_walls

  end

  puts(string)
end
