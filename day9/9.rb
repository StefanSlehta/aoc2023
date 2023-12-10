def self.calculate(line, reverse = false)
  line = line.reverse if reverse
  next_diff = line.each_with_index.filter_map { |num, index| num - line[index - 1] unless index == 0 }
  return next_diff + [next_diff.last] if next_diff.uniq.length == 1
  
  return next_diff + [next_diff.last + calculate(next_diff).last]
end

lines = []
File.read("input.txt").each_line { |line| lines << line.split(" ").map(&:to_i) }

puts lines.map { |line| line.last + calculate(line).last }.flatten.sum # part 1
puts lines.map { |line| line.first + calculate(line, true).last }.flatten.sum # part 2