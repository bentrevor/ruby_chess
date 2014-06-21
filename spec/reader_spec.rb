require 'reader'

describe Reader do
  it 'strips newlines from input' do
    $stdin.should_receive(:gets).and_return "swag\n"

    Reader.get_move.should == 'swag'
  end
end
