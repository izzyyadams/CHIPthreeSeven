class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service


  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  def initialize(new_word)
    @word = new_word
    @guesses = ''
    @wrong_guesses = ''

  end

  def guess(guessed)
    if (guessed == '') || (guessed.nil?) 
      raise ArgumentError, "Can't guess an empty string"
    end
    guessed.each_char do |letter|
      if !(letter =~/^[a-zA-Z]$/)
        raise ArgumentError, "Must guess a letter"
      end
      letter = letter.downcase
      if @word.downcase.include?(letter) 
        if @guesses.include?(letter)
          return false
        else
          @guesses += letter
        end
      else 
        if @wrong_guesses.include?(letter)
          return false
        else
          @wrong_guesses += letter
        end
      end
    end
  end

  def word_with_guesses()
    output = ''
    @word.each_char do |letter|
      if @guesses.include?(letter)
        output += letter
      else
        output += '-'
      end
    end
    return output
  end

  def check_win_or_lose()
    won = false
    @word.each_char do |letter|
      if @guesses.include?(letter)
        won = true
      else
        won = false
        break
      end
    end
    if won
      return :win
    else
      if @guesses.length + @wrong_guesses.length <
        7
        return :play
      else
        return :lose
      end
    end

  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
