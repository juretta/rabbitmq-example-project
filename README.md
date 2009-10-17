Beispiele
=========

Es werden die folgenden Bibliotheken benötigt:

	* tmm1-amqp 0.6.4: [sudo] gem install --source http://gems.github.com tmm1-amqp
	* json: [sudo] gem install json

Da es bei einer message orientierten Architektur um die Interaktion lose gekoppelter Komponenten geht,
enthält dieses Verzeichnis mehrere Applikationen/Skripte die untereinander Nachrichten austauschen:

Das Verzeichnis **railsapp** beinhaltet eine einfach Railsanwendung die sich mit RabbitMQ verbindet und
Nachrichte versendet (Producer).

Das Verzeichnis **cli** enthält die folgenden Applikationen die Nachrichten entgegennehmen (Consumer) aber auch
versenden (Producer):


* queue-direct-01: Producer/Consumer die Nachrichten über die Queue _simple-point-to-point_ austauschen.


* queue-direct-02 (Consumer für das Rails-Beispiel 'Queue'):
	* consumer\_ack.rb: Consumer der Nachrichten von der Messagequeue _orders_ erhält 
	und den Empfang jeder Nachricht bestätigt (ack: acknowledge).
	* producer.rb: Producer der Nachrichten an die Exchange 'amq.direct' (Routing Key 'orders').
	Auf Basis des Routing Keys werden Nachrichten in die Queue 'orders' weitergeleitet.
  Verbinden sich mehrere dieser Consumer mit RabbitMQ werden die Nachrichten an die angemeldeten Consumer
  im Round-Robin Verfahren verteilt.

* topic-01 (Consumer für das Rails-Beispiel 'Topic'):
	* consumer-de-stocks.rb: Deklariert eine Queue 'de stocks' und ein Binding 'stock.de.*' für den Exchange
	  'stocks'. Alle Nachrichten bei denen das Binding-Pattern den in der Message enthaltenen Routing-Key
	  matcht werden in die Queue 'de stocks' kopiert und an diesen Consumer ausgliefert.
	* consumer-us-stocks.rb: Deklariert eine Queue 'us stocks' und ein Binding 'stock.us.*' für den Exchange
	  'stocks'. Alle Nachrichten bei denen das Binding-Pattern den in der Message enthaltenen Routing-Key
	  matcht werden in die Queue 'us stocks' kopiert und an diesen Consumer ausgliefert.
	
* fanout-01 (Consumer für das Rails-Beispiel 'Fanout'):
	* consumer-01.rb: Deklariert die Queue 'log-alerts' und erzeugt ein Fanout Binding für den Exchange 'alerts'.
	* consumer-02.rb: Deklariert die Queue 'save-alerts' und erzeugt ein Fanout Binding für den Exchange 'alerts'.


Das 'rabbit-tools' gem installiert den Befehl 'rabbitstatus' der eine übersichtliche Auflistung der RabbitMQ 
queues, exchanges, bindings und connections ausgibt:

	[sudo] gem install rabbit-tools


	stefan@macbookpro:~ [0]$ rabbitstatus 

	list_exchanges
	+------------------+---------+-------------+---------+
	| name             | durable | auto_delete | type    |
	+------------------+---------+-------------+---------+
	| stocks           | false   | false       | topic   |
	| amq.rabbitmq.log | true    | false       | topic   |
	| amq.match        | true    | false       | headers |
	| alerts           | false   | false       | fanout  |
	| amq.headers      | true    | false       | headers |
	| amq.topic        | true    | false       | topic   |
	| amq.direct       | true    | false       | direct  |
	| amq.fanout       | true    | false       | fanout  |
	|                  | true    | false       | direct  |
	+------------------+---------+-------------+---------+
	
	[...]
