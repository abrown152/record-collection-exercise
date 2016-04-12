# class methods will reach into SQL releases.rb
# run these class methods in ruby to answer questions.

require 'sqlite3'

class Query
  attr_reader :db

  def initialize(dbname = "releases")
    @db = SQLite3::Database.new("database/releases.db")
  end

  def total_albums
    counter = 0
    @db.execute( "SELECT * FROM albums" ) do |row|
    counter += 1
    end
    counter
  end

  def artist_count
    artist_array = @db.execute("SELECT artist FROM albums")
    artist_array.uniq.length
  end

  def earliest_released
    earliest_array = @db.execute("SELECT artist, released FROM albums WHERE released IS NOT NULL")
    earliest_array = earliest_array.drop_while { |album| album[1] <= 0 }
    earliest = earliest_array.min_by { |album| album[1] }
  end

  def latest_added
    latest_array = @db.execute("SELECT artist, date_added FROM albums WHERE date_added IS NOT NULL")
    latest = latest_array.max_by { |album| Time.parse([album[1]].to_s) }
  end

  def earliest_added
    earliest_array = @db.execute("SELECT artist, date_added FROM albums WHERE date_added IS NOT NULL")
    earliest = earliest_array.min_by { |album| Time.parse([album[1]].to_s) }
  end

  def added_in_year(year)
    added_array = @db.execute("SELECT artist, date_added FROM albums WHERE date_added LIKE '%#{year}%'")
  end

end

new_query = Query.new # connects to releases.db
