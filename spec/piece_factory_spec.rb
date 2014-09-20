require 'spec_helper'

describe PieceFactory do
  it 'creates different types of pieces' do
    rook = PieceFactory.create(:white, :rook)

    expect(rook).to be_a Rook
  end
end
