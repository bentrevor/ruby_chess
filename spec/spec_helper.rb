require 'pry'

Dir[File.expand_path("lib/*.rb")].each { |f| require f }

RSpec.configure do |rspec|
  rspec.deprecation_stream = 'deprecations.log'
end
