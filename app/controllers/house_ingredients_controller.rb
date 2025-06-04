# Controlleur principal pour l'interface utilisateur


class HouseIngredientsController < ApplicationController
  def index
    @house = House.find(params[:house_id])
    @house_ingredients = @house.house_ingredients.includes(:ingredient)
  end

  # Les utilisateurs ne pourront pas crééer directement d'ingrédients dans la table ingrédients, uniquement ici
  def new
    # appeler la house dans laquelle on est
    @house = House.find(params[:house_id])
    # Crééer une nouvelle instance de house_ingredients
    @house_ingredients = @house.house_ingredients.includes(:ingredient)
    # Lister tous les ingredients au cas où on met une logique d'autocompletion
    @ingredients = Ingredient.all
  end

  def create

  end

  def edit
  end

  def update
  end
end
