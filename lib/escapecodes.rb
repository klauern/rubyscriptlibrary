# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 
#!/usr/local/bin/ruby -w

# Gratuitously stolen from a blog post on the inline gem:
# http://www.h3rald.com/blog/inline-introduction

require 'rubygems'
require 'highline/system_extensions'

include HighLine::SystemExtensions

puts "Press a key to view the corresponding ASCII code(s) (or CTRL-X to exit)."

loop do

    print "=> "
    char = get_character
    case char
    when ?\C-x then print "Exiting..."; exit;
    else puts "#{char.chr} [#{char}] (hex: #{char.to_s(16)})";
    end

end