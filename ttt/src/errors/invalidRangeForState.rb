class InvalidRangeForState < StandardError
  def initialize(msg="Index must be in range of current set of states")
    super
  end
end
