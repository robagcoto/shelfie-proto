# 1. Create a user
user = User.create!(
  email: "demo@shelfie.app",
  password: "password"
)

# 2. Create ingredients

# 3. Create a recipe
recipe = Recipe.create!(
  name: "Tomato Pasta",
  description: "A simple pasta with tomato sauce",
  category: "Italian",
  quantity: 2,
  rating: 4,
  ingredients: "Pasta, Tomato", # <- this field is required even though you're linking through cookbook
  user: user
)
