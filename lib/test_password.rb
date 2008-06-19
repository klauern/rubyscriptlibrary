# this is a simple code snippet that shows how you can use HighLine
# to get a password field, where the terminal does not echo the password back
# out.
require 'rubygems'
require 'highline/import'

def get_password(prompt='Password: ')
  ask(prompt) { |q| q.echo = false}
end

pass = get_password
puts "I got your password, and it is:"
puts pass