require 'spec_helper'

describe ConsoleWriter do
  it 'prints to stdout' do
    expect($stdout).to receive(:puts).with 'yolo'

    ConsoleWriter.show('yolo')
  end

  it 'formats a board for the console' do
    board = ChessBoard.new
    spaces = board.spaces
    printable_board = ConsoleWriter.printable(spaces)

    expect(printable_board.length).to be 9 # includes a rank for the file labels
    expect(board).to receive(:spaces).and_return spaces
    expect(Kernel).to receive(:system).with "clear"
    expect($stdout).to receive(:puts).with printable_board

    ConsoleWriter.show_board board
  end
end
