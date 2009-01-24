# This is a test project for JRuby use.  If the settings don't specify to use
# JRuby, please make appropriate changes, since I don't expect some of the Java
# features to work.


class TestObjects
  
  include Java
  
  def initialize
    @frame = javax.swing.JFrame.new("Window") # Create a Java Frame
    @label = javax.swing.JLabel.new("Hello")
  end
  
  def run_proggie
    @frame.getContentPane.add(@label)  # Invoking the Java method 'getContentPane'.
    @frame.setDefaultCloseOperation(javax.swing.JFrame::EXIT_ON_CLOSE)
    @frame.pack
    @frame.setVisible(true)
  end

end

f = TestObjects.new
f.run_proggie  
  
