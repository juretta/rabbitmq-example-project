require File.join(File.dirname(__FILE__), '..', 'lib', 'common')

# =============== Consumer start ===============
AMQP.start do
  LOGGER.info "Consumer #{$PROGRAM_NAME} starting..."
  
  mq = MQ.new
  mq.queue('us stocks').bind(mq.topic('stocks'), :key => 'stock.us.*').subscribe do |header, msg|
    # Nachricht verarbeiten
    LOGGER.info "US stock: #{msg}"
  end
end
