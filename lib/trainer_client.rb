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

    say "Your opponents include #{opponent_names.join(", ")}."
  end

  def update_account
    new_name =
      ask "Your current name is #{name}. What would you like to change it to?"

    RestClient.patch trainer_endpoint, trainer: { name: new_name }
    @name = new_name
    say "Your name was successfully updated."

  rescue RestClient::UnprocessableEntity
    say "Your name was not updated as that trainer name is already taken."
  end

  def delete_account
    delete_account =
      ask "Are you sure you want to delete your account and all of your BattlePets? (y/n)"

    if AFFIRMATIVE_WORDS.include? delete_account.downcase
      RestClient.delete trainer_endpoint
      say "All of your account info has been deleted. Restart game to create a new account."
      exit
    end
  end

  def create_battle_pet
    name = ask "What do you want to call your BattlePet?"

    battle_pet = create_and_build_battle_pet(name)
    say "Congrats! You have just created: #{battle_pet}"
    say "Gain more experience by challenging an enemy to a battle"
  rescue RestClient::UnprocessableEntity
    say "BattlePet not created as you already have a BattlePet with that name."
  end

  def view_battle_pets
    battle_pets = build_battle_pets_list

    if battle_pets.any?
      say "Your BattlePets include:"
      battle_pets.each { |battle_pet| say battle_pet }
    else
      say "Yikes! You have no BattlePets. Create some before challenging an opponent"
    end
  end

  private

  def create_and_build_battle_pet(name)
    battle_pet = JSON.parse(
      RestClient.post(battle_pet_endpoint, { battle_pet: { name: name } })
    )

    BattlePet.new(symbolize_hash battle_pet)
  end

  def build_battle_pets_list
    fetch_battle_pets.map { |pet| BattlePet.new(symbolize_hash pet) }
  end

  def symbolize_hash(hash)
    Hash[hash.map{ |k, v| [k.to_sym, v] }]
  end

  def fetch_battle_pets
    JSON.parse(RestClient.get battle_pet_endpoint)
  end

  def build_opponents_list
    fetch_all_trainers.reject do |trainer|
      trainer["name"].downcase == name.downcase
    end
  end

  def fetch_all_trainers
    JSON.parse(RestClient.get ENDPOINT_URL)
  end

  def fetch_trainer
    RestClient.get trainer_endpoint
  end

  def battle_pet_endpoint
    [trainer_endpoint, "battle_pets"].join("/")
  end

  def trainer_endpoint
    [ENDPOINT_URL, name].join("/")
  end

  def create_trainer
    RestClient.post ENDPOINT_URL, trainer: { name: name }
  end
end
