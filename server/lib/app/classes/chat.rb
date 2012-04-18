# Module placeholder.
module Chat; end

Dir[File.dirname(__FILE__) + '/chat/*.rb'].each { |f| require f }