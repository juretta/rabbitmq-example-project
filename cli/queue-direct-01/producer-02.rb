require File.join(File.dirname(__FILE__), '..', 'lib', 'common')

# Startet die EventMachine run loop
AMQP.start do
  MQ.queue('simple-point-to-point').publish('Hello World')
end