data = File.read("day10/input.txt").lines(chomp: true)

LEFT = 0b1000
RIGHT = 0b0100
BOT = 0b0010
TOP = 0b0001

$pipes = {
  LEFT + RIGHT => "-",
  BOT + TOP => "|",
  LEFT + TOP => "J",
  LEFT + BOT => "7",
  RIGHT + TOP => "L",
  RIGHT + BOT => "F"
}

def get_start_position(grid)
  grid.each_with_index do |y, yi|
    y.each_char.with_index do |x, xi|
      if x == "S"
        return [yi, xi]
      end
    end
  end

  [-1, -1]
end

def detect_start_pipe(grid, pos)
  flags = 0
  if grid[pos[0] - 1][pos[1]] =~ /[|7F]/
    flags |= TOP
  end
  if grid[pos[0] + 1][pos[1]] =~ /[|LJ]/
    flags |= BOT
  end
  if grid[pos[0]][pos[1] - 1] =~ /[\-LF]/
    flags |= LEFT
  end
  if grid[pos[0]][pos[1] + 1] =~ /[\-J7]/
    flags |= RIGHT
  end

  $pipes[flags]
end

def get_main_loop(grid, pos)
  cx = pos[1]
  cy = pos[0]
  px = cx
  py = cy

  loop = []
  while loop.empty? or !(cx == pos[1] and cy == pos[0])
    loop.push([cx, cy])
    pipe = grid[cy][cx]

    if loop.length > 1
      px = loop[-2][0]
      py = loop[-2][1]
    end

    if pipe =~ /[\-J7]/ and px != cx - 1
      cx -= 1
    elsif pipe =~ /[\-LF]/ and px != cx + 1
      cx += 1
    elsif pipe =~ /[|7F]/ and py != cy + 1
      cy += 1
    elsif pipe =~ /[|LJ]/ and py != cy - 1
      cy -= 1
    end
  end

  loop
end

start_pos = get_start_position(data)
start_pipe = detect_start_pipe(data, start_pos)
data[start_pos[0]][start_pos[1]] = start_pipe
loop = get_main_loop(data, start_pos)

puts "Part 1: #{loop.length/2.ceil}"

def draw_grid(grid)
  draw = {
    "|" => "│",
    "F" => "┌",
    "L" => "└",
    "J" => "┘",
    "7" => "┐",
    "-" => "─"
  }

  grid.each do |y|
    y.each do |x|
      print draw.fetch(x, x)
    end
    print "\n"
  end
end

def remove_background(grid, x = 0, y = 0)
  to_remove = [[x, y]]

  total = 0
  grid[y][x] = " "
  until to_remove.empty?
    pos = to_remove.shift

    x = pos[0]
    y = pos[1]
    grid[y][x] = " "
    total += 1

    if x>0 and grid[y][x-1] == "."
      grid[y][x-1] = " "
      to_remove.push([x-1, y])
    end
    if x<grid[0].length-1 and grid[y][x+1] == "."
      grid[y][x+1] = " "
      to_remove.push([x+1, y])
    end
    if y>0 and grid[y-1][x] == "."
      grid[y-1][x] = " "
      to_remove.push([x, y-1])
    end
    if y<grid.length-1 and grid[y+1][x] == "."
      grid[y+1][x] = " "
      to_remove.push([x, y+1])
    end
  end

  grid
end

def collapse_grid(grid)
  collapsed = Array.new(grid.length / 2) { Array.new(grid[0].length / 2) }

  (0...collapsed.length).each do |y|
    (0...collapsed[y].length).each do |x|
      collapsed[y][x] = grid[y * 2 + 1][x * 2 + 1]
    end
  end

  collapsed
end

def get_loop_area(loop, grid)
  map = {}
  mins = [Float::INFINITY, Float::INFINITY]
  maxs = [0, 0]
  loop.map do |p|
    key = "#{p[0]},#{p[1]}"
    map[key] = p

    mins = [[mins[0], p[0]].min, [mins[1], p[1]].min]
    maxs = [[maxs[0], p[0]].max, [maxs[1], p[1]].max]
  end

  loop_grid = Array.new(grid.length) { Array.new(grid[0].length, ".") }
  loop.map do |p|
    loop_grid[p[1]][p[0]] = grid[p[1]][p[0]]
  end

  # Expand
  expanded = Array.new((maxs[1] - mins[1] + 1) * 2 + 1) { Array.new((maxs[0] - mins[0] + 1) * 2 + 1, '.') }

  cy = 1
  (mins[1]..maxs[1]).each_with_index do |y, yi|
    cx = 1

    (mins[0]..maxs[0]).each_with_index do |x, xi|
      symbol = loop_grid[y][x]
      expanded[cy][cx] = symbol
      cx += 2
    end

    cy += 2
  end

  (1..expanded.length-1).step(2).each do |y|
    line = expanded[y]
    (2..line.length).step(2).each do |x|
      left = expanded[y][x-1]
      right = expanded[y][x+1]

      if %w[F - L].include?(left) and %w[- 7 J].include?(right)
        expanded[y][x] = "-"
      end
    end
  end

  (2..expanded.length-2).step(2).each do |y|
    line = expanded[y]
    (1..line.length-2).step(2).each do |x|
      top = expanded[y-1][x]
      bot = expanded[y+1][x]

      if %w[F | 7].include?(top) and %w[| J L].include?(bot)
        expanded[y][x] = "|"
      end
    end
  end

  puts
  draw_grid(expanded)
  puts

  remove_background(expanded)
  draw_grid(expanded)

  collapsed = collapse_grid(expanded)
  draw_grid(collapsed)

  total = 0
  (1..expanded.length-1).step(2).each do |y|
    line = expanded[y]
    (1..line.length).step(2).each do |x|
      if expanded[y][x] == "."
        total += 1
      end
    end
  end

  total
end

puts "Part 2: #{get_loop_area(loop, data)}"