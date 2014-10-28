module Utils
  def self.inc_file(file)
    file.succ
  end

  def self.dec_file(file)
    (file.ord - 1).chr
  end

  def self.on_board?(space)
    ! off_board?(space)
  end

  def self.off_board?(space)
    bad_file(space) || bad_rank(space)
  end

  private

  def self.bad_file(space)
    ! ('a'..'h').include?(space[0])
  end

  def self.bad_rank(space)
    ! (space.length == 2 && (1..8).include?(space[1].to_i))
  end
end
