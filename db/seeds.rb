# 1. Create 2 demo users with prompt_setting
user1 = User.create!(
  email: "anna@example.com",
  password: "password",
)

user2 = User.create!(
  email: "max@example.com",
  password: "password",
)

# 2. Recipe seeds
recipe1 = Recipe.new(
  name: "Spaghetti Carbonara",
  description: "Classic Italian pasta with eggs, cheese and bacon",
  ingredients: "spaghetti, eggs, cheese, bacon",
  category: "Italian",
  rating: 5,
  quantity: 2,
  user_id: 1
)
recipe1.save!

recipe2 = Recipe.new(
  name: "Chicken Tikka Masala",
  description: "Creamy Indian chicken curry",
  ingredients: "chicken, cream, tomato, spices",
  category: "Indian",
  rating: 4,
  quantity: 3,
  user_id: 1
)
recipe2.save!

recipe3 = Recipe.new(
  name: "Sushi Rolls",
  description: "Homemade maki with salmon and avocado",
  ingredients: "rice, seaweed, salmon, avocado",
  category: "Japanese",
  rating: 5,
  quantity: 4,
  user_id: 1
)
recipe3.save!

recipe4 = Recipe.new(
  name: "Guacamole",
  description: "Fresh avocado dip with lime and cilantro",
  ingredients: "avocado, lime, onion, cilantro",
  category: "Mexican",
  rating: 4,
  quantity: 1,
  user_id: 1
)
recipe4.save!

recipe5 = Recipe.new(
  name: "Ratatouille",
  description: "French vegetable stew with herbs",
  ingredients: "zucchini, eggplant, pepper, tomato",
  category: "French",
  rating: 3,
  quantity: 2,
  user_id: 1
)
recipe5.save!

recipe6 = Recipe.new(
  name: "Tacos al Pastor",
  description: "Spicy pork tacos with pineapple",
  ingredients: "pork, pineapple, tortilla, chili",
  category: "Mexican",
  rating: 5,
  quantity: 3,
  user_id: 2
)
recipe6.save!

recipe7 = Recipe.new(
  name: "Miso Soup",
  description: "Traditional Japanese soup with tofu",
  ingredients: "miso paste, tofu, seaweed, green onion",
  category: "Japanese",
  rating: 4,
  quantity: 2,
  user_id: 2
)
recipe7.save!
