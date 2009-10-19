require File.join(File.dirname(__FILE__), '..', 'lib', 'common')
include MQExample


# =============== Producer start ===============
AMQP.start(:host => 'localhost') do # Wenn erforderlich hier Benutzername/Passwort angeben
  LOGGER.info "Producer #{$PROGRAM_NAME} starting..."
  
  AMQP.logging = false

  exchange = MQ.fanout('alerts')
  count = 1
  EM.add_periodic_timer(0.2) do 
    msg = "Broadcast message #{count}"
    LOGGER.info "Producer publish message #{count} (#{$$})..."
    exchange.publish(msg)
    count = count.next
  end

end
