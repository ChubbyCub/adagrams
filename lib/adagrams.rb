require "csv"
require "set"

def draw_letters
  letters_hash = {
    "A" => 9, "B" => 2, "C" => 2, "D" => 4, "E" => 12, "F" => 2,
    "G" => 3, "H" => 2, "I" => 9, "J" => 1, "K" => 1, "L" => 4,
    "M" => 2, "N" => 6, "O" => 8, "P" => 2, "Q" => 1, "R" => 6,
    "S" => 4, "T" => 6, "U" => 4, "V" => 2, "W" => 2, "X" => 1,
    "Y" => 2, "Z" => 1,
  }

  letters = []
  letters_hash.each { |letter, frequency|
    frequency.times do
      letters << letter
    end
  }

  return letters.sample(10)
end

def uses_available_letters?(input, letters_in_hand)
  letters_in_hand = letters_in_hand.dup
  input.each_char { |c|
    index = letters_in_hand.index(c.upcase)
    if index.nil?
      return false
    end

    letters_in_hand.delete_at(index)
  }
  return true
end

def score_word(word)
  word = word.upcase
  score = (word.length >= 7) ? 8 : 0

  score_chart = [
    {:letters => ["A", "E", "I", "O", "U", "L", "N", "R", "S", "T"], :score => 1},
    {:letters => ["D", "G"], :score => 2},
    {:letters => ["B", "C", "M", "P"], :score => 3},
    {:letters => ["F", "H", "V", "W", "Y"], :score => 4},
    {:letters => ["K"], :score => 5},
    {:letters => ["J", "X"], :score => 8},
    {:letters => ["Q", "Z"], :score => 10},
  ]

  word.each_char { |c|
    score_chart.each do |element|
      if element[:letters].include?(c)
        score += element[:score]
        break
      end
    end
  }

  return score
end

def highest_score_from(words)
  max_score = 0
  candidate = nil
  words.each do |word|
    score = score_word(word)
    if score < max_score
      next
    end

    if score > max_score
      max_score = score
      candidate = word
    end

    if word.length == candidate.length || candidate.length == 10
      next
    end

    if word.length == 10 || word.length < candidate.length
      candidate = word
      next
    end
  end
  return {:word => candidate, :score => max_score}
end

def is_in_english_dict?(input)
  # instant look up using set
  dictionary = Set.new
  CSV.foreach("/Users/elisepham/Ada/adagrams/assets/dictionary-english.csv", headers: true) do |row|
    if row[0].length <= 10
      dictionary.add(row[0])
    end
  end
  return dictionary.include?(input)
end
