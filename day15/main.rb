data = File.read("day15/input.txt").lines(chomp: true)[0].split(",")

def hash_word(word)
  total = 0
  word.split("").each do |c|
    total += c.ord
    total *= 17
    total = total % 256
  end
  total
end

part1 = data.map { |x| hash_word(x) }.sum
puts "Part 1: #{part1}"

boxes = Array.new(256) {{}}

data.each do |x|
  if x.end_with? "-"
    lens = x[0...-1]
    box = hash_word(lens)

    boxes[box].delete(lens)
  else
    split = x.split("=")
    lens = split[0]
    box = hash_word(lens)
    value = split[1].to_i

    boxes[box][lens] = value
  end
end

part2 = 0
boxes.each_with_index do |box, i|
  if box.length > 0
    box.each_with_index do |b, j|
      part2 += (i + 1) * (j + 1) * b[1]
    end
  end
end

puts "Part 2: #{part2}"