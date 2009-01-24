require 'rubygems'
require 'json'

def retrieve_drop_file(drop_filename)
  json_file = File.new(drop_filename, 'r')
  json_string = ''
  json_file.each_line { |line|
    json_string += line
  }
  return json_string
end

def parse_drop(json_string)
  json = JSON.parse(json_string)
  drop_listing = json['drop_listing']
end


# Defines a test method that when this file is run(ruby json_parsing.rb), 
# this method will get called.  Pretty much like the void main() in C++, Java.
if __FILE__ == $0
  drop_string = retrieve_drop_file('lib/drop_listing.json')
  drops = parse_drop(drop_string)

  drops.each { |drop|
    puts "------------"
    puts "Drop Name: " + drop['name']
    puts "Admin Token: " + drop['admin_token'] if (drop['admin_token_present'])
    puts ""
  }
end