module Converter
  extend self
  MAP = {"one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9}

  def calibration_value_p1(line)
    nums = line.scan(/[1-9]/).map(&:to_i)
    "#{nums.first}#{nums.last}".to_i
  end

  def calibration_value_p2(line)
    indices = line.enum_for(:scan, /((?=[1-9])|(?=one)|(?=two)|(?=three)|(?=four)|(?=five)|(?=six)|(?=seven)|(?=eight)|(?=nine))/).map do
      Regexp.last_match.offset(0).first
    end
    matches = indices.map do |index|
      match = line[index..].match(/[1-9]|#{MAP.keys.join("|")}/).to_s
      if match.to_i > 0
        match.to_i
      else
        MAP[match.to_sym]
      end
    end

    "#{matches.first}#{matches.last}".to_i
  end
end

sum = 0
# File.read("input.txt").each_line { |line| sum += Converter.calibration_value_p1(line.strip) }
File.read("input.txt").each_line { |line| sum += Converter.calibration_value_p2(line.strip) }
puts sum
