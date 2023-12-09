data = File.read("day08/input.txt").lines(chomp: true)

inst = data[0].split("")
network = data[2..-1].map { |n| n.split(" = ") }
                     .map { |n| [n[0], n[1][1...-1].split(", ")] }

map = {}
network.each { |n| map[n[0]] = n[1] }

def get_required_steps(inst, map, node, i = 0, end_node = "Z")
  if map[node].nil?
    return -1
  end

  total = 0
  until node.end_with? end_node
    move = inst[i] == "L" ? 0 : 1
    curr = map[node]
    node = curr[move]

    i = (i + 1) % inst.length
    total += 1
  end

  total
end

part1 = get_required_steps(inst, map, "AAA")
puts "Part 1: #{part1}"

starts = network.select { |n| n[0].end_with? "A" }.map { |n| n[0] }

steps = {}
starts.each do |s|
  steps[s] = get_required_steps(inst, map, s)
end

part2 =  steps.values.to_a.reduce(1, :lcm)
puts "Part 2: #{part2}"