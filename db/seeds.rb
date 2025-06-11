require "open-uri"

puts "Restarting seed 🔥"
Step.destroy_all
IngredientsRecipe.destroy_all
Recipe.destroy_all
HouseUser.destroy_all
HouseIngredient.destroy_all
Ingredient.destroy_all
Message.delete_all
Chat.delete_all
User.destroy_all
House.destroy_all

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

puts "Users created !   🧑🏻‍💻"

# ----------------------------------------------------------------------------------------------------------------------

# 2. Recipe seeds

puts "creating recipe 1 🔪👨🏻‍🍳"

file1 = URI.parse("https://www.fromager.net/wp-content/uploads/2023/12/recette-pates-carbonara.jpg").open

steps1 = [
  "Boil water, salt it generously, and cook spaghetti until al dente. Reserve 1 cup of pasta water before draining.",
  "In a pan, cook pancetta/guanciale over medium heat until crispy. Turn off the heat once done.",
  "In a bowl, whisk together the egg yolks, whole egg, cheese, and a generous amount of black pepper.",
  "Add the hot pasta to the pan with pancetta. Quickly toss.",
  "Immediately stir in the egg mixture, tossing fast so the eggs coat the pasta without scrambling. Add pasta water bit by bit to make it creamy.",
  "Serve right away with extra cheese and black pepper on top."
]

recipe1 = Recipe.create!(
  name: "Spaghetti Carbonara",
  description: "The creamy, cheesy, bacon-hugged pasta that thinks it's too cool for cream !",
  duration: 20,
  category: "Italian",
  rating: 5,
  user: user1,
  my_recipe: true
)

steps1.each do |step|
  Step.create(recipe: recipe1, description: step)
end

recipe1.photo.attach(
  io: file1, filename: "carbo.jpg", content_type: "image/jpg"
)

recipe1.save!


IngredientsRecipe.create!(name: "spaghetti", quantity: 200, unit: "g", recipe: recipe1)
IngredientsRecipe.create!(name: "eggs", quantity: 2, unit: "pc(s)", recipe: recipe1)
IngredientsRecipe.create!(name: "cheese", quantity: 100, unit: "g", recipe: recipe1)
IngredientsRecipe.create!(name: "bacon", quantity: 100, unit: "g", recipe: recipe1)

# ----------------------------------------------------------------------------------------------------------------------

puts "Recipe 1 created  🍔"

# ----------------------------------------------------------------------------------------------------------------------

puts "creating recipe 2 🔪👨🏻‍🍳"

file2 = URI.parse("https://bellyfull.net/wp-content/uploads/2021/05/Chicken-Tikka-Masala-blog.jpg").open

steps2 = [
  "In a bowl, mix yogurt, lemon juice, and all marinade spices. Add chicken, coat well, and marinate for at least 30 mins (or overnight).",
  "Heat a grill pan or skillet over high heat. Cook marinated chicken until lightly charred and just cooked through. Set aside.",
 "In a large pan, heat oil/ghee. Sauté onions until golden. Add garlic, ginger, and spices. Stir for 1–2 minutes.",
 "Pour in crushed tomatoes. Simmer for 10 minutes until thick.",
 "Add cream, stir, and then add cooked chicken. Simmer for another 10–15 minutes until chicken is tender and sauce is luscious.",
 "Garnish with fresh coriander. Serve hot with naan or basmati rice."
]

recipe2 = Recipe.new(
  name: "Chicken Tikka Masala",
  description: "The bold, buttery curry that turns chicken into a rockstar.",
  duration: 50,
  category: "Indian",
  rating: 4,
  user: user1,
  my_recipe: true
)

steps2.each do |step|
  Step.create(recipe: recipe2, description: step)
end

recipe2.photo.attach(
  io: file2, filename: "chicken.jpg", content_type: "image/jpg"
)

recipe2.save!

IngredientsRecipe.create!(name: "chicken", quantity: 300, unit: "g", recipe: recipe2)
IngredientsRecipe.create!(name: "cream", quantity: 100, unit: "l", recipe: recipe2)
IngredientsRecipe.create!(name: "tomato", quantity: 150, unit: "g", recipe: recipe2)
IngredientsRecipe.create!(name: "spices", quantity: 20, unit: "g", recipe: recipe2)

puts "Recipe 2 created  🍔"

# ----------------------------------------------------------------------------------------------------------------------
puts "creating recipe 3 🔪👨🏻‍🍳"

file3 = URI.parse("https://www.kikkoman.fr/fileadmin/_processed_/0/f/csm_1025-recipe-page-Spicy-tuna-and-salmon-rolls_desktop_b6172c0072.jpg").open

