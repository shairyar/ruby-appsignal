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

class OurImporter
  def import_for_store(tenant_id, store_id, force = false)
    puts tenant_id, store_id
  end
  appsignal_instrument_method :import_for_store
end

10.times do
  begin
    Appsignal.monitor_transaction("process_action.import", :class => "OurImporter", :method => "loop") do
      OurImporter.new.import_for_store(1,2)
    end
  rescue
    # Ignore exceptions
  end
  sleep 5
end

# Make sure all transactions are flushed to the Agent.
Appsignal.stop
