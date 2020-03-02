# frozen_string_literal: true

require_relative 'recipe'
require_relative 'cookbook'
require_relative 'scrape_bbc_goodfood_service'

require 'sinatra'
require 'sinatra/reloader' if development?
# require 'pry-byebug'
require 'better_errors'

set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

csv_file = File.join(__dir__, 'recipes.csv')
cookbook = Cookbook.new(csv_file)
scrape_bbc_goodfood_service = ScrapeBbcGoodFoodService.new

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  # new_recipe = Recipe.new(params['name'], params['desc'], params['prep_time'], params['difficulty'])
  # p new_recipe
  cookbook.add_recipe(Recipe.new(params['name'], params['desc'], params['prep_time'], params['difficulty']))
  redirect to('/')
end

post '/delete' do
  cookbook.remove_recipe(params['index'].to_i)
  redirect to('/')
  p 'success'
end

get '/import' do
  erb :import
end

post '/import' do
  input = params['recipe']
  @results = scrape_bbc_goodfood_service.call_for_query(input)
  erb :import
end

post '/add-import' do
  add = scrape_bbc_goodfood_service.get_details(params['index'].to_i)
  cookbook.add_recipe(Recipe.new(params['result'], add[:link_to_add], add[:prep_time_to_add], add[:diff_to_add]))

  redirect to('/')
end

post '/mark-done' do
  cookbook.mark_done(params['index'].to_i)
  redirect to('/')
end

post '/mark-not-done' do
  cookbook.mark_not_done(params['index'].to_i)
  redirect to '/'
end
