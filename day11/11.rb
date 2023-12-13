class Galaxy
  attr_accessor :galaxy, :galaxy_map
  
  def initialize(galaxy)
    @galaxy = galaxy
    @galaxy_map = {}
  end

  def all_distance_sum
    expansion_rate = 1000000 # set to 2 for part 1
    make_galaxy_map(expansion_rate)
    galaxy_map.each do |key, value|
      pos_i, pos_j = value[:pos]
      
      galaxy.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          if cell != '.'
            other_i, other_j = galaxy_map[cell][:pos]
            galaxy_map[key][cell] = (pos_i - other_i).abs + (pos_j - other_j).abs
          end
        end
      end
    end

    sum = 0
    passed = []
    galaxy_map.each do |key, value|
      passed << key
      value.keys.each do |k|
        sum += if k.is_a?(String)
          passed.include?(k) ? 0 : value[k]
        else
          0
        end
      end
    end
    puts sum
  end

  def empty_rows
    rows = []
    galaxy.each_with_index do |row, i|
      rows << i if row.all? { |cell| cell == '.' }
    end
    rows.sort
  end

  def empty_cols
    cols = []
    (0...galaxy[0].length - 1).each do |i|
      cols << i if galaxy.all? { |row| row[i] == '.' }
    end
    cols.sort
  end

  def make_galaxy_map(expansion_rate)
    num = 1
    rows = empty_rows
    cols = empty_cols
    galaxy.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if cell == '#'
          galaxy[i][j] = num.to_s
          galaxy_map[num.to_s] = {}
          
          row_len = rows.select { |row| row < i }.length
          col_len = cols.select { |col| col < j }.length
          i_pos = col_len * expansion_rate
          j_pos = row_len * expansion_rate
          galaxy_map[num.to_s][:pos] = [i_pos - col_len + j, j_pos - row_len + i]
          num += 1
        end
      end
    end
  end
end

galaxy = []
File.read('input.txt').each_line { |line| galaxy << line.strip.split('') }

galaxy = Galaxy.new(galaxy)
galaxy.all_distance_sum

