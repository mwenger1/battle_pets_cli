def login_trainer
  name =
    ask "Welcome to BattlePets! Which trainer would you like to play as?"
  trainer_client = TrainerClient.new(name)

  trainer_client.find_or_create
  say "Welcome #{name}!"

  trainer_client
end

def prompt_user_with_menu_options(trainer_client)
  while true do
    choose do |menu|
      menu.prompt = "What would you like to do?"
      menu.choice("View your Opponents") { trainer_client.view_opponents }
      menu.choice("View your BattlePets") { trainer_client.view_battle_pets }
      menu.choice("Create a BattlePet") { trainer_client.create_battle_pet }
      menu.choice("Challenge an Enemie's BattlePet") { trainer_client.challenge_battle_pet }
      menu.choice("Quit") { say "Farewell!!!"; exit }
    end
  end
end
