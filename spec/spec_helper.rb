require 'pry'

Dir[File.expand_path("lib/*.rb")].each { |f| require f }
Dir[File.expand_path("lib/pieces/*.rb")].each { |f| require f }

RSpec.configure do |rspec|
  rspec.deprecation_stream = 'deprecations.log'
end
