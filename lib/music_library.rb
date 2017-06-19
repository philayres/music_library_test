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
  
  
  def artist_years

    # hash to hold the results of artist years
    #    { artist => year_min..year_max, ... }
    ay = {}

    # simply run through the albums list once
    # update the artist years on each iteration
    # we don't .map, since we need to reference the ay hash throughout
    albums.each do |album|
      # get the artist element from our results
      years = ay[album.artist]
      
      # does our result already have a record of this artist?
      if years
        # we had this artist in our hash, 
        # so get the new min and max if they are outside of our range
        new_max = album.year if album.year > years.max
        new_min = album.year if album.year < years.min
      else
        # we do not have a year range yet
        # set the min and max to be year of this album
        new_min = album.year
        new_max = album.year
      end
      # only make an update to the artist entry if necessary
      if new_max || new_min        
        new_min ||= years.min
        new_max ||= years.max          
        ay[album.artist] = new_min..new_max 
      end      
    end
    
    return ay
  end

  def albums_by(artist)
    albums.select { |album| album.artist == artist }
  end

end

