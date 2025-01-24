class WelcomeController < ApplicationController
  def index
    @entities = {
      "Users" => users_path,
      "Computers" => computers_path,
      "Reservations" => reservations_path
    }
  end
end
