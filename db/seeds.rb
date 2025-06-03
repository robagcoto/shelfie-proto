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

# ----------------------------------------------------------------------------------------------------------------------

# 2. Recipe seeds

puts "creating recipe sample 🍔"

file1 = URI.parse("https://www.fromager.net/wp-content/uploads/2023/12/recette-pates-carbonara.jpg").open

steps1 = [
  "Boil water, salt it generously, and cook spaghetti until al dente. Reserve 1 cup of pasta water before draining.",
  "In a pan, cook pancetta/guanciale over medium heat until crispy. Turn off the heat once done.",
  "In a bowl, whisk together the egg yolks, whole egg, cheese, and a generous amount of black pepper.",
  "Add the hot pasta to the pan with pancetta. Quickly toss.",
  "Immediately stir in the egg mixture, tossing fast so the eggs coat the pasta without scrambling. Add pasta water bit by bit to make it creamy.",
  "Serve right away with extra cheese and black pepper on top."
]

recipe1 = Recipe.new(
  name: "Spaghetti Carbonara",
  description: "The creamy, cheesy, bacon-hugged pasta that thinks it's too cool for cream !",
  duration: 20,
  category: "Italian",
  rating: 5,
  user: user1
)

steps1.each do |step|
  Step.create(recipe: recipe1, description: step)
end

recipe1.photo.attach(
  io: file1, filename: "carbo.jpg", content_type: "image/jpg"
)

recipe1.save!


IngredientsRecipe.create!(name: "spaghetti", quantity: 200, unit: "g", recipe_id: recipe1.id)
IngredientsRecipe.create!(name: "eggs", quantity: 2, unit: "pc(s)", recipe_id: recipe1.id)
IngredientsRecipe.create!(name: "cheese", quantity: 100, unit: "g", recipe_id: recipe1.id)
IngredientsRecipe.create!(name: "bacon", quantity: 100, unit: "g", recipe_id: recipe1.id)

# ----------------------------------------------------------------------------------------------------------------------

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
  user: user1
)

steps2.each do |step|
  Step.create(recipe: recipe2, description: step)
end

recipe2.photo.attach(
  io: file2, filename: "chicken.jpg", content_type: "image/jpg"
)

recipe2.save!

IngredientsRecipe.create!(name: "chicken", quantity: 300, unit: "g", recipe_id: recipe2.id)
IngredientsRecipe.create!(name: "cream", quantity: 100, unit: "l", recipe_id: recipe2.id)
IngredientsRecipe.create!(name: "tomato", quantity: 150, unit: "g", recipe_id: recipe2.id)
IngredientsRecipe.create!(name: "spices", quantity: 20, unit: "g", recipe_id: recipe2.id)

# ----------------------------------------------------------------------------------------------------------------------

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
  user: user1
)

steps3.each do |step|
  Step.create(recipe: recipe3, description: step)
end

recipe3.photo.attach(
  io: file3, filename: "sushi.jpg", content_type: "image/jpg"
)

recipe3.save!

IngredientsRecipe.create!(name: "rice", quantity: 200, unit: "g", recipe_id: recipe3.id)
IngredientsRecipe.create!(name: "seaweed", quantity: 4, unit: "pc(s)", recipe_id: recipe3.id)
IngredientsRecipe.create!(name: "salmon", quantity: 150, unit: "g", recipe_id: recipe3.id)
IngredientsRecipe.create!(name: "avocado", quantity: 1, unit: "pc(s)", recipe_id: recipe3.id)

# ----------------------------------------------------------------------------------------------------------------------

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
  user: user1
)

steps4.each do |step|
  Step.create(recipe: recipe4, description: step)
end

recipe4.photo.attach(
  io: file4, filename: "guacamole.jpg", content_type: "image/jpg"
)

recipe4.save!

IngredientsRecipe.create!(name: "avocado", quantity: 2, unit: "pc(s)", recipe_id: recipe4.id)
IngredientsRecipe.create!(name: "lime", quantity: 1, unit: "pc(s)", recipe_id: recipe4.id)
IngredientsRecipe.create!(name: "onion", quantity: 0.5, unit: "pc(s)", recipe_id: recipe4.id)
IngredientsRecipe.create!(name: "cilantro", quantity: 10, unit: "g", recipe_id: recipe4.id)

# ----------------------------------------------------------------------------------------------------------------------

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
  user: user1
)

steps5.each do |step|
  Step.create(recipe: recipe5, description: step)
end

recipe5.photo.attach(
  io: file5, filename: "ratatouille.jpg", content_type: "image/jpg"
)
recipe5.save!

IngredientsRecipe.create!(name: "zucchini", quantity: 1, unit: "pc(s)", recipe_id: recipe5.id)
IngredientsRecipe.create!(name: "eggplant", quantity: 1, unit: "pc(s)", recipe_id: recipe5.id)
IngredientsRecipe.create!(name: "pepper", quantity: 1, unit: "pc(s)", recipe_id: recipe5.id)
IngredientsRecipe.create!(name: "tomato", quantity: 2, unit: "pc(s)", recipe_id: recipe5.id)

# ----------------------------------------------------------------------------------------------------------------------

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
  user: user1
)

steps6.each do |step|
  Step.create(recipe: recipe6, description: step)
end

recipe6.photo.attach(
  io: file6, filename: "tacos.jpg", content_type: "image/jpg"
)

recipe6.save!
IngredientsRecipe.create!(name: "pork", quantity: 250, unit: "g", recipe_id: recipe6.id)
IngredientsRecipe.create!(name: "pineapple", quantity: 100, unit: "g", recipe_id: recipe6.id)
IngredientsRecipe.create!(name: "tortilla", quantity: 3, unit: "pc(s)", recipe_id: recipe6.id)
IngredientsRecipe.create!(name: "chili", quantity: 10, unit: "g", recipe_id: recipe6.id)

# ----------------------------------------------------------------------------------------------------------------------

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
  user: user1
)

steps7.each do |step|
  Step.create(recipe: recipe7, description: step)
end

recipe7.photo.attach(
  io: file7, filename: "miso.jpg", content_type: "image/jpg"
)

recipe7.save!

IngredientsRecipe.create!(name: "miso paste", quantity: 30, unit: "g", recipe_id: recipe7.id)
IngredientsRecipe.create!(name: "tofu", quantity: 100, unit: "g", recipe_id: recipe7.id)
IngredientsRecipe.create!(name: "seaweed", quantity: 10, unit: "g", recipe_id: recipe7.id)
IngredientsRecipe.create!(name: "green onion", quantity: 1, unit: "pc(s)", recipe_id: recipe7.id)

# ----------------------------------------------------------------------------------------------------------------------

puts "Recipes sample created with ingredients created 🍔"
puts "Go check in your console 🪴"


puts "creating message..."

Chat.create!(title: "harry potter recipe", user_id: 1)
Message.create!(prompt: "harry potter mood !!", user_id: 1, role: "user", chat_id: 1)

puts "chat created 📨"
