class ArenaClient
  AFFIRMATIVE_WORDS = ["y", "yes"]
  ENDPOINT_URL = "http://localhost:7001/v1/competitions"

  def battle(challenger:, challenged:)
    competition = start_competition(challenger: challenger, challenged: challenged)
    say "\nYour BattlePets are competing in #{competition.competition_type}. The battle starts now!!"
    check_score = ask "\nIt was an epic battle and the judges are consulting. Do you want to see if they are ready to announce the score? (y/n)"
    if AFFIRMATIVE_WORDS.include? check_score.downcase
      competition = check_competition_score(competition.id)

      if competition.challenger == competition.winner
        say "Congrats you won!"
      elsif competition.challenged == competition.winner
        say "Bummer you lost!"
      else
        say "Looks like the judges are still deliberating."
      end
    end
  end

  private

  def start_competition(challenger:, challenged:)
    convert_to_competition_object(
      RestClient.post ENDPOINT_URL, competition: { challenger: challenger, challenged: challenged }
    )
  end

  def check_competition_score(id)
    convert_to_competition_object(
      RestClient.get [ENDPOINT_URL, id].join("/")
    )
  end

  def convert_to_competition_object(json)
    competition = JSON.parse(json)
    Competition.new(symbolize_hash competition)
  end

  def symbolize_hash(hash)
    Hash[hash.map{ |k, v| [k.to_sym, v] }]
  end
end
