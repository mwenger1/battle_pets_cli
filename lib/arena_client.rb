class ArenaClient
  ENDPOINT_URL = "http://localhost:7001/v1/competitions"

  def battle(challenger:, challenged:)
    competition = start_competition(challenger: challenger, challenged: challenged)
    say "\nYour BattlePets are competing in #{competition.competition_type}. The battle starts now!!"
  end

  private

  def start_competition(challenger:, challenged:)
    competition = JSON.parse(
      RestClient.post ENDPOINT_URL, competition: { challenger: challenger, challenged: challenged }
    )
    Competition.new(symbolize_hash competition)
  end

  def symbolize_hash(hash)
    Hash[hash.map{ |k, v| [k.to_sym, v] }]
  end
end
