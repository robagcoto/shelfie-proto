require "open-uri"


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
  ingredients: "spaghetti, eggs, cheese, bacon",
  category: "Italian",
  rating: 5,
  quantity: 2,
  user_id: user1.id
)

recipe1.photo.attach(
  io: file1, filename: "carbo.jpg", content_type: "image/jpg"
)
recipe1.save!


file2 = URI.parse("https://bellyfull.net/wp-content/uploads/2021/05/Chicken-Tikka-Masala-blog.jpg").open

recipe2 = Recipe.new(
  name: "Chicken Tikka Masala",
  description: "Creamy Indian chicken curry",
  ingredients: "chicken, cream, tomato, spices",
  category: "Indian",
  rating: 4,
  quantity: 3,
  user_id: user1.id
)

recipe2.photo.attach(
  io: file2, filename: "chicken.jpg", content_type: "image/jpg"
)
recipe2.save!


file3 = URI.parse("https://www.kikkoman.fr/fileadmin/_processed_/0/f/csm_1025-recipe-page-Spicy-tuna-and-salmon-rolls_desktop_b6172c0072.jpg").open

recipe3 = Recipe.new(
  name: "Sushi Rolls",
  description: "Homemade maki with salmon and avocado",
  ingredients: "rice, seaweed, salmon, avocado",
  category: "Japanese",
  rating: 5,
  quantity: 4,
  user_id: user1.id
)

recipe3.photo.attach(
  io: file3, filename: "sushi.jpg", content_type: "image/jpg"
)
recipe3.save!

file4 = URI.parse("https://www.foodandwine.com/thmb/PaNa5IByv6syP1U3s3mHuN_BK2c=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/guacamole-for-a-crowd-FT-RECIPE0125-624c884187d44062ae4fb86794d0769c.jpeg").open

recipe4 = Recipe.new(
  name: "Guacamole",
  description: "Fresh avocado dip with lime and cilantro",
  ingredients: "avocado, lime, onion, cilantro",
  category: "Mexican",
  rating: 4,
  quantity: 1,
  user_id: user1.id
)
recipe4.photo.attach(
  io: file4, filename: "guacamole.jpg", content_type: "image/jpg"
)
recipe4.save!

file5 = URI.parse("https://www.kikkoman.fr/fileadmin/_processed_/1/8/csm_1075-recipe-page-Saffron-scented-Ratatouille_desktop_5ddfe5fdbf.jpg").open

recipe5 = Recipe.new(
  name: "Ratatouille",
  description: "French vegetable stew with herbs",
  ingredients: "zucchini, eggplant, pepper, tomato",
  category: "French",
  rating: 3,
  quantity: 2,
  user_id: user1.id
)
recipe5.photo.attach(
  io: file5, filename: "ratatouille.jpg", content_type: "image/jpg"
)
recipe5.save!

file6 = URI.parse("https://www.seriouseats.com/thmb/4kbwN13BlZnZ3EywrtG2AzCKuYs=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/20210712-tacos-al-pastor-melissa-hom-seriouseats-37-f72cdd02c9574bceb1eef1c8a23b76ed.jpg").open

recipe6 = Recipe.new(
  name: "Tacos al Pastor",
  description: "Spicy pork tacos with pineapple",
  ingredients: "pork, pineapple, tortilla, chili",
  category: "Mexican",
  rating: 5,
  quantity: 3,
  user_id: user1.id
)
recipe6.photo.attach(
  io: file6, filename: "tacos.jpg", content_type: "image/jpg"
)
recipe6.save!

file7 = URI.parse("https://int.japanesetaste.com/cdn/shop/articles/mixed-miso-soup-recipe-japanese-taste.jpg?v=1737982159&width=600").open

recipe7 = Recipe.new(
  name: "Miso Soup",
  description: "Traditional Japanese soup with tofu",
  ingredients: "miso paste, tofu, seaweed, green onion",
  category: "Japanese",
  rating: 4,
  quantity: 2,
  user_id: user1.id
)
recipe7.photo.attach(
  io: file7, filename: "miso.jpg", content_type: "image/jpg"
)
recipe7.save!

puts "Recipes sample created 🍔"
puts "Go check in your console 🪴"
