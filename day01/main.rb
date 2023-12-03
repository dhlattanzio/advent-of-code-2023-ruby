data = File.read("day01/input.txt").lines chomp: true

part1 = data.map { |x| x.gsub(/[^0-9]/, '') }
             .map { |x| "#{x[0]}#{x[-1]}".to_i }
             .sum

puts "Part 1: #{part1}"

numbers = {
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9
}

letters = data.map do |x|
  tmp = []
  numbers.each do |k, v|
    curr = -1
    begin
      curr = x.index(k.to_s, curr + 1)
      tmp << [curr, v] if curr != nil
    end while curr != nil
  end

  a = x
  tmp.each { |y| a = a[0...y[0]] + y[1].to_s + a[y[0] + 1..-1] }
  a
end

part2 = letters.map { |x| x.gsub(/[^0-9]/, '') }
               .map { |x| "#{x[0]}#{x[-1]}".to_i }
               .sum

puts "Part 2: #{part2}"