steps3 = [
  "Rinse sushi rice in cold water until water runs clear. Cook with 2.5 cups water (use a rice cooker or pot).",
  "In a small bowl, mix rice vinegar, sugar, and salt. Heat slightly to dissolve, then stir into cooked rice and let it cool.",
  "Place a sheet of nori on a bamboo mat (shiny side down). Spread a thin layer of cooled rice over the nori, leaving 1 inch at the top edge.",
  "Arrange fillings in a line across the rice, about 1 inch from the bottom edge.",
  "Roll it up tightly using the mat, pressing gently. Seal the edge with a bit of water.",
  "Slice roll into 6–8 pieces with a sharp wet knife. Serve with soy sauce, pickled ginger, and wasabi."
]
recipe3 = Recipe.new(
  name: "Sushi Rolls",
  description: "The bite-sized ocean hugs wrapped in rice and cool vibes!",
  duration: 45,
  category: "Japanese",
  rating: 5,
  user: user1,
  my_recipe: true
)

steps3.each do |step|
  Step.create(recipe: recipe3, description: step)
end

recipe3.photo.attach(
  io: file3, filename: "sushi.jpg", content_type: "image/jpg"
)

recipe3.save!

IngredientsRecipe.create!(name: "rice", quantity: 200, unit: "g", recipe: recipe3)
IngredientsRecipe.create!(name: "seaweed", quantity: 4, unit: "pc(s)", recipe: recipe3)
IngredientsRecipe.create!(name: "salmon", quantity: 150, unit: "g", recipe: recipe3)
IngredientsRecipe.create!(name: "avocado", quantity: 1, unit: "pc(s)", recipe: recipe3)

puts "Recipe 3 created  🍔"
# ----------------------------------------------------------------------------------------------------------------------
puts "creating recipe 4 🔪👨🏻‍🍳"

file4 = URI.parse("https://www.foodandwine.com/thmb/PaNa5IByv6syP1U3s3mHuN_BK2c=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/guacamole-for-a-crowd-FT-RECIPE0125-624c884187d44062ae4fb86794d0769c.jpeg").open

steps4 = [
  "Cut avocados in half, remove pits, and scoop flesh into a bowl.",
  "Mash avocados with a fork until smooth but still slightly chunky.",
  "Add diced tomato, red onion, garlic (if using), lime juice, cilantro, and jalapeño. Mix gently.",
  "Season with salt and pepper to taste.",
  "Serve immediately with tortilla chips, tacos, or toast."
]

recipe4 = Recipe.new(
  name: "Guacamole",
  description: "The creamy green dip that turns chips into a party.",
  duration: 10,
  category: "Mexican",
  rating: 4,
  user: user1,
  my_recipe: true
)

steps4.each do |step|
  Step.create(recipe: recipe4, description: step)
end

recipe4.photo.attach(
  io: file4, filename: "guacamole.jpg", content_type: "image/jpg"
)

recipe4.save!

IngredientsRecipe.create!(name: "avocado", quantity: 2, unit: "pc(s)", recipe: recipe4)
IngredientsRecipe.create!(name: "lime", quantity: 1, unit: "pc(s)", recipe: recipe4)
IngredientsRecipe.create!(name: "onion", quantity: 0.5, unit: "pc(s)", recipe: recipe4)
IngredientsRecipe.create!(name: "cilantro", quantity: 10, unit: "g", recipe: recipe4)

puts "Recipe 4 created  🍔"
# ----------------------------------------------------------------------------------------------------------------------

puts "creating recipe 5 🔪👨🏻‍🍳"


file5 = URI.parse("https://www.kikkoman.fr/fileadmin/_processed_/1/8/csm_1075-recipe-page-Saffron-scented-Ratatouille_desktop_5ddfe5fdbf.jpg").open

steps5 = [
  "Thinly slice eggplant, zucchini, squash, and bell peppers. Dice onion and tomatoes (if using fresh).",
  "In a pan, heat 1 tbsp olive oil. Sauté onion and garlic until soft. Add tomatoes, thyme, salt, and pepper. Simmer for 10 minutes.",
  "Spread tomato mixture on the bottom of a baking dish.",
  "Layer sliced vegetables in a spiral pattern over the sauce, alternating colors.",
  "Drizzle with remaining olive oil, season with more salt, pepper, and thyme. Cover with foil.",
  "Bake for 40 minutes. Remove foil and bake another 10–15 minutes until veggies are tender.",
  "Garnish with fresh basil. Serve warm or at room temp with crusty bread."
]

