require File.join(File.dirname(__FILE__), '..', 'lib', 'common')

# =============== Consumer start ===============
AMQP.start do
  LOGGER.info "Consumer #{$PROGRAM_NAME} starting..."
  
  mq = MQ.new
  mq.queue('save-alerts').bind(mq.fanout('alerts')).subscribe do |header, msg|
    # Nachricht verarbeiten
    LOGGER.info "Save message to database: #{msg}"
  end
end
