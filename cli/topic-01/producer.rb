require File.join(File.dirname(__FILE__), '..', 'lib', 'common')
include MQExample


stocks = [['Apple (us)', 'stock.us.appl'], 
  ['Sun (us)', 'stock.us.java'], 
  ['Google (us)', 'stock.us.goog'], 
  ['Adidas (de)', 'stock.de.ads'],
  ['Deutsche Lufthanse (de)', 'stock.de.lha'],
].shuffle!


# =============== Producer start ===============
AMQP.start(:host => 'localhost') do # Wenn erforderlich hier Benutzername/Passwort angeben
  LOGGER.info "Producer #{$PROGRAM_NAME} starting..."
  
  exchange = MQ.topic('stocks')
  stocks.each do |name, key|
    LOGGER.info "Producer publish message '#{name}' with routing key '#{key}' (#{$$})..."
    exchange.publish("Stock: #{name}", :key => key)
  end
end
