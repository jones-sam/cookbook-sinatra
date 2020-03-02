# frozen_string_literal: true

class Recipe
  attr_accessor :name, :description, :prep_time, :done, :difficulty
  def initialize(name, description, prep_time, difficulty)
    @name = name
    @description = description
    @prep_time = prep_time
    @done = false
    @difficulty = difficulty
  end
end
