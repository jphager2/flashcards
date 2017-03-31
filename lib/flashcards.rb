module Flashcards
  LINE_BREAK = "\n\n\n"

  module_function

  def new_deck
    Deck.new([])
  end

  def read_deck(filename)
    file = File.open(File.expand_path(filename), 'r')
    cards = file.readlines(LINE_BREAK)
        .each_slice(2)
        .map { |parts|
          Card.new(
            front: parts[0].chomp(LINE_BREAK),
            back: parts[1].chomp(LINE_BREAK)
          )
        }
    Deck.new(cards: cards, filename: filename)
  end

  class Card
    attr_reader :front, :back

    def initialize(front:, back:)
      @front = front
      @back = back
    end
  end

  class Deck
    attr_reader :cards, :filename

    def initialize(cards:, filename: nil)
      @cards = cards
      @filename = filename
    end

    def write(filename)
      File.open(filename, 'w') do |file|
        cards.each do |card|
          file.write(card.front.chomp("\n"))
          file.write(LINE_BREAK)
          file.write(card.back.chomp("\n"))
          file.write(LINE_BREAK)
        end
      end
    end

    def add_card(front:, back:)
      cards << Card.new(front: front, back: back)
    end

    def shuffle
      clear_enum
      @cards.shuffle!
    end

    def sort(&block)
      clear_enum
      @cards.sort!(&block)
    end

    def next_card(shuffle: false)
      if cards.empty?
        return Card.new(front: "NO CARDS YET", back: "NO CARDS YET")
      end

      enum.next
    rescue StopIteration
      clear_enum
      self.shuffle if shuffle
      next_card
    end

    private

    def enum
      @enum ||= @cards.each
    end

    def clear_enum
      @enum = nil
    end
  end
end
