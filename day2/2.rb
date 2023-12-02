MAX = {"red": 12, "green": 13, "blue": 14}

class Game
  attr_reader :id, :subsets

  def initialize(id, subsets)
    @id = id
    @subsets = subsets
  end

  def possible?
    subsets.each do |subset|
      return false if subset.red.to_i > MAX[:red]
      return false if subset.green.to_i > MAX[:green]
      return false if subset.blue.to_i > MAX[:blue]
    end
    true
  end

  def power_of_min_cubes_needed
    min_cubes_needed.power
  end

  private

  def min_cubes_needed
    min_needed = {"red": 0, "green": 0, "blue": 0}
    subsets.each do |subset|
      subset = subset.to_h
      subset.keys.each { |key| min_needed[key] = subset[key] if subset[key] > min_needed[key] }
    end
    
    Subset.new(min_needed[:red], min_needed[:green], min_needed[:blue])
  end
end

class Subset
  attr_reader :red, :green, :blue

  def initialize(red, green, blue)
    @red = red.to_i
    @green = green.to_i
    @blue = blue.to_i
  end

  def to_h
    {"red": red, "green": green, "blue": blue}
  end

  def power
    red * green * blue
  end
end

class Input
  attr_reader :line

  def initialize(line)
    @line = line
  end

  def game_id
    line.match(/(?<=Game )\d+/)[0].to_i
  end

  def subsets
    subsets = line.match(/(Game \d+: )(.+)/)[2]
    subsets.split(";").map do |subset|
      red = subset.match(/\d+(?=\sred)/).to_s
      green = subset.match(/\d+(?=\sgreen)/).to_s
      blue = subset.match(/\d+(?=\sblue)/).to_s
      Subset.new(red, green, blue)
    end
  end
end

sum = 0
File.read("input.txt").each_line do |line| 
  input = Input.new(line)
  game = Game.new(input.game_id, input.subsets)
  sum += game.id if game.possible?
end
puts sum

# part 2
sum = 0
File.read("input.txt").each_line do |line| 
  input = Input.new(line)
  game = Game.new(input.game_id, input.subsets)
  sum += game.power_of_min_cubes_needed
end
puts sum