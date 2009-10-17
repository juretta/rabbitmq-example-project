require File.join(File.dirname(__FILE__), '..', 'lib', 'common')
include MQExample


# =============== Producer start ===============
AMQP.start(:host => 'localhost') do # Wenn erforderlich hier Benutzername/Passwort angeben
  LOGGER.info "Producer #{$PROGRAM_NAME} starting..."
  
  AMQP.logging = false

  # Benutzt wird hier ein Standardmässig vorhandener direct Exchange ('' verwendet den Exchange 'amq.direct')
  # der Nachrichten mit dem Routing Key 'orders' an die Queue 'orders' weiterleitet.
  exchange = MQ.direct('', :key => 'orders')
  
  # Bemerkung: Alternativ kann auch der folgende Mechanismus benutzt werden um Nachrichten 
  # "an eine Queue" zu schicken:
  #
  #  MQ.queue('orders').publish("Nachricht")
  #
  # Hier wird automatisch die folgende Exchange erzeugt an die die Nachricht dann versandt wird:
  #
  # => Exchange.new(@mq, :direct, '', :key => name)
  #
  # Dies "verschleiert" allerdings die Tatsache das bei AMQP Nachrichten niemals direkt an Queues gesendet
  # werden können, Nachrichten werden ausschliesslich an Exchanges gesendet.


  # Wenn eine Queue mit dem Namen 'orders' deklariert wurde, werden die Nachricht an diese Queue weitergeleitet.
  # Ist keine Queue mit dem Namen 'orders' deklariert worden, werden die Nachrichten "ignoriert".
  # Möchte man sicherstellen dass jede Nachricht gespeichert wird, muss die Queue von einem Consumer, oder 
  # aber von dem Producer deklariert werden.
  # Sobald man den Consumer in diesem Beispiel "consumer_ack.rb" ausführt, ist die Queue 'orders' vorhanden und
  # die Nachrichten werden an diese Queue weitergeleitet.
  
  # Um nicht von der Deklaration der Queue durch den oder die Consumer abhängig zu sein kann die Queue 'orders' auch
  # auf Seiten des Producers erzeugt werden.
  # 
  # queue = MQ.queue('orders')
  # queue.bind exchange # In diesem Beispiel optional da das Binding implizit erfolgt (Exchange routingKey == queue name)

  # Sendet periodische Nachrichten
  count = 1
  EM.add_periodic_timer(0.2) do 
    LOGGER.info "Producer publish message #{count} (#{$$})..."
    msg = encode({:count => count, :sender => $$, :time => Time.new, :data => "#{rand(1000000).to_s}@"})
    LOGGER.debug "Send msg: #{msg}"
    exchange.publish(msg)
    count = count.next
  end

end
