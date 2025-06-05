module ApplicationHelper
  def show_mobile_navbar?
    (controller_name == "home" && action_name == "index") ||
    (controller_name == "recipes" && %w[index show].include?(action_name))
  end

  # def show_top_nav?
  #   !devise_controller?

  #   (controller_name == "recipes" && action_name == "index") ||
  #   (controller_name == "recipes" && action_name == "show") ||
  #   (controller_name == "recipes" && action_name == "edit") ||
  #   (controller_name == "recipes" && action_name == "new") ||
  #   (controller_name == "chats" && action_name == "new") ||
  #   (controller_name == "chats" && action_name == "index") ||
  #   (controller_name == "messages" && action_name == "index") ||
  #   (controller_name == "messages" && action_name == "new")
  # end

  # def return_url(id = nil)
  #   # return root_path if controller_name == "recipes" && action_name == "index"
  #   return chats_path if controller_name == "recipes" && action_name == "index"
  # end

  def turbo_id_for(obj)
    obj.persisted? ? obj.id : obj.hash
  end
end
