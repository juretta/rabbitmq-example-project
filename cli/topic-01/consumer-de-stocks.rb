require File.join(File.dirname(__FILE__), '..', 'lib', 'common')

# =============== Consumer start ===============
AMQP.start do
  LOGGER.info "Consumer #{$PROGRAM_NAME} starting..."
  
  mq = MQ.new
  mq.queue('de stocks').bind(mq.topic('stocks'), :key => 'stock.de.*').subscribe do |header, msg|
    # Nachricht verarbeiten
    LOGGER.info "Deutsche Aktien: #{msg}"
  end
end
