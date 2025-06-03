module ApplicationHelper
  def show_mobile_navbar?
    (controller_name == "home" && action_name == "index") ||
    (controller_name == "recipes" && %w[index show].include?(action_name))
  end
end
