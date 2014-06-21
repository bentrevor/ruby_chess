require 'writer'

describe Writer do
  it 'prints to stdout' do
    $stdout.should_receive(:puts).with 'yolo'

    Writer.show('yolo')
  end

  it 'can print a board' do
    board = double 'board', :spaces => 'spaces'
    $stdout.should_receive(:puts).with 'spaces'

    Writer.show_board board
  end
end
