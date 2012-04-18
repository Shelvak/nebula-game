# An empty module to fit other modules in.
module Parts; end

Dir[File.dirname(__FILE__) + '/parts/*.rb'].each { |f| require f }