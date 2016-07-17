class TrainerClient
  AFFIRMATIVE_WORDS = ["y", "yes"]
  ENDPOINT_URL = "http://localhost:7000/trainers"

  def initialize(name)
    @name = name
  end

  def find_or_create
    fetch_trainer
  rescue RestClient::NotFound
    create_account =
      ask "That trainer does not exist. Would you like to create an account? (y/n)"
    if AFFIRMATIVE_WORDS.include? create_account.downcase
      create_trainer
    else
      say "You need a trainer to play. Restart the game if you'd like to play again!!"
      exit
    end
  end

  def view_opponents
    opponents = build_opponents_list
    opponent_names = opponents.map { |opponent| opponent["name"] }

    say "Your challengers include: #{opponent_names.join(", ")}"
  end

  private

  attr_reader :name

  def build_opponents_list
    fetch_all_trainers.reject do |trainer|
      trainer["name"] == name
    end
  end

  def fetch_all_trainers
    JSON.parse(RestClient.get ENDPOINT_URL)
  end

  def fetch_trainer
    RestClient.get [ENDPOINT_URL, name].join("/")
  end

  def create_trainer
    RestClient.post ENDPOINT_URL, trainer: { name: name }
  end
end
