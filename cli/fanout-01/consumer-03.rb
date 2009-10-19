require File.join(File.dirname(__FILE__), '..', 'lib', 'common')

# =============== Consumer start ===============
AMQP.start do
  LOGGER.info "Consumer #{$PROGRAM_NAME} starting..."
  
  mq = MQ.new
  mq.queue('monitor-alerts', :auto_delete => true).bind(mq.fanout('alerts')).subscribe do |header, msg|
    # Nachricht verarbeiten
    LOGGER.info "Look ma a new message: #{msg}"
  end
end
