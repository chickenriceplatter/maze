require 'pry'

class Cell

  attr_accessor :north, :south, :west, :east, :coordinate

  def initialize(coordinate)
    @coordinate = coordinate
    @north = 1
    @south = 1
    @west = 1
    @east = 1
  end

  def left
    [coordinate.first - 1, coordinate.last]
  end

  def right
    [coordinate.first + 1, coordinate.last]
  end

  def above
    [coordinate.first, coordinate.last - 1]
  end

  def below
    [coordinate.first, coordinate.last + 1]
  end

end

class Maze

  attr_reader :x_size, :y_size, :number_of_cells
  attr_accessor :maze


  def initialize(x, y)
    @x_size = x
    @y_size = y
    @number_of_cells = x*y

    @maze = []

    (0...y_size).each do |y_coordinate|

      row = []

      (0...x_size).each do |x_coordinate|
        row << Cell.new([x_coordinate, y_coordinate])
      end

      maze << row
    end
  end

  def create_maze

    random_x = (0...x_size).to_a.sample
    random_y = (0...y_size).to_a.sample

    visited = []
    path = []

    start_coordinate = [random_x, random_y]

    visited << start_coordinate
    path << start_coordinate

    while(visited.size < number_of_cells)

      choices = find_neighbors(path.last, visited)

      if choices.size > 0
        choice = choices.sample
        join(path.last, choice)
        visited << choice
        path << choice
      else
        path.pop
      end

    end

  end

  # def pound_print_maze

  #   string = ""

  #   string << "#" * maze.first.size
  #   string << "\n"

  #   maze.each do |row|

  #     vertical_walls = ""

  #     bottom_walls = ""

  #     row.each do |cell|

  #       vertical_walls << "#" if cell.west == 1
  #       vertical_walls << " " if cell.west == 0
  #       bottom_walls << "#" if cell.south == 1
  #       bottom_walls << " " if cell.south == 0

  #     end

  #     vertical_walls << "\n"
  #     bottom_walls << "\n"

  #     string << vertical_walls
  #     string << bottom_walls

  #   end

  #   puts(string)
  # end

  def pound_print_maze

    string = "#"

    string << "##" * maze.first.size
    string << "\n"

    maze.each do |row|

      vertical_walls = ""

      bottom_walls = "#"

      row.each do |cell|

        vertical_walls << "# " if cell.west == 1
        vertical_walls << "  " if cell.west == 0
        bottom_walls << "##" if cell.south == 1
        bottom_walls << " #" if cell.south == 0

      end

      vertical_walls << "#\n" if row.last.east == 1
      vertical_walls << " \n" if row.last.east == 0
      bottom_walls << "\n"

      string << vertical_walls
      string << bottom_walls

    end

    outfile = File.open("maze.txt", "w")
    outfile.write(string)
    outfile.close
  end


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

  def pretty_print_maze

    string = "+"

    string << "---+" * maze.first.size
    string << "\n"

    maze.each do |row|

      vertical_walls = ""

      bottom_walls = "+"

      row.each do |cell|

        vertical_walls << "|   " if cell.west == 1
        vertical_walls << "    " if cell.west == 0
        bottom_walls << "---+" if cell.south == 1
        bottom_walls << "   +" if cell.south == 0

      end

      vertical_walls << "|\n" if row.last.east == 1
      vertical_walls << " \n" if row.last.east == 0
      bottom_walls << "\n"

      string << vertical_walls
      string << bottom_walls

    end

    puts(string)
  end


  def join(coordinate1, coordinate2)
    cell1 = maze[coordinate1.last][coordinate1.first]
    cell2 = maze[coordinate2.last][coordinate2.first]

    if cell1.coordinate == cell2.left
      cell1.east = 0
      cell2.west = 0
    end

    if cell1.coordinate == cell2.right
      cell1.west = 0
      cell2.east = 0
    end

    if cell1.coordinate == cell2.above
      cell1.south = 0
      cell2.north = 0
    end

    if cell1.coordinate == cell2.below
      cell1.north = 0
      cell2.south = 0
    end
  end

  def find_neighbors(coordinate, visited)

    x = coordinate.first
    y = coordinate.last

    left = [x-1, y]
    right = [x+1, y]
    above = [x, y-1]
    below = [x, y+1]

    options = []

    options << left if (x-1 >= 0) && !visited.include?(left)
    options << right if (x+1 < x_size) && !visited.include?(right)
    options << above if (y-1 >= 0) && !visited.include?(above)
    options << below if (y+1 < y_size) && !visited.include?(below)

    options

  end

end


puts "What is the horizontal size of the maze you want to generate? (Enter a positive integer):"
x_size = gets.chomp.to_i
puts "What is the Vertical size of the maze you want to generate? (Enter a positive integer):"
y_size = gets.chomp.to_i

m = Maze.new(x_size, y_size)
m.create_maze


puts "\npretty print"
m.pretty_print_maze
puts "\npound print"
m.pound_print_maze
`cat maze.txt`
puts "\nregular print"
m.print_maze

