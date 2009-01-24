# 
# To change this template, choose Tools | Templates
# and open the template in the editor.

include Java

 # standard Java platform via their full paths.
   frame = javax.swing.JFrame.new("Window") # Creating a Java JFrame.
   label = javax.swing.JLabel.new("Hello")
   
   # We can transparently call Java methods on Java objects, just as if they were defined in Ruby.
   frame.getContentPane.add(label)  # Invoking the Java method 'getContentPane'.
   frame.setDefaultCloseOperation(javax.swing.JFrame::EXIT_ON_CLOSE)
   frame.pack
   frame.setVisible(true)
