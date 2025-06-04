# Controlleur principal pour l'interface utilisateur
# d'entrée nous définisons le house avec la méthode privée

class HouseIngredientsController < ApplicationController
  before_action :default_house

  def index
    # @house = House.default_for(current_user)
    @house_ingredients = @house.house_ingredients.includes(:ingredient)
  end

  # Les utilisateurs ne pourront pas crééer directement d'ingrédients dans la table ingrédients, uniquement ici
  def new
    # appeler la house dans laquelle on est  /// je commente parce que j'ai refacto
    # @house = House.default_for(current_user)
    # Crééer une nouvelle instance de house_ingredients
    @house_ingredient = @house.house_ingredients.new
    # Lister tous les ingredients au cas où on met une logique d'autocompletion
    @ingredients = Ingredient.all
  end

  def create

  end

  def edit

  end

  def update
  end

private

  def default_house
    @house = House.default_for(current_user)
  end
end
