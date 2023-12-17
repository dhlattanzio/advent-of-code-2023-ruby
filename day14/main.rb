data = File.read("day14/input.txt").lines(chomp: true).map { |x| x.split("") }
part2_data = Marshal.load(Marshal.dump(data))

def draw_map(rocks)
  rocks.each do |y|
    y.each do |x|
      print x
    end
    print "\n"
  end
end

def tilt_lever(rocks)
  (0...rocks[0].length).each do |x|
    (1...rocks.length).each do |y|
      if rocks[y][x] == "O" and rocks[y-1][x] == "."
        (1..y).each do |i|
          if y-i == 0 or rocks[y-i-1][x] == "O" or rocks[y-i-1][x] == "#"
            rocks[y-i][x] = "O"
            break
          end
        end
        rocks[y][x] = "."
      end
    end
  end

  rocks
end

def get_total(rocks)
  total = 0
  (0...rocks.length).each do |y|
    (0...rocks[y].length).each do |x|
      if rocks[y][x] == "O"
        total += rocks.length - y
      end
    end
  end

  total
end

tilt_lever(data)
puts "Part 1: #{get_total(data)}"

def roll_rocks_north(rocks)
  (0...rocks[0].length).each do |x|
    (1...rocks.length).each do |y|
      if rocks[y][x] == "O" and rocks[y-1][x] == "."
        (1..y).each do |i|
          if y-i == 0 or rocks[y-i-1][x] == "O" or rocks[y-i-1][x] == "#"
            rocks[y-i][x] = "O"
            break
          end
        end
        rocks[y][x] = "."
      end
    end
  end

  rocks
end

def roll_rocks_west(rocks)
  (0...rocks.length).each do |y|
    (1...rocks[y].length).each do |x|

      if rocks[y][x] == "O" and rocks[y][x-1] == "."
        (1..x).each do |i|
          if x-i == 0 or rocks[y][x-i-1] == "O" or rocks[y][x-i-1] == "#"
            rocks[y][x-i] = "O"
            break
          end
        end
        rocks[y][x] = "."
      end

    end
  end

  rocks
end

def roll_rocks_south(rocks)
  (0...rocks[0].length).each do |x|
    (rocks.length-2..0).step(-1).each do |y|
      if rocks[y][x] == "O" and rocks[y+1][x] == "."
        (1...(rocks.length-y)).each do |i|
          if y+i == rocks.length-1 or rocks[y+i+1][x] == "O" or rocks[y+i+1][x] == "#"
            rocks[y+i][x] = "O"
            break
          end
        end
        rocks[y][x] = "."
      end
    end
  end

  rocks
end

def roll_rocks_east(rocks)
  (0...rocks.length).each do |y|
    (rocks[y].length-2..0).step(-1).each do |x|

      if rocks[y][x] == "O" and rocks[y][x+1] == "."
        (1...(rocks[y].length-x)).each do |i|
          if x+i == rocks[y].length-1 or rocks[y][x+i+1] == "O" or rocks[y][x+i+1] == "#"
            rocks[y][x+i] = "O"
            break
          end
        end
        rocks[y][x] = "."
      end

    end
  end

  rocks
end

part2 = 0
current_cycle = []
check_cycle = []
index = 0
min_cycle = 200
min_current_cycle = 10

counter = 0
target = 1_000_000_000
while counter <= target
  counter += 1

  roll_rocks_north part2_data
  roll_rocks_west part2_data
  roll_rocks_south part2_data
  roll_rocks_east part2_data

  if counter > min_cycle
    total = get_total(part2_data)
    if current_cycle.length > min_current_cycle and current_cycle[index] == total
      index += 1
      check_cycle.push(total)

      if index >= current_cycle.length
        cycle_length = index
        part2 = check_cycle[(target - counter) % cycle_length - 1]
        break
      end
    else
      if check_cycle.length > 0
        current_cycle.concat(check_cycle)
        check_cycle = []
        index = 0
      end
      current_cycle.push(total)

      if current_cycle.length > min_current_cycle and current_cycle[0] == total
        check_cycle = [total]
        index = 1
      end
    end
  end
end

puts "Part 2: #{part2}"