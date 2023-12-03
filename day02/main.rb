data = File.read("day02/input.txt").lines chomp: true

games = data.map do |line|
  split = line.split(":")
  game_id = split[0].split(" ")[1].to_i
  reveals = split[1].split(";").map do |reveal|
    cards = reveal.split ", "
    cards.map do |card|
      card = card.split(" ")
      [card[0].to_i, card[1].to_sym]
    end
  end

  [game_id, reveals]
end

def is_valid?(game, bag)
  game[1].each { |play|
    play.each { |card|
      if bag[card[1]] < card[0]
        return false
      end
    }
  }

  true
end

bag = { red: 12, green: 13, blue: 14 }
possibles = []

games.each do |game|
  if is_valid?(game, bag)
    possibles << game
  end
end

part1 = possibles.map { |x| x[0] }.sum
puts "Part 1: #{part1}"

def get_max_power(game)
  cards = {}
  game[1].each do |play|
    play.each do |card|
      cards[card[1]] = 0 unless cards[card[1]]
      cards[card[1]] = [card[0], cards[card[1]]].max
    end
  end

  cards.values.reduce(:*)
end

part2 = games.map { |game| get_max_power(game) }.sum
puts "Part 2: #{part2}"