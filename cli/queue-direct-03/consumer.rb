require File.join(File.dirname(__FILE__), '..', 'lib', 'common')

# =============== Consumer start ===============
AMQP.start do
  LOGGER.info "Consumer #{$PROGRAM_NAME} starting..."
  
  MQ.queue('simple-point-to-point').subscribe do |header, msg|
    # Nachricht verarbeiten
    LOGGER.info "Message received: #{msg}"
  end
end
