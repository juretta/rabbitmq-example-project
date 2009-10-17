require File.join(File.dirname(__FILE__), '..', 'lib', 'common')
include MQExample


# =============== Consumer start ===============
AMQP.start(:host => 'localhost') do # Wenn erforderlich hier Benutzername/Passwort angeben
  LOGGER.info "Consumer #{$PROGRAM_NAME} starting..."
  
  AMQP.logging = false
  
  mq = MQ.new
  mq.prefetch(1) # Nachrichtenzustellung beschränken
  queue = mq.queue('orders')
  
  queue.subscribe(:ack => true) do |header, msg|
    # Nachricht verarbeiten
    payload = msg
    begin
      payload = decode(msg)
    rescue => e
      LOGGER.warn "Unable to decode the message payload '#{msg}' (#{e})"
    end
    LOGGER.info "Message received: #{payload.inspect}"
    LOGGER.debug "Message header: #{header}"
    
    sleep 1 # Nachricht verarbeiten...
    
    header.ack unless AMQP.closing? # Nachrichtenerhalt bestaetigen
  end
end
