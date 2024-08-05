require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = []
    @alphabet = ('a'..'z').to_a
    10.times { @grid << @alphabet.sample.upcase }
    @grid
  end

  def score
    @user_guess = params[:guess]
    @grid = params[:grid]
    @score = session[:score] || 0
    url = "https://dictionary.lewagon.com/#{@user_guess}"
    dictionary = JSON.parse(URI.open(url).read)
    in_grid = @user_guess.upcase.chars.all? { |letter| @grid.count(letter) >= @user_guess.upcase.count(letter) }
    if !in_grid
      @result = 'The word can’t be built out of the original grid, too many duplicate letters ❌'
    elsif @user_guess.upcase.chars.all? { |letter| @grid.chars.include?(letter) } && dictionary['found']
      @result = 'The word is valid according to the grid and is an English word ✅'
      @score += @user_guess.length
      session[:score] = @score
    elsif @user_guess.upcase.chars.all? { |letter| @grid.chars.include?(letter) }
      @result = 'The word is valid according to the grid, but is not a valid English word ❌'
    else
      @result = 'The word can’t be built out of the original grid ❌'
    end
  end
end
