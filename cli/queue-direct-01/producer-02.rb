require File.join(File.dirname(__FILE__), '..', 'lib', 'common')

# Startet die EventMachine run loop
AMQP.start do
  MQ.queue('orders').publish('Hello World')
end