class Competition
  attr_reader :id, :competition_type, :challenger, :challenged, :winner

  def initialize(id:, competition_type:, challenger:, challenged:, winner: nil, **)
    @id = id
    @competition_type = competition_type
    @challenger = challenger
    @challenged = challenged
    @winner = winner
  end
end
