# Borrowed from a blog: http://blog.dberg.org/2008/07/jms-jruby-producer-and-consumer.html
#
#producer.rb
#--------------

require "java"
require "activemq-all-5.1.0.jar"
require 'readline'

include_class "org.apache.activemq.ActiveMQConnectionFactory"
include_class "org.apache.activemq.util.ByteSequence"
include_class "org.apache.activemq.command.ActiveMQBytesMessage"
include_class "javax.jms.MessageListener"
include_class "javax.jms.Session"

class MessageHandler
  include javax.jms.Session
  include javax.jms.MessageListener

  def initialize
    factory = ActiveMQConnectionFactory.new("tcp://localhost:61616")
    connection = factory.create_connection();
    @session = connection.create_session(false, Session::AUTO_ACKNOWLEDGE);
    queue = @session.create_queue("test1-queue");

    @producer = @session.create_producer(queue);
  end

  def send_message(line)
    puts "received input of #{line}"
    m = @session.createTextMessage()  ;
    m.set_text(line)
    @producer.send(m)
  end

end

handler = MessageHandler.new
loop do
  line = Readline::readline('> ', true)
  handler.send_message(line)
end