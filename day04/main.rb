data = File.read("day04/input.txt").lines(chomp: true).map do |card|
  i = card.index ": "
  card[i + 2...card.length].to_s.split(" | ").map { |x| x.split(" ").map { |z| z.to_i } }
end

def get_wins(game)
  game[0].select { |n| game[1].include? n}.length
end

def get_score(game)
  r = get_wins game
  r == 0 ? 0 : 2 ** (r - 1)
end

part1 = data.map { |g| get_score g }.sum
puts "Part 1: #{part1}"


counters = {}
(1..data.length).each { |i|
  curr = counters.fetch(i.to_s, 0) + 1

  wins = get_wins data[i-1]
  ((i + 1)..(i + wins)).each { |j|
    counters[j.to_s] = counters.fetch(j.to_s, 0) + curr
  }

  counters[i.to_s] = curr
}

part2 = counters.values.sum
puts "Part 2: #{part2}"