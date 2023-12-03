require 'set'
engine = File.read("day03/input.txt").lines(chomp: true).map { |line| line.chars }

numbers = Set.new

def is_number(char)
  /[0-9]/.match? char
end

def is_symbol(char)
  /[^.0-9]/.match? char
end

def add_number(engine, y, x, numbers)
  start_x = x
  while start_x > 0 and is_number(engine[y][start_x - 1])
    start_x -= 1
  end

  numbers.add [y, start_x]
end

def check_parts(engine, symbol_y, symbol_x, numbers)
  (symbol_y - 1..symbol_y + 1).each { |i|
    (symbol_x - 1..symbol_x + 1).each { |j|
      if i == symbol_y && j == symbol_x
        next
      end

      if is_number(engine[i][j])
        add_number(engine, i, j, numbers)
      end
    }
  }
end

(0...engine.length).each { |y|
  (0...engine[y].length).each { |x|
    if is_symbol(engine[y][x])
      check_parts(engine, y, x, numbers)
    end
  }
}

def get_full_number(engine, num)
  y = num[0]
  x = num[1]

  end_x = x
  while end_x < engine[y].length and is_number(engine[y][end_x + 1])
    end_x += 1
  end

  engine[y][x..end_x].join
end


part1 = numbers.map { |num| get_full_number(engine, num).to_i }.sum
puts "Part 1: #{part1}"


def is_gear(char)
  char == '*'
end

def get_gear_ratio(engine, y, x)
  numbers = Set.new

  (y - 1..y + 1).each { |i|
    (x - 1..x + 1).each { |j|
      if i == y && j == x
        next
      end

      if is_number(engine[i][j])
        add_number(engine, i, j, numbers)
      end
    }
  }

  if numbers.length >= 2
    return numbers.map { |num| get_full_number(engine, num).to_i }.inject(:*)
  end
  0
end

part2 = []
(0...engine.length).each { |y|
  (0...engine[y].length).each { |x|
    if is_gear(engine[y][x])
      part2 << get_gear_ratio(engine, y, x)
    end
  }
}

puts "Part 2: #{part2.sum}"