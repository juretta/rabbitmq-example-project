require File.join(File.dirname(__FILE__), '..', 'lib', 'common')

# Startet die EventMachine run loop
AMQP.start do
  # Direct exchange mit Routing Key 'orders'
  exchange = MQ.direct('', :key => 'simple-point-to-point')
  # Um sicherzustellen das Nachrichten auch zugestellt werden wenn noch kein Consumer
  # die Qeueu 'simple-point-to-point' deklariert hat, kann diese
  # auch auf Seiten des Producers deklariert werden:
  # => MQ.queue('simple-point-to-point')
  LOGGER.info "Send message..."
  exchange.publish('Hello World')
end