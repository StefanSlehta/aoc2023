str = ""
l = 0
map = {}
File.read("input.txt").each_line do |line|
  str = line.strip if l == 0
  l+=1
  next if line.strip.empty? || l == 1
  entry, from, to = line.strip.match(/(\w+) = \((\w+), (\w+)/).captures
  map["#{entry}"] = {'L': from, 'R': to}
end
# part 1
# i = 0
# n = "AAA"
# while true do
#   step = str[i % str.length].to_sym
#   i+=1
#   n = map[n][step]
#   break if n == 'ZZZ'
# end
# puts i

# part 2
start = map.keys.select{|k| k[2] == 'A'}
cycles = {}
start.each do |k|
  cycles[k] = {k => 0}
  p = k
  i = 0
  while true do
    index = i % str.length
    step = str[index]
    i+=1
    p = map[p][step.to_sym]
    if cycles[k][p].nil?
      cycles[k].merge!({p => [i]})
    else
      cycles[k][p] << i
      break if p[2] == 'Z' && cycles[k][p].length > 1
    end
  end
end

result = cycles.map do |k, v|
  last = v.keys.find { |key| key[2] == 'Z' }
  v[last].first
end.reduce(1) { |acc, n| acc.lcm(n) }
puts result