recipe5 = Recipe.new(
  name: "Ratatouille",
  description: "A colorful veggie confetti that tastes like a French garden party. ",
  duration: 50,
  category: "French",
  rating: 3,
  user: user1,
  my_recipe: true
)

steps5.each do |step|
  Step.create(recipe: recipe5, description: step)
end

recipe5.photo.attach(
  io: file5, filename: "ratatouille.jpg", content_type: "image/jpg"
)
recipe5.save!

IngredientsRecipe.create!(name: "zucchini", quantity: 1, unit: "pc(s)", recipe: recipe5)
IngredientsRecipe.create!(name: "eggplant", quantity: 1, unit: "pc(s)", recipe: recipe5)
IngredientsRecipe.create!(name: "pepper", quantity: 1, unit: "pc(s)", recipe: recipe5)
IngredientsRecipe.create!(name: "tomato", quantity: 2, unit: "pc(s)", recipe: recipe5)

puts "Recipe 5 created  🍔"
# ----------------------------------------------------------------------------------------------------------------------

puts "creating recipe 6 🔪👨🏻‍🍳"

file6 = URI.parse("https://www.seriouseats.com/thmb/4kbwN13BlZnZ3EywrtG2AzCKuYs=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/20210712-tacos-al-pastor-melissa-hom-seriouseats-37-f72cdd02c9574bceb1eef1c8a23b76ed.jpg").open

steps6 = [
  "Soak dried chilies in hot water for 15 minutes until soft.",
  "Blend soaked chilies with garlic, vinegar, pineapple juice, cumin, oregano, cloves, achiote paste, salt, and pepper until smooth.",
  "Marinate pork in the sauce for at least 2 hours, preferably overnight.",
  "Heat oil in a pan or grill over medium-high. Cook pork slices until browned and slightly crispy.",
  "Warm tortillas on a skillet.",
  "Assemble tacos: add pork, top with grilled pineapple, chopped onion, and cilantro.",
  "Serve with lime wedges and let the fiesta begin."
]

recipe6 = Recipe.new(
  name: "Tacos al Pastor",
  description: "Sweet, spicy, smoky pork tacos with pineapple party vibes.",
  duration: 60,
  category: "Mexican",
  rating: 5,
  user: user1,
  my_recipe: true
)

steps6.each do |step|
  Step.create(recipe: recipe6, description: step)
end

recipe6.photo.attach(
  io: file6, filename: "tacos.jpg", content_type: "image/jpg"
)

recipe6.save!
IngredientsRecipe.create!(name: "pork", quantity: 250, unit: "g", recipe: recipe6)
IngredientsRecipe.create!(name: "pineapple", quantity: 100, unit: "g", recipe: recipe6)
IngredientsRecipe.create!(name: "tortilla", quantity: 3, unit: "pc(s)", recipe: recipe6)
IngredientsRecipe.create!(name: "chili", quantity: 10, unit: "g", recipe: recipe6)

puts "Recipe 6 created  🍔"
# ----------------------------------------------------------------------------------------------------------------------
puts "creating recipe 7 🔪👨🏻‍🍳"

file7 = URI.parse("https://int.japanesetaste.com/cdn/shop/articles/mixed-miso-soup-recipe-japanese-taste.jpg?v=1737982159&width=600").open

steps7 = [
  "In a pot, bring water to a gentle simmer and stir in dashi powder.",
  "Add tofu cubes and wakame (or nori). Simmer for 3–4 minutes until tofu is heated and seaweed softens.",
  "In a small bowl, mix miso paste with a few spoonfuls of hot broth to dissolve.",
  "Turn off the heat, then stir the miso mixture back into the soup (never boil miso—it kills the flavor!).",
  "Add green onions. Serve warm and slurp with joy."
]

recipe7 = Recipe.new(
  name: "Miso Soup",
  description: "Traditional Japanese soup with tofu",
  duration: 15,
  category: "Japanese",
  rating: 4,
  user: user1,
  my_recipe: true
)

steps7.each do |step|
  Step.create(recipe: recipe7, description: step)
end

recipe7.photo.attach(
  io: file7, filename: "miso.jpg", content_type: "image/jpg"
)

recipe7.save!

IngredientsRecipe.create!(name: "miso paste", quantity: 30, unit: "g", recipe: recipe7)
IngredientsRecipe.create!(name: "tofu", quantity: 100, unit: "g", recipe: recipe7)
IngredientsRecipe.create!(name: "seaweed", quantity: 10, unit: "g", recipe: recipe7)
IngredientsRecipe.create!(name: "green onion", quantity: 1, unit: "pc(s)", recipe: recipe7)

puts "Recipe 6 created  🍔"

# ----------------------------------------------------------------------------------------------------------------------

