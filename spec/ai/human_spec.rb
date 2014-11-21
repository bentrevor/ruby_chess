require 'spec_helper'

describe Human do
  it 'uses a console reader to get a move' do
    expect(ConsoleReader).to receive(:get_move)

    Human.get_move
  end
end
