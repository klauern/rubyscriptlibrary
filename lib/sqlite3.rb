# main.rb
# August 24, 2007
#

require 'rubygems'
require 'sqlite3'

file = "C:/Development/Ruby/Nick.db"
db = SQLite3::Database.new(file)
db.execute("Select * from Names") do |row|
  puts(row)
end

puts "Hello World"

db.execute <<SQL
  CREATE TABLE sites (
    idx INTEGER PRIMARY KEY,
    url VARCHAR(255)
    );
SQL
