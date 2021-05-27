require 'appsignal'
require 'appsignal/integrations/object'
# Setup config
# It expects an appsignal.yml file in a config dir (./config/appsignal.yml)
Appsignal.config = Appsignal::Config.new(
  File.expand_path(File.dirname(__FILE__)),
  "production"
)

# Start the logger and the Agent
Appsignal.start_logger
Appsignal.start

class Foo
  def bar
    1
  end
  appsignal_instrument_method :bar

  def self.bar
    2
  end
  appsignal_instrument_class_method :bar
end

Foo.new.bar
Foo.bar
sleep 5
# Make sure all transactions are flushed to the Agent.
Appsignal.stop
