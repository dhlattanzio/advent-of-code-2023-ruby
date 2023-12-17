data = File.read("day12/input.txt").lines(chomp: true)
           .map { |x| [x.split[0], x.split[1].split(",").map { |i| i.to_i }] }

def validate(row, rules)
  parts = row.split(/\.+/).select { |x| x != "" }

  if parts.length != rules.length
    return false
  end

  (0...rules.length).each do |i|
    if parts[i].length != rules[i]
      return false
    end
  end

  true
end

def get_total(row, rules, index = 0, mem = {})
  key = "#{row[index..-1]}"
  if mem.has_key?(key)
    return mem[key]
  end

  options = row.count "?"

  if options == 0
    return validate(row, rules) ? 1 : 0
  end

  index = row.index("?") -1
  total = get_total(row.sub("?", "."), rules, index, mem)
  total += get_total(row.sub("?", "#"), rules, index, mem)

  mem[key] = total
  total
end

#
counter = 0
part1 = 0
data.each do |i|
  counter += 1
  part1 += get_total(i[0], i[1])
  puts "#{counter}/#{data.length}"
end

puts "Part 1: #{part1}"

return

counter = 0
part2 = 0
data.each do |i|
  a = ((i[0] + "?") * 5)[0...-1]
  b = i[1] * 5

  part2 += get_total(a, b)
  puts "#{counter}/#{data.length}"
end

puts "Part 2: #{part2}"