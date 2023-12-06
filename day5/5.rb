class Map
  attr_reader :source, :destination, :hash
  def initialize(source, destination, hash)
    @source = source
    @destination = destination
    @hash = hash
  end

  def location(num)
    where = @hash.keys.find { |k| k.member?(num) }
    return num if where.nil?

    @hash[where].begin + (num - where.begin)
  end
end

seeds = []
last_s, last_d = []
maps = {}
hash = {}
File.read("input.txt").each_line do |line|
  seeds = line.scan(/\d+/).map(&:to_i) if seeds.empty?

  if line.strip.empty? && !last_s.nil?
    maps[last_s] = Map.new(last_s, last_d, hash)
    hash = {}
  end

  sd = line.match(/(\w+)-to-(\w+)/)
  source, destination = sd.captures if sd
  if source && destination
    last_s, last_d = [source, destination] 
    next
  end

  if line.scan(/\d+/).size == 3
    destination_num, source_num, range = line.scan(/\d+/).map(&:to_i)
    hash[(source_num..(source_num + range - 1))] = (destination_num..(destination_num + range - 1)) if destination_num
  end
  # (source_num..range - 1).each_with_index { |num, i| hash[num] = destination_num + i }
end
maps[last_s] = Map.new(last_s, last_d, hash)


seed_ranges = []
seeds.each_slice(2) { |a, b| seed_ranges << (a..(a+ b - 1)) }
mutex = Mutex.new
min = 9999999999999999999999
seed_ranges.map do |range|
  Thread.new do
    range.each do |seed|
      loc = maps.values.first.location(seed)
      maps.values[1..maps.values.size].each do |map|
        loc = map.location(loc)
      end
      mutex.synchronize do
        min = loc if loc < min
      end
    end
  end
end.each(&:join)

puts min