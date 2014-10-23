module ChessBoardHelpers
  def self.inc_file(file)
    file.succ
  end

  def self.dec_file(file)
    (file.ord - 1).chr
  end
end
