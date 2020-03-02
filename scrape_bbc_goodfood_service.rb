# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

class ScrapeBbcGoodFoodService
  def call_for_query(input)
    url = "https://www.bbcgoodfood.com/search/recipes?query=#{input}"
    @doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    results = @doc.css('h3.teaser-item__title').text.strip.split('  ')

    results
  end

  def get_details(index)
    new_recipe = {}
    # finding description(link)
    desc = @doc.css('h3.teaser-item__title > a')
    new_recipe[:link_to_add] = 'https://www.bbcgoodfood.com' + desc[index].attribute('href')

    # finding preptime
    prep = @doc.css('li.teaser-item__info-item--total-time')
    new_recipe[:prep_time_to_add] = prep[index].text.strip

    # finding difficulty
    diff = @doc.css('.teaser-item__info-item--skill-level')
    new_recipe[:diff_to_add] = diff[index].text.strip
    new_recipe
  end
end
