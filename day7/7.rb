CARDS = %w(J 2 3 4 5 6 7 8 9 T Q K A)
STRENGTHS = %w(high_card one_pair two_pairs three_of_a_kind full_house four_of_a_kind five_of_a_kind)

class Card
  include Comparable
  
  attr_reader :card
  
  def initialize(card)
    @card = card
  end

  def <=>(other)
    CARDS.find_index(card) <=> CARDS.find_index(other.card)
  end
end

class Hand
  attr_reader :cards, :bet
  
  def initialize(cards, bet)
    @cards = cards
    @bet = bet
  end

  def <=>(other)
    my_hand = STRENGTHS.find_index(self.kind)
    other_hand = STRENGTHS.find_index(other.kind)
    if my_hand == other_hand
      self.cards.each_with_index do |card, index|
        next if card.card == other.cards[index].card
          
        return card <=> other.cards[index]
      end
    else
      my_hand <=> other_hand
    end
  end

  def kind
    map = cards.map(&:card).group_by(&:itself).map { |k, v| [k, v.size] }.to_h
    keys = map.keys
    if keys.size == 1
      "five_of_a_kind"
    elsif keys.size == 2
      if keys.include?("J")
        "five_of_a_kind"
      elsif map.values.include?(3)
        "full_house"
      else
        "four_of_a_kind"
      end
    elsif keys.size == 3
      if map["J"] == 3 || map["J"] == 2
        "four_of_a_kind"
      elsif map["J"] == 1
        if map.values.include?(3)
          "four_of_a_kind"
        else
          "full_house"
        end
      else
        if map.values.include?(3)
          "three_of_a_kind"
        else
          "two_pairs"
        end
      end
    elsif keys.size == 4
      if keys.include?("J")
        "three_of_a_kind"
      else
        "one_pair"
      end
    else
      if keys.include?("J")
        "one_pair"
      else
        "high_card"
      end
    end
  end
end

hands = []
File.read("input.txt").each_line do |line|
  input = line.split(" ")
  hand = Hand.new(input[0].split("").map { |card| Card.new(card) }, input[1].to_i)
  hands << hand
end

sum = 0 
hands.sort.each_with_index do |hand, index|
  sum += hand.bet * (index + 1)
end
puts sum