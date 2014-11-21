require 'pry'

Dir[File.expand_path("lib/**/*.rb")].each { |f| require f }

['black', 'white'].each do |color|
  %w[rook knight bishop queen pawn king].each do |piece|
    define_method("#{color}_#{piece}") do
      Piece.create(color.to_sym, piece.to_sym)
    end
  end
end
