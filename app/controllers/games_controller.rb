require 'open-uri'
require 'json'
require 'date'

class GamesController < ApplicationController
  def new
    @random_letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @score_letters = params[:word]
    @grid_letters = params[:our_letters]
    url = "https://wagon-dictionary.herokuapp.com/#{@score_letters}"
    checked_word = open(url).read
    @return_value = JSON.parse(checked_word)
    @valid_statement = ''
    if @return_value['found'] == true && test_word_in_hash(@score_letters, @grid_letters)
      @valid_statement = "Word is a Real Word!"
    elsif @return_value['found'] == true && !test_word_in_hash(@score_letters, @grid_letters)
      @valid_statement = "Word is Real, but not in the grid"
    else
      @valid_statement = "Word is not in the grid!"
    end
  end

  def test_word_in_hash(attempt, grid)
     test_hash = Hash.new(0)
     grid_hash = Hash.new(0)
     new_grid = grid.downcase

     attempt.split("").each do |element|
        test_hash[:"#{element}"] += 1
    end
    new_grid.split("").each do |element|
      grid_hash[:"#{element}"] += 1
    end

    return test_valid(test_hash, grid_hash)
  end

  def test_valid(test_hash, grid_hash)
    valid = test_hash.all? do |k, v|
      grid_hash[k] >= v
    end
  return valid
  end
end
