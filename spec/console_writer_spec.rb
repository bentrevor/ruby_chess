require 'spec_helper'

describe ConsoleWriter do
  it 'prints to stdout' do
    expect($stdout).to receive(:puts).with 'yolo'

    ConsoleWriter.show('yolo')
  end

  xit 'can print a board' do
    board = ChessBoard.new
    expect($stdout).to receive(:puts).with board.spaces

    ConsoleWriter.show_board board
  end
end
