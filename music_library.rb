require 'benchmark'
require 'open-uri'
require 'csv'

class Album
  
  attr_accessor :title, :artist, :year
  
  def initialize(title, artist, year)
    self.title = title
    self.artist = artist
    self.year = year
  end

end

class MusicLibrary

  def albums
    @albums ||= []
  end
  
  # Return a hash of all artists => the range of years covered
  # This method is so great. So great. But why is it so slow??
  def artist_years
    Hash[
      albums.map(&:artist).uniq.map do |artist|
        [artist, albums_by(artist).map(&:year).min..albums_by(artist).map(&:year).max]
      end
    ]
  end

  def albums_by(artist)
    albums.select { |album| album.artist == artist }
  end

end

library = MusicLibrary.new
content = open 'https://gist.githubusercontent.com/bendilley/dc6235f315f4409ab2733e90321014be/raw/c8dd2df0e2dc4dbbb83a1454b4b5f07216aadf02/music.csv'
CSV.new(content, headers: true).each do |row|
  library.albums << Album.new(row["Album"], row["Artist"], row["Year"].to_i)
end

# 🤔 This needs to go faster:
Benchmark.measure { p library.artist_years }
