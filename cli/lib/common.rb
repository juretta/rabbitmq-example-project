# common libraries
require 'rubygems'

# [sudo] gem install --source http://gems.github.com tmm1-amqp
gem 'tmm1-amqp'
require 'mq'

# [sudo] gem install json
require 'json'
require 'logger'

# Modul mit den im Beispiel verwendeten Methoden zum Serialisieren/Deserialisiern
module MQExample
  
  def encode(data)
    data.to_json
  end
  
  def decode(data)
    JSON.parse(data)
  end
  
  
  # Using Marshal limits the usefulness of using a distributed
  # message queue. JSON is an ideal format and allows for greated
  # decoupling of all the components that are part of the
  # messaging architecture.
  def encode_r(data)
    [Marshal.dump(data)].pack("m*")
  end

  def decode_r(payload)
    Marshal.load(payload.unpack("m*").first)
  end
end

class Array
  def shuffle!
    n = size
    until n == 0
      k = Kernel.rand(n)
      n = n - 1
      self[n], self[k] = self[k], self[n]
    end
    self
  end
end

# =============== Logging initialisieren ===============
LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::INFO
#LOGGER.level = Logger::DEBUG

# =============== Shutdown hooks registrieren ===============
shutdown = Proc.new do
  LOGGER.info "#{$PROGRAM_NAME} shutdown..."
  AMQP.stop{ EM.stop }
end

Signal.trap('INT', &shutdown)
Signal.trap('TERM', &shutdown)
