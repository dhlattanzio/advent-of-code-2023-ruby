data = File.read("day09/input.txt").lines(chomp: true).map { |x| x.split(" ").map { |n| n.to_i } }

def extrapolate(nums)
  curr = [nums]

  while curr[-1].any? { |x| x != 0 }
    tmp = []
    (1...curr[-1].length).each do |x|
      tmp.push(curr[-1][x] - curr[-1][x-1])
    end
    curr.push(tmp)
  end

  new_value = 0
  (0...curr.length-1).each do |x|
    new_value += curr[x][-1]
  end

  new_value
end

part1 = []
data.each do |x|
  r = extrapolate x
  part1.push r
end

puts "Part 1: #{part1.sum}"

def extrapolate_left(nums)
  curr = [nums]

  while curr[-1].any? { |x| x != 0 }
    tmp = []
    (1...curr[-1].length).each do |x|
      tmp.push(curr[-1][x] - curr[-1][x-1])
    end
    curr.push(tmp)
  end

  new_value = 0
  (curr.length-1..0).step(-1).each do |x|
    new_value = curr[x][0] - new_value
  end

  new_value
end

part2 = []
data.each do |x|
  r = extrapolate_left x
  part2.push r
end

puts "Part 2: #{part2.sum}"