require "pry"
require "highline"
require "rest-client"

class Trainer
  def self.find(trainer)
    RestClient.get "http://localhost:7000/trainers/#{trainer}"
  end
end

cli = HighLine.new
trainer =
  cli.ask "Welcome to BattlePets! Which trainer would you like to play as?"

if trainer = Trainer.find(trainer)
  cli.say "Welcome #{trainer}"
else
  cli.say "We don't have an account for #{trainer}. Would you like to create one?"
end
