data = File.read("day06/input.txt").lines(chomp: true)
           .map { |x| x.gsub(/[^0-9 ]+/, '').gsub(/ +/, ' ').strip }
           .map { |x| x.split.map { |y| y.to_i } }
           .to_a

races = []
(0...data[0].length).each do |x|
  races.push([data[0][x], data[1][x]])
end

part1 = []
races.each do |x|
  tmp = []
  (1..x[0]).each do |y|
    result = (x[0] - y) * y
    if result > x[1]
      tmp.push(y)
    end
  end

  part1.push(tmp.length)
end

puts "Part 1: #{part1.inject(:*)}"

races = [[data[0].join.to_i, data[1].join.to_i]]

part2 = []
races.each do |x|
  tmp = []
  (1..x[0]).each do |y|
    result = (x[0] - y) * y
    if result > x[1]
      tmp.push(y)
    end
  end

  part2.push(tmp.length)
end

puts "Part 2: #{part2[0]}"