puts "Recipes sample created with ingredients created 🥘🍙"
puts "Go check in your console 🪴"


puts "creating message..."

chat = Chat.create!(title: "harry potter recipe", user: user1)
Message.create!(prompt: "harry potter mood !!", user: user1, role: "user", chat: chat)

chat = Chat.create!(title: "ratatouille", user: user1)
Message.create!(prompt: "I just watched ratatouille and I'm hungry !!", user: user1, role: "user", chat: chat)

chat = Chat.create!(title: "chicken sandwich recipe", user: user1)
Message.create!(prompt: "I want the best chicken sandwich!!", user: user1, role: "user", chat: chat)

chat = Chat.create!(title: "Quick asian recipe", user: user1)
Message.create!(prompt: "a quick chinese recipe", user: user1, role: "user", chat: chat)

puts "chat created    📨"

puts "Creating Houses 🏚️"
house1 = House.create!(name: "My happy house")
invite1 = HouseUser.create!(role: "admin", house: house1, user: user1, status: "accepted")
invite2 = HouseUser.create!(role: "user", house: house1, user: user2, status: "accepted")

puts "House created   🏘️"

puts "Creating the ingredients 🛒"

ingredients_data = [
  { name: "banana", storage_method: "Dry", category: "Fruits", quantity: 6, unit: "pc(s)", expiration_days: 5 },
  { name: "apple", storage_method: "Dry", category: "Fruits", quantity: 4, unit: "pc(s)", expiration_days: 20 },
  { name: "carrot", storage_method: "Fridge", category: "Vegetables", quantity: 8, unit: "pc(s)", expiration_days: 21 },
  { name: "tomato", storage_method: "Fridge", category: "Fruits", quantity: 6, unit: "pc(s)", expiration_days: 7 },
  { name: "potato", storage_method: "Dry", category: "Vegetables", quantity: 10, unit: "pc(s)", expiration_days: 30 },
  { name: "onion", storage_method: "Dry", category: "Vegetables", quantity: 7, unit: "pc(s)", expiration_days: 60 },
  { name: "garlic", storage_method: "Dry", category: "Vegetables", quantity: 3, unit: "pc(s)", expiration_days: 90 },
  { name: "broccoli", storage_method: "Fridge", category: "Vegetables", quantity: 3, unit: "pc(s)", expiration_days: 5 },
  { name: "spinach", storage_method: "Fridge", category: "Vegetables", quantity: 200, unit: "g", expiration_days: 5 },
  { name: "lettuce", storage_method: "Fridge", category: "Vegetables", quantity: 200, unit: "g", expiration_days: 7 },
  { name: "egg", storage_method: "Fridge", category: "Dairy and eggs", quantity: 12, unit: "pc(s)", expiration_days: 28 },
  { name: "milk", storage_method: "Fridge", category: "Dairy and eggs", quantity: 2, unit: "l", expiration_days: 7 },
  { name: "butter", storage_method: "Fridge", category: "Dairy and eggs", quantity: 300, unit: "g", expiration_days: 60 },
  { name: "chicken breast", storage_method: "Fridge", category: "Meats", quantity: 3, unit: "pc(s)", expiration_days: 2 },
  { name: "beef steak", storage_method: "Fridge", category: "Meats", quantity: 300, unit: "g", expiration_days: 4 },
  { name: "pork chop", storage_method: "Fridge", category: "Meats", quantity: 200, unit: "g", expiration_days: 4 },
  { name: "fish fillet", storage_method: "Fridge", category: "Fish and seafood", quantity: 100, unit: "g", expiration_days: 2 },
  { name: "shrimp", storage_method: "Freezer", category: "Fish and seafood", quantity: 150, unit: "g", expiration_days: 6 },
  { name: "pea", storage_method: "Freezer", category: "Vegetables", quantity: 1000, unit: "g", expiration_days: 4 },
  { name: "cheddar cheese", storage_method: "Fridge", category: "Dairy and eggs", quantity: 500, unit: "g", expiration_days: 28 },
  { name: "yogurt", storage_method: "Fridge", category: "Dairy and eggs", quantity: 6, unit: "pc(s)", expiration_days: 7 },
  { name: "orange", storage_method: "Dry", category: "Fruits", quantity: 7, unit: "pc(s)", expiration_days: 21 },
  { name: "yellow lemon", storage_method: "Dry", category: "Fruits", quantity: 8, unit: "pc(s)", expiration_days: 28 },
  { name: "cucumber", storage_method: "Fridge", category: "Vegetables", quantity: 5, unit: "pc(s)", expiration_days: 10 },
  { name: "zucchini", storage_method: "Fridge", category: "Vegetables", quantity: 4, unit: "pc(s)", expiration_days: 5 },
  { name: "eggplant", storage_method: "Fridge", category: "Vegetables", quantity: 2, unit: "pc(s)", expiration_days: 7 },
  { name: "bell pepper", storage_method: "Fridge", category: "Vegetables", quantity: 3, unit: "pc(s)", expiration_days: 10 },
  { name: "rice", storage_method: "Dry", category: "Bread, cereals, and nuts", quantity: 1000, unit: "g", expiration_days: 730 },
  { name: "pasta", storage_method: "Dry", category: "Bread, cereals, and nuts", quantity: 1000, unit: "g", expiration_days: 700 },
  { name: "baguette", storage_method: "Dry", category: "Bread, cereals, and nuts", quantity: 2, unit: "pc(s)", expiration_days: 2 },
  { name: "almond", storage_method: "Dry", category: "Bread, cereals, and nuts", quantity: 200, unit: "g", expiration_days: 200 },
  { name: "blueberry", storage_method: "Fridge", category: "Fruits", quantity: 125, unit: "g", expiration_days: 5 },
  { name: "cherry", storage_method: "Fridge", category: "Fruits", quantity: 250, unit: "g", expiration_days: 10 },
  { name: "raspberry", storage_method: "Fridge", category: "Fruits", quantity: 125, unit: "g", expiration_days: 8 },
  { name: "hazelnut", storage_method: "Dry", category: "Bread, cereals, and nuts", quantity: 150, unit: "g", expiration_days: 300 },
  { name: "kidney bean", storage_method: "Dry", category: "Legumes", quantity: 500, unit: "g", expiration_days: 90 },
  { name: "chickpea", storage_method: "Dry", category: "Legumes", quantity: 500, unit: "g", expiration_days: 85 },
  { name: "lentil", storage_method: "Dry", category: "Legumes", quantity: 500, unit: "g", expiration_days: 150 },
  { name: "tofu", storage_method: "Fridge", category: "Processed foods and ready meals", quantity: 400, unit: "g", expiration_days: 12 },
  { name: "ham", storage_method: "Fridge", category: "Meats", quantity: 4, unit: "pc(s)", expiration_days: 8 },
  { name: "salmon", storage_method: "Freezer", category: "Fish and seafood", quantity: 2, unit: "pc(s)", expiration_days: 120 },
  { name: "cod", storage_method: "Freezer", category: "Fish and seafood", quantity: 2, unit: "pc(s)", expiration_days: 90 },
  { name: "mozzarella", storage_method: "Fridge", category: "Dairy and eggs", quantity: 250, unit: "g", expiration_days: 16 },
  { name: "greek yogurt", storage_method: "Fridge", category: "Dairy and eggs", quantity: 4, unit: "pc(s)", expiration_days: 10 },
  { name: "apple juice", storage_method: "Fridge", category: "Beverages", quantity: 1, unit: "l", expiration_days: 14 },
  { name: "orange soda", storage_method: "Dry", category: "Beverages", quantity: 1, unit: "l", expiration_days: 18 },
  { name: "chocolate bar", storage_method: "Dry", category: "Sweets", quantity: 2, unit: "pc(s)", expiration_days: 70 },
  { name: "cookie", storage_method: "Dry", category: "Sweets", quantity: 8, unit: "pc(s)", expiration_days: 25 },
  { name: "frozen pizza", storage_method: "Freezer", category: "Processed foods and ready meals", quantity: 1, unit: "pc(s)", expiration_days: 100 },
  { name: "mushroom", storage_method: "Fridge", category: "Vegetables", quantity: 250, unit: "g", expiration_days: 8 }
]

ingredients_data.each_with_index do |data, index|
  if File.exist?("app/assets/images/seed_ingredient_picto/#{data[:name]}.png")
    file_path = Rails.root.join("app/assets/images/seed_ingredient_picto/#{data[:name]}.png")
  else
    file_path = Rails.root.join("app/assets/images/shelfie maintenace.png")
  end

  ingredient = Ingredient.create!(
    name: data[:name],
    storage_method: data[:storage_method],
    category: data[:category]
  )

  ingredient.photo.attach(
    io: File.open(file_path),
    filename: "#{data[:name]}.png",
    content_type: "image/png"
  )

  HouseIngredient.create!(
    expiration_date: DateTime.now + data[:expiration_days],
    quantity: data[:quantity],
    unit: data[:unit],
    house_id: house1.id,
    ingredient_id: ingredient.id
  )

  puts "ingredient #{index + 1} (#{data[:name]}) added to cart 🛒"
end


puts "Groceries completed     🥕🍌"
