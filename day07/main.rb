data = File.read("day07/input.txt").lines(chomp: true)
           .map { |x| x.split }
           .map { |x| [x[0], x[1].to_i] }.to_a

$types = %w[2 3 4 5 6 7 8 9 T J Q K A]

def get_score(hand)
  counters = {}

  hand.split("").each_with_index  do |x, i|
    counters[x] = counters.fetch(x, 0) + 1
  end

  case counters.length
  when 1
    10_000_000
  when 2 # 4;1 3;2
    (counters.values[0] == 4 or counters.values[1] == 4) ? 9_000_000 : 8_000_000
  when 3 # 3;1;1 2;2;1
    counters.values.include?(3) ? 7_000_000 : 6_000_000
  when 4
    4_000_000
  else
    2_000_000
  end
end

def card_compare(c1, c2)
  (0...c1.length).each do |i|
    c1v = $types.index(c1[i])
    c2v = $types.index(c2[i])
    if c1v > c2v
      return 1
    elsif c1v < c2v
      return -1
    end
  end

  0
end

ordered = []
data.each do |x|
  if ordered.empty?
    ordered.push(x)
  else
    added = false
    score = get_score(x[0])
    (0...ordered.length).each do |y|
      other = get_score(ordered[y][0])
      if score < other
        ordered.insert(y, x)
        added = true
        break
      elsif score == other and card_compare(x[0], ordered[y][0]) < 0
        ordered.insert(y, x)
        added = true
        break
      end
    end

    unless added
      ordered.push(x)
    end
  end
end

part1 = 0
ordered.each_with_index { |x, i| part1 += x[1] * (i + 1) }
puts "Part 1: #{part1}"

$types = %w[J 2 3 4 5 6 7 8 9 T Q K A]

def get_score_part2(hand)
  counters = {}

  hand.split("").each_with_index  do |x, i|
    counters[x] = counters.fetch(x, 0) + 1
  end

  j = counters.fetch("J", 0)
  if j > 0 and j != 5
    counters.delete("J")

    best_key = counters.max_by { |k, v| v }[0]
    counters[best_key] = counters[best_key] + j
  end

  case counters.length
  when 1
    10_000_000
  when 2 # 4;1 3;2
    (counters.values[0] == 4 or counters.values[1] == 4) ? 9_000_000 : 8_000_000
  when 3 # 3;1;1 2;2;1
    counters.values.include?(3) ? 7_000_000 : 6_000_000
  when 4
    4_000_000
  else
    2_000_000
  end
end

ordered = []
data.each do |x|
  if ordered.empty?
    ordered.push(x)
  else
    added = false
    score = get_score_part2(x[0])
    (0...ordered.length).each do |y|
      other = get_score_part2(ordered[y][0])
      if score < other
        ordered.insert(y, x)
        added = true
        break
      elsif score == other and card_compare(x[0], ordered[y][0]) < 0
        ordered.insert(y, x)
        added = true
        break
      end
    end

    unless added
      ordered.push(x)
    end
  end
end

part2 = 0
ordered.each_with_index { |x, i| part2 += x[1] * (i + 1) }
puts "Part 2: #{part2}"