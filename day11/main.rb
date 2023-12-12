universe = File.read("day11/input.txt").lines(chomp: true).map { |x| x.split("") }
universe_copy = Marshal.load(Marshal.dump(universe))

def draw_universe(universe)
  universe.each do |y|
    y.each do |x|
      print x
    end
    print "\n"
  end
end

def expand(universe)
  expand = []
  (0...universe[0].length).each do |x|
    empty = true
    (0...universe.length).each do |y|
      if universe[y][x] != "."
        empty = false
        break
      end
    end

    if empty
      expand.push(x)
    end
  end

  universe.map do |x|
    counter = 0
    expand.each do |j|
      x.insert(j + counter, ".")
      counter += 1
    end
    x
  end

  expand = []
  (0...universe.length).each do |y|
    if universe[y].all? { |x| x == "." }
      expand.push(y)
    end
  end

  expand.each_with_index do |y, i|
    universe.insert(y + i, Array.new(universe[0].length, "."))
  end
end

def get_galaxies(universe)
  stars = []

  (0...universe.length).each do |y|
    (0...universe[0].length).each do |x|
      if universe[y][x] == "#"
        stars.push([x, y])
      end
    end
  end

  stars
end

def get_pairs(galaxies)
  pairs = []

  (0...galaxies.length).each do |i|
    (i+1...galaxies.length).each do |j|
      pairs.push([galaxies[i], galaxies[j]])
    end
  end

  pairs
end

expand universe
galaxies = get_galaxies(universe)
pairs = get_pairs(galaxies)

part1 = pairs.map do |x|
  (x[0][0] - x[1][0]).abs + (x[0][1] - x[1][1]).abs
end
puts "Part 1: #{part1.sum}"


def get_empty_places(universe)
  expand_x = []
  (0...universe[0].length).each do |x|
    empty = true
    (0...universe.length).each do |y|
      if universe[y][x] != "."
        empty = false
        break
      end
    end

    if empty
      expand_x.push(x)
    end
  end

  expand_y = []
  (0...universe.length).each do |y|
    if universe[y].all? { |x| x == "." }
      expand_y.push(y)
    end
  end

  [expand_x, expand_y]
end

universe = universe_copy
empty_places = get_empty_places(universe)

galaxies = get_galaxies(universe)
pairs = get_pairs(galaxies)

def get_distances(pairs, empty_places, expand = 1)
  if expand == 1
    expand += 1
  end

  pairs.map do |x|
    start_x = [x[0][0], x[1][0]].min
    start_y = [x[0][1], x[1][1]].min
    dist_x = (x[0][0] - x[1][0]).abs
    dist_y = (x[0][1] - x[1][1]).abs

    range_x = (start_x..start_x+dist_x)
    range_y = (start_y..start_y+dist_y)

    extra_x = empty_places[0].count { |k| range_x.include?(k) }
    extra_y = empty_places[1].count { |k| range_y.include?(k) }

    dist_x + dist_y + (extra_x * expand) + (extra_y * expand) - extra_x - extra_y
  end
end

distances = get_distances(pairs, empty_places, 1_000_000)
puts "Part 2: #{distances.sum}"