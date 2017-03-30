module Flashcards
  LINE_BREAK = "\n\n\n"

  module_function

  def read_deck(filename)
    file = File.open(filename, 'r')
    cards = file.readlines(LINE_BREAK)
        .each_slice(2)
        .map { |parts|
          Card.new(
            front: parts[0].chomp(LINE_BREAK),
            back: parts[1].chomp(LINE_BREAK)
          )
        }
    Deck.new(cards)
  end

  class Card
    attr_reader :front, :back

    def initialize(front:, back:)
      @front = front
      @back = back
    end
  end

  class Deck
    attr_reader :cards

    def initialize(cards)
      @cards = cards
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

    def add_card
      empty_lines = 0
      front = []
      puts "FRONT (three empty lines to finish)"
      loop do
        line = gets
        if line.chomp("\n").empty?
          empty_lines += 1
        else
          empty_lines = 0
        end

        break if empty_lines >= 3

        front << line
      end
      front = front.join.gsub(Regexp.new(LINE_BREAK), '').chomp("/n")

      empty_lines = 0
      back = []
      puts "BACK (three empty lines to finish)"
      loop do
        line = gets
        if line.chomp("\n").empty?
          empty_lines += 1
        else
          empty_lines = 0
        end

        break if empty_lines >= 3

        back << line
      end
      back = back.join.gsub(Regexp.new(LINE_BREAK), '').chomp("/n")

      cards << Card.new(front: front, back: back)
    end

    def flash_all(shuffle: true)
      self.shuffle if shuffle

      loop do
        flash
        print "Press ENTER for next card. Type exit to quit."
        input = gets.chomp
        break unless input.empty?
      end
    end

    def flash(shuffle: true)
      card = next_card(shuffle: shuffle)
      puts "FRONT"
      puts
      print "\s\s"
      puts card.front.gsub(/\n/, "\n\s\s")
      print "Press ENTER to flip."
      gets
      puts "BACK"
      puts
      print "\s\s"
      puts card.back.gsub(/\n/, "\n\s\s")
    end

    def shuffle
      clear_enum
      @cards.shuffle!
    end

    def sort(&block)
      clear_enum
      @cards.sort!(&block)
    end

    private

    def next_card(shuffle: false)
      card = enum.next
    rescue StopIteration
      clear_enum
      self.shuffle if shuffle
      next_card
    end

    def enum
      @enum ||= @cards.each
    end

    def clear_enum
      @enum = nil
    end
  end
end
