class BattlePet
  def initialize(name:, strength:, agility:, wit:, senses:, **)
    @name = name
    @strength = strength
    @agility = agility
    @wit = wit
    @senses = senses
  end

  def to_s
    "\n#{name}\nStrength: #{strength}\nAgility: #{agility}\nWit: #{wit}\nSenses: #{senses}"
  end

  private

  attr_reader :name, :strength, :agility, :wit, :senses
end
