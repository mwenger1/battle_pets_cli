class TrainerClient
  AFFIRMATIVE_WORDS = ["y", "yes"]
  ENDPOINT_URL = "http://localhost:7000/v1/trainers"

  attr_reader :name

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

    say "Your challengers include #{opponent_names.join(", ")}."
  end

  def update_account
    new_name =
      ask "Your current name is #{name}. What would you like to change it to?"

    RestClient.patch trainer_endpoint, trainer: { name: new_name }
    @name = new_name
    say "Your name was successfully updated."
  end

  def delete_account
    RestClient.delete trainer_endpoint
    say "Your account has been deleted!! Restart game to create a new account."
    exit
  end

  private

  def build_opponents_list
    fetch_all_trainers.reject do |trainer|
      trainer["name"] == name
    end
  end

  def fetch_all_trainers
    JSON.parse(RestClient.get ENDPOINT_URL)
  end

  def fetch_trainer
    RestClient.get trainer_endpoint
  end

  def trainer_endpoint
    [ENDPOINT_URL, name].join("/")
  end

  def create_trainer
    RestClient.post ENDPOINT_URL, trainer: { name: name }
  end
end
