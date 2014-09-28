require 'spec_helper'

describe ConsoleWriter do
  it 'prints to stdout' do
    expect($stdout).to receive(:puts).with 'yolo'

    ConsoleWriter.show('yolo')
  end
end
