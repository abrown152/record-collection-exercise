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
end

new_query = Query.new # connects to releases.db
