class InvalidBoardSize < StandardError
  def initialize(msg="Row size must be greater to or equal to 3")
    super
  end
end
