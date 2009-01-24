# Borrowed from a blog: http://blog.dberg.org/2008/07/jms-jruby-producer-and-consumer.html

#consumer.rb
#------------------------
require "java"
require "activemq-all-5.1.0.jar"

include_class "org.apache.activemq.ActiveMQConnectionFactory"
include_class "org.apache.activemq.util.ByteSequence"
include_class "org.apache.activemq.command.ActiveMQBytesMessage"
include_class "javax.jms.MessageListener"
include_class "javax.jms.Session"

class MessageHandler
  include javax.jms.Session
  include javax.jms.MessageListener

  def onMessage(serialized_message)
    message_body = serialized_message.get_content.get_data.inject("") { |body, byte| body << byte }
    puts message_body
  end

  def run
    factory = ActiveMQConnectionFactory.new("tcp://localhost:61616")
    connection = factory.create_connection();
    session = connection.create_session(false, Session::AUTO_ACKNOWLEDGE);
    queue = session.create_queue("test1-queue");

    consumer = session.create_consumer(queue);
    consumer.set_message_listener(self);

    connection.start();
    puts "Listening..."
  end
end

handler = MessageHandler.new
handler.run

# Summary:  In the guys' blog, he states that he used ActiveMQ for connecting to the
# JMS queue.  I will be attempting to use STCMS instead, so I think I'll have to
# look at Aymeric's code to find out how this all happens.