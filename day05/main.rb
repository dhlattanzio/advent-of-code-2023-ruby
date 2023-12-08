require 'benchmark'

data = File.read("day05/input.txt").lines(chomp: true)

seeds = data[0].split(": ")[1].split.map { |x| x.to_i }

all_maps = data[2..-1].slice_before { |x| x.empty? }.to_a
                      .map { |x| x.select { |y| !y.empty? } }

maps = {}

all_maps.each do |m|
  keys = m[0].split[0].split("-to-")
  ranges = m[1..-1].map { |x| x.split.map { |y| y.to_i } }

  maps[keys[0]] = {
    to: keys[1],
    ranges: ranges
  }
end

def get_range(num, ranges)
  ranges.each do |r|
    if num >= r[1] and num < r[1] + r[2]
      return r
    end
  end

  nil
end

def get_number(num, r)
  if r.nil?
    return num
  end
  num + (r[0] - r[1])
end

def get_location_of_seed(maps, type, num)
  unless maps.has_key?(type)
    return num
  end
  map = maps[type]

  range = get_range(num, map[:ranges])
  new_num = get_number(num, range)
  get_location_of_seed(maps, map[:to], new_num)
end

part1 = []
seeds.each { |seed| part1.push(get_location_of_seed(maps, "seed", seed)) }

puts "Part 1: #{part1.min}"

def calculate_ranges(maps, type, ranges, extra = 0)
  map = maps[type]

  if map.nil?
    return ranges.map { |x| (x.first - extra...x.last - extra) }.sort_by { |x| x.first }
  end

  map_ranges = map[:ranges].sort_by { |x| x[1] }

  tmp = []
  ranges.each do |r|
    # < Out of range
    if r.first < map_ranges[0][0]
      a = (r.first...[r.last, map_ranges[0][0]].min)
      tmp.concat(calculate_ranges(maps, map[:to], [a], 0))
    end

    # > Out of range
    if r.last >= map_ranges[-1][1]
      a = ([r.first, map_ranges[-1][1]].max...r.last)
      tmp.concat(calculate_ranges(maps, map[:to], [a], 0))
    end

    # = In range
    map_ranges.each do |r2|
      rs = r2[1]
      re = rs + r2[2]
      diff = r2[0] - rs

      if (r.first >= rs and r.first < re) or (r.last >= rs and r.last < re)
        a = ([r.first, rs].max + diff...[r.last, re].min + diff)
        new_r = calculate_ranges(maps, map[:to], [a], diff).map { |x| (x.first...x.last) }
        tmp.concat(new_r)
      end
    end

  end

  tmp.map { |x| (x.first - extra...x.last - extra) }.sort_by { |x| x.first }
end


time = Benchmark.measure do
  part2 = []
  (0...seeds.length).step(2) do |pair|
    rs = seeds[pair]
    re = rs + seeds[pair + 1]

    m = Float::INFINITY
    ra = calculate_ranges(maps, "seed", [(rs...re)])
    ra.each do |x|
      m = [m, get_location_of_seed(maps, "seed", x.first)].min
    end
    part2.push(m)
  end

  puts "Part 2: #{part2.min.to_s}"
end
puts time.real


