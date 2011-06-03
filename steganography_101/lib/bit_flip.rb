module BitFlip
  def to_zero(number)
    (number >> 1) << 1
  end

  def to_one(number)
    number | 1
  end
end
