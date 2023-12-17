data = File.read("day13/input.txt").lines(chomp: true)

mirrors = data.reduce([[]]) do |acc, i|
  if i == ""
    acc.push([])
  elsif
    acc[-1].push(i.split(""))
  end
  acc
end

def is_col_mirror(pattern, lx, rx)
  errors = 0
  (0..[lx, pattern[0].length - rx - 1].min).each do |i|
    (0...pattern.length).each do |j|
      if pattern[j][lx - i] != pattern[j][rx + i]
        errors += 1
      end
    end
  end

  errors
end

def is_row_mirror(pattern, ty, by)
  errors = 0
  (0..[ty, pattern.length - by - 1].min).each do |i|
    (0...pattern[0].length).each do |j|
      if pattern[ty - i][j] != pattern[by + i][j]
        errors += 1
      end
    end
  end

  errors
end

def get_value(pattern)
  (1...pattern[0].length).each do |i|
    if is_col_mirror(pattern, i-1, i) == 0
      return i
    end
  end

  (1...pattern.length).each do |i|
    if is_row_mirror(pattern, i-1, i) == 0
      return i * 100
    end
  end

  0
end

part1 = mirrors.map { |x| get_value x }.reduce(:+)
puts "Part 1: #{part1}"

def get_value_fixed(pattern)
  (1...pattern.length).each do |i|
    if is_row_mirror(pattern, i-1, i) == 1
      return i * 100
    end
  end

  (1...pattern[0].length).each do |i|
    if is_col_mirror(pattern, i-1, i) == 1
      return i
    end
  end

  0
end

part2 = mirrors.map { |x| get_value_fixed x }.reduce(:+)
puts "Part 2: #{part2}"