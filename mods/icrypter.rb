module CrypterIF
  def encode
    raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
  end

  def decode
    raise NotImplementedError.new("#{self.class}##{__method__} が実装されていません")
  end
end 
