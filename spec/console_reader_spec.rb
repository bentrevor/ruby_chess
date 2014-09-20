require 'spec_helper'

describe ConsoleReader do
  it 'strips newlines from input' do
    expect($stdin).to receive(:gets).and_return "swag\n"

    expect(ConsoleReader.get_move).to eq 'swag'
  end
end
