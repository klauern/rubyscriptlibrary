# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 
require 'sqlite3'


class DatabaseManager
  def initialize(filename)
    @filename = filename
    # check if it exists
    @db = SQLite3::Database.new(filename)
  end
  
  # Creates a new database table based on the name, columns, and types
  # Each column must match a type.  
  def create_table(name, columns, types)
    # @db.execute("Create Table #{name} ()")
    # p "Created database #{filename}"
    
  end
end