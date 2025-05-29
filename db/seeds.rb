require "open-uri"

IngredientsRecipe.destroy_all
Recipe.destroy_all
User.destroy_all

puts "Initializing seed 🌱"

# 1. Create 2 demo users with prompt_setting
user1 = User.create!(
  email: "anna@example.com",
  password: "password",
)

user2 = User.create!(
  email: "max@example.com",
  password: "password",
)

puts "Users created ! 🧑🏻‍💻"

# 2. Recipe seeds
file1 = URI.parse("https://www.fromager.net/wp-content/uploads/2023/12/recette-pates-carbonara.jpg").open


recipe1 = Recipe.new(
  name: "Spaghetti Carbonara",
  description: "Classic Italian pasta with eggs, cheese and bacon",
  category: "Italian",
  rating: 5,
  user: user1
)

recipe1.photo.attach(
  io: file1, filename: "carbo.jpg", content_type: "image/jpg"
)

recipe1.save!

IngredientsRecipe.create!(name: "spaghetti", quantity: 200, unit: "g", recipe_id: recipe1.id)
IngredientsRecipe.create!(name: "eggs", quantity: 2, unit: "pc(s)", recipe_id: recipe1.id)
IngredientsRecipe.create!(name: "cheese", quantity: 100, unit: "g", recipe_id: recipe1.id)
IngredientsRecipe.create!(name: "bacon", quantity: 100, unit: "g", recipe_id: recipe1.id)


file2 = URI.parse("https://bellyfull.net/wp-content/uploads/2021/05/Chicken-Tikka-Masala-blog.jpg").open

recipe2 = Recipe.new(
  name: "Chicken Tikka Masala",
  description: "Creamy Indian chicken curry",
  category: "Indian",
  rating: 4,
  user: user1
)
recipe2.photo.attach(
  io: file2, filename: "chicken.jpg", content_type: "image/jpg"
)


recipe2.save!

IngredientsRecipe.create!(name: "chicken", quantity: 300, unit: "g", recipe_id: recipe2.id)
IngredientsRecipe.create!(name: "cream", quantity: 100, unit: "l", recipe_id: recipe2.id)
IngredientsRecipe.create!(name: "tomato", quantity: 150, unit: "g", recipe_id: recipe2.id)
IngredientsRecipe.create!(name: "spices", quantity: 20, unit: "g", recipe_id: recipe2.id)



file3 = URI.parse("https://www.kikkoman.fr/fileadmin/_processed_/0/f/csm_1025-recipe-page-Spicy-tuna-and-salmon-rolls_desktop_b6172c0072.jpg").open

recipe3 = Recipe.new(
  name: "Sushi Rolls",
  description: "Homemade maki with salmon and avocado",
  category: "Japanese",
  rating: 5,
  user: user1
)
recipe3.photo.attach(
  io: file3, filename: "sushi.jpg", content_type: "image/jpg"
)

recipe3.save!

IngredientsRecipe.create!(name: "rice", quantity: 200, unit: "g", recipe_id: recipe3.id)
IngredientsRecipe.create!(name: "seaweed", quantity: 4, unit: "pc(s)", recipe_id: recipe3.id)
IngredientsRecipe.create!(name: "salmon", quantity: 150, unit: "g", recipe_id: recipe3.id)
IngredientsRecipe.create!(name: "avocado", quantity: 1, unit: "pc(s)", recipe_id: recipe3.id)



file4 = URI.parse("https://www.foodandwine.com/thmb/PaNa5IByv6syP1U3s3mHuN_BK2c=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/guacamole-for-a-crowd-FT-RECIPE0125-624c884187d44062ae4fb86794d0769c.jpeg").open

recipe4 = Recipe.new(
  name: "Guacamole",
  description: "Fresh avocado dip with lime and cilantro",
  category: "Mexican",
  rating: 4,
  user: user1
)

recipe4.photo.attach(
  io: file4, filename: "guacamole.jpg", content_type: "image/jpg"
)

recipe4.save!

IngredientsRecipe.create!(name: "avocado", quantity: 2, unit: "pc(s)", recipe_id: recipe4.id)
IngredientsRecipe.create!(name: "lime", quantity: 1, unit: "pc(s)", recipe_id: recipe4.id)
IngredientsRecipe.create!(name: "onion", quantity: 0.5, unit: "pc(s)", recipe_id: recipe4.id)
IngredientsRecipe.create!(name: "cilantro", quantity: 10, unit: "g", recipe_id: recipe4.id)


file5 = URI.parse("https://www.kikkoman.fr/fileadmin/_processed_/1/8/csm_1075-recipe-page-Saffron-scented-Ratatouille_desktop_5ddfe5fdbf.jpg").open

recipe5 = Recipe.new(
  name: "Ratatouille",
  description: "French vegetable stew with herbs",
  category: "French",
  rating: 3,
  user: user1
)
recipe5.photo.attach(
  io: file5, filename: "ratatouille.jpg", content_type: "image/jpg"
)
recipe5.save!

IngredientsRecipe.create!(name: "zucchini", quantity: 1, unit: "pc(s)", recipe_id: recipe5.id)
IngredientsRecipe.create!(name: "eggplant", quantity: 1, unit: "pc(s)", recipe_id: recipe5.id)
IngredientsRecipe.create!(name: "pepper", quantity: 1, unit: "pc(s)", recipe_id: recipe5.id)
IngredientsRecipe.create!(name: "tomato", quantity: 2, unit: "pc(s)", recipe_id: recipe5.id)



file6 = URI.parse("https://www.seriouseats.com/thmb/4kbwN13BlZnZ3EywrtG2AzCKuYs=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/20210712-tacos-al-pastor-melissa-hom-seriouseats-37-f72cdd02c9574bceb1eef1c8a23b76ed.jpg").open

recipe6 = Recipe.new(
  name: "Tacos al Pastor",
  description: "Spicy pork tacos with pineapple",
  category: "Mexican",
  rating: 5,
  user: user1
)
recipe6.photo.attach(
  io: file6, filename: "tacos.jpg", content_type: "image/jpg"
)

recipe6.save!
IngredientsRecipe.create!(name: "pork", quantity: 250, unit: "g", recipe_id: recipe6.id)
IngredientsRecipe.create!(name: "pineapple", quantity: 100, unit: "g", recipe_id: recipe6.id)
IngredientsRecipe.create!(name: "tortilla", quantity: 3, unit: "pc(s)", recipe_id: recipe6.id)
IngredientsRecipe.create!(name: "chili", quantity: 10, unit: "g", recipe_id: recipe6.id)



file7 = URI.parse("https://int.japanesetaste.com/cdn/shop/articles/mixed-miso-soup-recipe-japanese-taste.jpg?v=1737982159&width=600").open

recipe7 = Recipe.new(
  name: "Miso Soup",
  description: "Traditional Japanese soup with tofu",
  category: "Japanese",
  rating: 4,
  user: user1
)
recipe7.photo.attach(
  io: file7, filename: "miso.jpg", content_type: "image/jpg"
)

recipe7.save!

IngredientsRecipe.create!(name: "miso paste", quantity: 30, unit: "g", recipe_id: recipe7.id)
IngredientsRecipe.create!(name: "tofu", quantity: 100, unit: "g", recipe_id: recipe7.id)
IngredientsRecipe.create!(name: "seaweed", quantity: 10, unit: "g", recipe_id: recipe7.id)
IngredientsRecipe.create!(name: "green onion", quantity: 1, unit: "pc(s)", recipe_id: recipe7.id)



puts "Recipes sample created with ingredients created 🍔"
puts "Go check in your console 🪴"
