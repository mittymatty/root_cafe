extends Control

var current_page: int = 0

var recipes = [
	{
		"name": "Flat white",
		"instructions": "Drag the cup under coffee machine, then add milk.",
		"image": "res://assets/imports/placeholders/flat-white-d8ada0f.png",
		"recipe_data": "res://resources/recipes/flat_white.tres"
	},
	
	{
		"name": "Black Coffee",
		"instructions": "Drag the cup under the coffee machine.",
		"image": "res://assets/imports/placeholders/Screenshot 2026-09-27 173633.png",
		"recipe_data": "res://resources/recipes/black_coffee.tres"
	},
	
	{
		"name": "Hot Cocoa",
		"instructions": "Combine milk + cocoa and water in any order.",
		"image": "res://assets/imports/placeholders/Screenshot 2026-09-25 213811.png",
		"recipe_data": "res://resources/recipes/hot_cocoa.tres"
	},
	
	#{
		#"name": "Coffee",
		#"ingredients": ["Water :    %50", "Coffee :    %50"],
		#"instructions": "Drag the cup under the coffee maker, then add water",
		#"image": "res://assets/imports/placeholders/images (1).png",
		#"recipe_data": "res://resources/recipes/coffee.tres"
	#},
	
	{
		"name": "Mochaccino (Mocha)",
		"instructions": "Drag the cup under coffee machine, then add milk and cocoa.",
		"image": "res://assets/imports/placeholders/images (2).png",
		"recipe_data": "res://resources/recipes/mocha.tres"
	},
	
	{
		"name": "Chai Latte",
		"instructions": "Combine water, mixed spice, and milk.",
		"image": "res://assets/visuals/chailatte.jpg",
		"recipe_data": "res://resources/recipes/chai_latte.tres"
	},
]

@onready var drink_name: Label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/LeftColumn/DrinkName
@onready var ingredients: Label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/LeftColumn/Ingredients
@onready var instructions: Label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/LeftColumn/Instructions
@onready var texture_rect: TextureRect = $Panel/MarginContainer/VBoxContainer/HBoxContainer/LeftColumn/TextureRect

@onready var prev_button: Button = $Panel/Controls/PreviousButton
@onready var next_button: Button = $Panel/Controls/NextButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_current_recipe()
	
func display_current_recipe() -> void:
	var recipe = recipes[current_page]
	var recipe_data : RecipeData = load(recipe["recipe_data"])
	
	drink_name.text = "~~" + recipe_data.drink_name + "~~" #"Drink: "+ str(recipe["name"])
	instructions.text = "Instructions:\n "+ str(recipe["instructions"])
	
	if recipe.has("recipe_data"): # This is what Matthew changed
		
		ingredients.text = ""
		for ingredient_name in recipe_data.required_ingredients:
			ingredients.text += "- " + ingredient_name +  ": At least " + str(int(recipe_data.required_ingredients[ingredient_name])) +"% \n"
	
	if recipe.has("image") and FileAccess.file_exists(recipe["image"]):
		texture_rect.texture = load(recipe["image"])
	else:
		texture_rect.texture = null
	
	
	prev_button.disabled = (current_page == 0)
	next_button.disabled = (current_page >= recipes.size()-1)
	
	
func _on_previous_button_pressed() -> void:
	if current_page > 0:
		current_page -= 1
		display_current_recipe()

func _on_next_button_pressed() -> void:
	if current_page < recipes.size() -1:
		current_page += 1
		display_current_recipe()

func _on_close_button_pressed() -> void:
	hide()
