require 'pry'

require './lib/utils.rb'
Dir[File.expand_path("lib/*.rb")].each { |f| require f }
Dir[File.expand_path("lib/pieces/*.rb")].each { |f| require f }
Dir[File.expand_path("lib/moves.rb")].each { |f| require f }
