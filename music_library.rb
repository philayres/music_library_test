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
content = open 'the_music.csv'
#'https://gist.githubusercontent.com/bendilley/20dece4cff6bb4fa5eae74f985b13e7d/raw/1094d9e9a2acbcdaab45d8c324f74521d16953a4/the_music.csv'
CSV.new(content, headers: true).each do |row|
  library.albums << Album.new(row["Album"], row["Artist"], row["Year"].to_i)
end

# 🤔 This needs to go faster:
res = Benchmark.measure { p library.artist_years }
t = Time.now.utc
hostname = `hostname`
File.open("perf.txt", "a"){|f| f.write("#{t} #{hostname} #{res}") }
res
