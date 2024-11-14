# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
require 'json'

puts "Cleaning database..."
Bookmark.destroy_all
List.destroy_all
Movie.destroy_all

puts "Creating movies..."
url = "http://tmdb.lewagon.com/movie/top_rated"
response = URI.open(url).read
data = JSON.parse(response)

data["results"].each do |movie|
  Movie.create!(
    title: movie["title"],
    overview: movie["overview"],
    poster_url: "https://image.tmdb.org/t/p/w500#{movie["poster_path"]}",
    rating: movie["vote_average"]
  )
end

puts "Creating lists..."
["Action", "Comedy", "Drama", "Horror", "Sci-Fi"].each do |name|
  list = List.create!(name: name)
  3.times do
    Bookmark.create!(
      comment: ["Great movie!", "Must watch!", "Highly recommended!", "Classic!"].sample,
      movie: Movie.all.sample,
      list: list
    )
  end
end

puts "Finished!"
