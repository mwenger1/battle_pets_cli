class Competition
  attr_reader :id, :competition_type, :challenger, :challenged

  def initialize(id:, competition_type:, challenger:, challenged:, **)
    @id = id
    @competition_type = competition_type
    @challenger = challenger
    @challenged = challenged
  end
end
