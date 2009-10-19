require File.join(File.dirname(__FILE__), '..', 'lib', 'common')

# Startet die EventMachine run loop
AMQP.start do
  # Direct exchange mit Routing Key 'orders'
  exchange = MQ.direct('', :key => 'orders')
  # Um sicherzustellen das Nachrichten auch zugestellt werden wenn noch kein Consumer
  # die Qeueu 'orders' deklariert hat, kann diese
  # auch auf Seiten des Producers deklariert werden:
  # => MQ.queue('orders')
  LOGGER.info "Send message..."
  exchange.publish('Hello World')
end