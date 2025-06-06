module ApplicationHelper
  def show_mobile_navbar?
    (controller_name == "home" && action_name == "index") ||
    (controller_name == "recipes" && %w[index show].include?(action_name)) ||
    (controller_name == "house_ingredients" && action_name == "index")
  end

  # helper pour insérer un id unique
  # soit l'id de l'instance
  # soit un hashage de l'objet : ex. -70134562659349938
  def turbo_id_for(obj)
    obj.persisted? ? obj.id : obj.hash
  end
end
