# time, distance = File.read("input.txt").split("\n").map { |line| line.scan(/\d+/).map(&:to_i) } # part 1
time, distance = File.read("in.txt").split("\n").map { |line| line.gsub(/\s+/,"").scan(/\d+/).map(&:to_i) }
m = 1
time.each_with_index do |t,d|
  total = 0
  (0..t).each do |i|
    total += 1 if distance[d] < (t - i) * i
  end
  m *= total
end
puts m