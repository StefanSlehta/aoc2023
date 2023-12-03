require 'pry'

class Engine
  def initialize(schematics)
    @schematics = schematics
  end
  
  def part_sum
    sum = 0
    @schematics.each_with_index do |row, i|
      going_num = ""
      add_to_sum = false
      row.each_with_index do |col, j|
        num = col.match(/\d/)
        going_num << num.to_s

        add_to_sum ||= add_to_sum?(i, j) if !num.nil?
        if (num.nil? || j == row.length - 1) && !going_num.empty?
          sum += going_num.to_i if add_to_sum
          going_num = ""
          add_to_sum = false
        end
      end
    end
    sum
  end

  def gear_sum
    gear_coords = []
    numbers_coords = []
    @schematics.each_with_index do |row, i|
      row.join("").enum_for(:scan, /\d+/).each do |m|
        last_match = Regexp.last_match
        numbers_coords << { "num": last_match.to_s.to_i, "i": i, "j": Range.new(last_match.begin(0), last_match.end(0) - 1) }
      end
      row.each_with_index do |col, j|
        gear_coords << {"i": i, "j": j} if col == "*"
      end
    end

    sum = 0
    gear_coords.each do |gear_coord|
      total_touches = 0
      touching_index = []
      numbers_coords.each_with_index do |number_coord, index|
        row_cover = Range.new(gear_coord[:i] - 1, gear_coord[:i] + 1)
        if row_cover.include?(number_coord[:i])
          if number_coord[:j].cover?(gear_coord[:j]) || number_coord[:j].cover?(gear_coord[:j] + 1) || number_coord[:j].cover?(gear_coord[:j] - 1)
            total_touches += 1
            touching_index << index
          end
        end
      end
      if total_touches == 2
        sum += numbers_coords[touching_index[0]][:num] * numbers_coords[touching_index[1]][:num]
      end
    end

    sum
  end

  private

  def add_to_sum?(i, j)
    symbol_regex =/[^.0-9]/
    if i + 1 < @schematics.length
      return true if @schematics[i + 1][j].match(symbol_regex)
      if j + 1 < @schematics[i].length
        return true if @schematics[i + 1][j + 1].match(symbol_regex)
      end
      if j - 1 >= 0
        return true if @schematics[i + 1][j - 1].match(symbol_regex)
      end
    end
    if j + 1 < @schematics[i].length
      return true if @schematics[i][j + 1].match(symbol_regex)
    end
    if j - 1 >= 0
      return true if @schematics[i][j - 1].match(symbol_regex)
    end
    if i - 1 >= 0
      return true if @schematics[i - 1][j].match(symbol_regex)
      if j + 1 < @schematics[i].length
        return true if @schematics[i - 1][j + 1].match(symbol_regex)
      end
      if j - 1 >= 0
        return true if @schematics[i - 1][j - 1].match(symbol_regex)
      end
    end
    
    false
  end
end

engine_schematics = []
File.read("input.txt").each_line { |line| engine_schematics << line.strip.split("") }

engine = Engine.new(engine_schematics)
puts engine.part_sum # Part 1
puts engine.gear_sum # part 2