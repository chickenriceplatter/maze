require 'pry'

class Solver

  attr_accessor :visited, :path, :queue, :maze, :width, :height, :solution_path

  attr_reader :maze_string

  def initialize(maze_string)
    @maze_string = maze_string
    @maze = @maze_string.split("\n")
    @maze.map!{ |each| each.split(//) }
    @width = @maze.first.size - 2
    @height = @maze.size - 2
    @path = {}
    @visited = []
    @queue = []
    @solution_path = []
  end

  def reset_maze
    @maze = @maze_string.split("\n")
    @maze.map!{ |each| each.split(//) }
  end

  def up(location)
    [location.first - 1, location.last]
  end

  def down(location)
    [location.first + 1, location.last]
  end

  def left(location)
    [location.first, location.last - 1]
  end

  def right(location)
    [location.first, location.last + 1]
  end

  def find_available_paths(location)
    output = []

    north = up(location)
    south = down(location)
    west = left(location)
    east = right(location)

    output << north if !visited.include?(north) && maze[north.first][north.last] != "#"
    output << south if !visited.include?(south) && maze[south.first][south.last] != "#"
    output << west if !visited.include?(west) && maze[west.first][west.last] != "#"
    output << east if !visited.include?(east) && maze[east.first][east.last] != "#"

    output
  end

  def print_maze

    output_string = maze.map{ |each| each.join }
    output_string = output_string.join("\n")

    puts output_string
  end


  def solve

    current_location = [1,1]

    visited << current_location

    maze[current_location.first][current_location.last] = "o"

    while !visited.include?([height, width])

      paths = find_available_paths(current_location)

      paths.each{ |loc| queue << loc } unless paths.size == 0

      path[current_location] = paths unless paths.size == 0

      current_location = queue.pop

      visited << current_location

      maze[current_location.first][current_location.last] = "o"

      # print_maze
      # sleep 1/250.0
    end

  end

  def find_previous_step(location)

    output = []

    path.each do |k,v|

      output << k if v.include?(location)

      # return k if v.include?(location)

    end

    output

  end

  def retrace_path

    current_location = [height, width]

    solution_path << current_location

    while current_location != nil

      current_location = find_previous_step(current_location).first

      puts current_location

      solution_path << current_location unless current_location.nil?
    end

    reset_maze

    solution_path.reverse.each do |coordinate|

      maze[coordinate.first][coordinate.last] = "."

      print_maze
      sleep 1/100.0

    end
  end

end

string = File.read("maze.txt")

s = Solver.new(string)
s.solve
s.retrace_path




