require 'sqlite3'
require 'csv'
class ReleaseDatabase
  FILE_PATH = 'source/20160406-record-collection.csv'
  attr_reader :db

  def initialize(dbname = "releases")
    @db = SQLite3::Database.new("database/#{dbname}.db")
  end

  def reset_schema!
    query = <<-CREATESTATEMENT
      CREATE TABLE albums (
        id INTEGER PRIMARY KEY,
        label_code BLOB,
        artist TEXT NOT NULL,
        title TEXT NOT NULL,
        label TEXT,
        format TEXT,
        released INTEGER,
        date_added TEXT
      );
    CREATESTATEMENT
    # lines 11-21 are one giant string

    @db.execute("DROP TABLE IF EXISTS albums;")
    @db.execute(query) # runs one and only one query

    # label_code,artist,title,label,format,released,date_added
    #BLOB, TEXT, TEXT, TEXT, FORMAT, INTEGER, TEXT
    # table name: albums
    # one table
  end

  def load!
    insert_statement = <<-INSERTSTATEMENT
      INSERT INTO albums (
        label_code, artist, title, label, format, released, date_added
      ) VALUES (
      :label_code, :artist, :title, :label, :format, :released, :date_added
      );
    INSERTSTATEMENT

    prepared_statement = @db.prepare(insert_statement)

    CSV.foreach(FILE_PATH, headers: true) do |row|
      prepared_statement.execute(row.to_h)
    end
  end
end

release_db = ReleaseDatabase.new
release_db.reset_schema!
release_db.load!
