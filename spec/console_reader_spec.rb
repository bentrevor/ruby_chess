require 'spec_helper'

describe ConsoleReader do
  it 'uses readline' do
    expect(Readline).to receive(:readline).with("\n--> ", true).and_return 'swag'

    expect(ConsoleReader.get_move).to eq 'swag'
  end
end
