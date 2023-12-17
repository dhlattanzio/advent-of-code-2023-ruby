data = File.read("day16/input.txt").lines(chomp: true).map { |x| x.split("") }

def process(layout, x = 0, y = 0, sx = 1, sy = 0, result = nil, mem = {})
  if x < 0 or x >= layout[0].length or y < 0 or y >= layout.length
    return result
  end

  if result.nil?
    result = Array.new(layout.length) { Array.new(layout[0].length) {"."} }
  end

  key = "#{x},#{y},#{sx},#{sy}"
  if mem.has_key? key
    return result
  end

  mem[key] = true
  result[y][x] = "#"

  symbol = layout[y][x]

  if symbol == "."
    process(layout, x + sx, y + sy, sx, sy, result, mem)
  elsif symbol == "|"
    if sx != 0
      process(layout, x, y + 1, 0, 1, result, mem)
      process(layout, x, y - 1, 0, -1, result, mem)
    else
      process(layout, x, y + sy, sx, sy, result, mem)
    end
  elsif symbol == "-"
    if sy != 0
      process(layout, x - 1, y, -1, 0, result, mem)
      process(layout, x + 1, y, 1, 0, result, mem)
    else
      process(layout, x + sx, y, sx, sy, result, mem)
    end
  elsif  symbol == "/"
    if sx < 0
      process(layout, x, y + 1, 0, 1, result, mem)
    elsif sx > 0
      process(layout, x, y - 1, 0, -1, result, mem)
    elsif sy > 0
      process(layout, x - 1, y, -1, 0, result, mem)
    else
      process(layout, x + 1, y, 1, 0, result, mem)
    end
  elsif symbol == "\\"
    if sx < 0
      process(layout, x, y - 1, 0, -1, result, mem)
    elsif sx > 0
      process(layout, x, y + 1, 0, 1, result, mem)
    elsif sy > 0
      process(layout, x + 1, y, 1, 0, result, mem)
    else
      process(layout, x - 1, y, -1, 0, result, mem)
    end
  end

  result
end

def draw_layout(layout)
  layout.each do |line|
    line.each do |i|
      print i
    end
    print "\n"
  end
end

def get_total(layout)
  layout.map { |i| i.count { |j| j == "#" } }.sum
end

layout = process(data)
puts "Part 1: #{get_total(layout)}"


results = []
(0...data.length).each do |i|
  results.push(get_total(process(data, 0, i, 1, 0)))
  results.push(get_total(process(data, data[0].length - 1, i, -1, 0)))
end

(0...data[0].length).each do |i|
  results.push(get_total(process(data, i, 0, 0, 1)))
  results.push(get_total(process(data, i, data.length - 1, 0, -1)))
end

puts "Part 2: #{results.max}"