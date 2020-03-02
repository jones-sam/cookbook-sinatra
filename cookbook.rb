# frozen_string_literal: true

require 'csv'
require_relative 'recipe'

class Cookbook
  attr_accessor :csv, :recipes
  def initialize(csv)
    @recipes = []
    @csv = parse(csv)
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes.push(recipe)

    recipes_to_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)

    recipes_to_csv
  end

  def mark_done(index)
    @recipes[index].done = true
  end

  def mark_not_done(index)
    @recipes[index].done = false
  end

  private

  def parse(csv)
    CSV.foreach(csv) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2], row[3])
    end
    csv
  end

  def recipes_to_csv
    CSV.open(@csv, 'wb') do |csv|
      @recipes.each do |x|
        csv << [x.name, x.description, x.prep_time, x.difficulty]
      end
    end
  end
end
