require "pry"
require "json"
require "highline"
require "highline/import"
require "rest-client"
require "./lib/helper_methods"
require "./lib/battle_pet"
require "./lib/arena_client"
require "./lib/competition"
require "./lib/trainer"
require "./lib/trainer_client"

trainer_client = login_trainer

prompt_user_with_menu_options(trainer_client)
