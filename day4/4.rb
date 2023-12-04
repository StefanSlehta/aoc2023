sum = 0
cards = {}
File.read("input.txt").each_line.with_index do |line, index|
  winning, my = line.strip.split(": ")[1].split(" | ").map { |n| n.split(" ").map(&:to_i) }
  nums_guessed = winning.size - (winning - my).size
  sum += 2**(nums_guessed - 1) if nums_guessed - 1 >= 0
  # part 2
  cards[index] ||= 1
  (1..nums_guessed).each { |i| cards[index + i] ||= 1; cards[index + i] += cards[index] }
end
puts sum # part 1
puts cards.values.inject(:+) # part 2