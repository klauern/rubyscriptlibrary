# This script attempts to read a .csv file and push it out in a pretty format

require 'rubygems'
require 'faster_csv'

# Simple way of reading in a .csv file as a large dump into an array
arr_of_arrs = FasterCSV.read("C:\\Development\\EAI Integrations Support Matrix.csv")

# Another way of doing this
  FasterCSV.foreach("C:\\Development\\EAI Integrations Support Matrix.csv") do |row|
    puts row
  end

# best way I found:
# will create a table instance, which has a header row.
arr = FasterCSV.table("C:\\Development\\EAI Integrations Support Matrix.csv")

# To get all the headers you can just as well call arr.headers
x = 1
arr.headers.each { |head| 
  puts "Column #{x} is #{head}" 
  x += 1  }
x = 1