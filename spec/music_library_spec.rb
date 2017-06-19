require "music_library"

# Reopen the class to allow the original implementation method to be defined
# This will allow us to test the new implementation is correct, without
# cluttering up the real class definition
class MusicLibrary
  # Return a hash of all artists => the range of years covered
  # This method is so great. So great. But why is it so slow??
  def artist_years_orig
    Hash[
      albums.map(&:artist).uniq.map do |artist|
        [artist, albums_by(artist).map(&:year).min..albums_by(artist).map(&:year).max]
      end
    ]
  end
end

describe MusicLibrary do

  
  before :all do
  
    @library = MusicLibrary.new
    fn = 'the_music.csv'
    unless File.exists? 'the_music.csv' 
      fn = 'https://gist.githubusercontent.com/bendilley/20dece4cff6bb4fa5eae74f985b13e7d/raw/1094d9e9a2acbcdaab45d8c324f74521d16953a4/the_music.csv'
    end
    
    content = open fn
    
    CSV.new(content, headers: true).each do |row|
      @library.albums << Album.new(row["Album"], row["Artist"], row["Year"].to_i)
    end
    
  
    @orig_res = nil
    # validate that the new implementation returns the correct result
    if File.exists?("results.o")
      File.open("results.o", "r"){|f| @orig_res = Marshal.load(f.read) }
    else
      @orig_res = @library.artist_years_orig
      File.open("results.o", "w"){|f| f.write(Marshal.dump(@orig_res)) }
    end
    
    expect(@orig_res).to be_a Hash
    expect(@orig_res['Moby']).to eq 1999..2012 
    
    
  end

  it "should run the benchmark of artist years" do
    artist_years = nil
    # 🤔 This needs to go faster:
    benchmark_res = Benchmark.measure { 
      @library.artist_years
    }
    expect(benchmark_res).to be_a Benchmark::Tms
    
    expect(@library.artist_years).to eq @orig_res
    
    store_benchmark(benchmark_res)
  end

  def store_benchmark benchmark_res
    if benchmark_res
      t = Time.now.utc
      hostname = `hostname`
      File.open("perf.txt", "a"){|f| f.write("#{t} #{hostname} #{benchmark_res}") }  
    end
  end

end
