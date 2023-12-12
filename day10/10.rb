class MazeRunner
  attr_accessor :maze, :initial_i, :initial_j, :path

  def initialize(maze, start_i, start_j, path = [])
    @maze = maze
    @initial_i = start_i
    @initial_j = start_j
    @path = path
    @visited = {}
  end

  def find_path(start_i, start_j, curr_i, curr_j)
    if curr_i < 0 || curr_j < 0 || curr_i >= maze.length || curr_j >= maze[curr_i].length || maze[curr_i][curr_j] == "." || @visited["#{curr_i},#{curr_j}"]
      return path
    end

    current = maze[curr_i][curr_j]
    @visited["#{curr_i},#{curr_j}"] = true
    path << { i: curr_i, j: curr_j, pipe: current }
    return path if current == "S"

    if current == "F"
      if curr_j < start_j
        find_path(curr_i, curr_j, curr_i + 1, curr_j)
      elsif curr_i < start_i
        find_path(curr_i, curr_j, curr_i, curr_j + 1)
      end
    elsif current == "|"
      if curr_i < start_i
         find_path(curr_i, curr_j, curr_i - 1, curr_j)
      elsif curr_i > start_i
        find_path(curr_i, curr_j, curr_i + 1, curr_j)
      end
    elsif current == "-"
      if curr_j > start_j
         find_path(curr_i, curr_j, curr_i, curr_j + 1)
      elsif curr_j < start_j
        find_path(curr_i, curr_j, curr_i, curr_j - 1)
      end
    elsif current == "J"
      if start_j < curr_j
        find_path(curr_i, curr_j, curr_i - 1, curr_j)
      elsif curr_i > start_i
        find_path(curr_i, curr_j, curr_i, curr_j - 1)
      end
    elsif current == "7"
      if start_j < curr_j
        find_path(curr_i, curr_j, curr_i + 1, curr_j)
      elsif curr_i < start_i
        find_path(curr_i, curr_j, curr_i, curr_j - 1)
      end
    elsif current == "L"
      if curr_j < start_j
         find_path(curr_i, curr_j, curr_i - 1, curr_j)
      elsif start_i < curr_i
        find_path(curr_i, curr_j, curr_i, curr_j + 1)
      end
    end

    path.pop if path.last[:pipe] != "S"
    path
  end

  def flood(i, j, internal = false)
    return if i < 0 || j < 0 || i >= maze.length || j >= maze[i].length || @visited["#{i},#{j}"] || on_path?(i, j)

    current = maze[i][j]
    maze[i][j] = internal ? "I" : "O"
    @visited["#{i},#{j}"] = true

    flood(i + 1, j, internal)
    flood(i - 1, j, internal)
    flood(i, j + 1, internal)
    flood(i, j - 1, internal)
  end

  def on_path?(i, j)
    path.any? { |p| p[:i] == i && p[:j] == j }
  end
end

maze = []
s_i, s_j = 0, 0
File.read("input.txt").each_line do |line| 
  l = line.split("") 
  maze << l
  s_i, s_j = maze.length - 1, l.index("S") if l.include?("S")
end

maze_runner = MazeRunner.new(maze, s_i, s_j)
paths = [
  maze_runner.find_path(s_i, s_j, s_i, s_j + 1),
  maze_runner.find_path(s_i, s_j, s_i, s_j - 1),
  maze_runner.find_path(s_i, s_j, s_i + 1, s_j),
  maze_runner.find_path(s_i, s_j, s_i - 1, s_j)
]
max_path = paths.sort_by(&:length).last
puts (max_path.length + 1)/ 2

flood_fill = MazeRunner.new(maze, s_i, s_j, max_path)

# mark outside ground
(0...maze.length).each do |i|
  flood_fill.flood(i, 0)
  flood_fill.flood(0, i)
  flood_fill.flood(maze.length - 1, i)
  flood_fill.flood(i, maze[0].length - 1)
end

inside = 0
maze.each_with_index do |row, i|
  start_wall = ""
  count = 0 
  row.each_with_index do |col, j|
    next if maze[i][j] == "O"

    if flood_fill.on_path?(i, j)
      c = maze[i][j]
      if c == "|"
        count += 1
      elsif c == "F" || c == "L"
        start_wall = c
      elsif c == "7"
        count += 1 if start_wall == "L"
        start_wall = ""
      elsif c == "J"
        count += 1 if start_wall == "F"
        start_wall = ""
      end
    else
      inside += count % 2
      start_wall = ""
    end
  end
end

puts inside