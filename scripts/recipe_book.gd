extends Control

var current_page: int = 0

var recipes = [
	{
		"name": "Hot Cocoa",
		"ingredients": ["Milk :   10% ", "Cocoa :   10%","Water :   50%"],
		"instructions": "Combine milk + cocoa and water in any order",
		"image": "res://assets/imports/placeholders/Screenshot 2026-09-25 213811.png"
	},
	{
		"name": "Black Coffee",
		"ingredients": ["Coffee :   %70"],
		"instructions": "Put the cup in the coffee machine",
		"image": "res://assets/imports/placeholders/Screenshot 2026-09-27 173633.png"
	},
	
	{
		"name": "Coffee",
		"ingredients": ["Water :    %50", "Coffee :    %50"],
		"instructions": "Put the cup in the coffee maker , then add water",
		"image": "res://assets/imports/placeholders/images (1).png"
	},
	{
		"name": "Flat white",
		"ingredients": ["Milk:    %20", "Coffee :    %70"],
		"instructions": "Put cup in coffee machine, then add milk",
		"image": "res://assets/imports/placeholders/flat-white-d8ada0f.png"
	},
	{
		"name": "Mocha / Mochaccino",
		"ingredients": ["Milk:    %10", "Coffee :    %60","Cocoa :    %10"],
		"instructions": "Put cup in coffee machine, then add milk and Cocoa",
		"image": "res://assets/imports/placeholders/images (2).png"
	},
]

@onready var drink_name: Label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/LeftColumn/DrinkName
@onready var ingredients: Label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/LeftColumn/Ingredients
@onready var instructions: Label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/LeftColumn/Instructions
@onready var texture_rect: TextureRect = $Panel/MarginContainer/VBoxContainer/HBoxContainer/RightColumn/TextureRect

@onready var prev_button: Button =$Panel/MarginContainer/VBoxContainer/Controls/PreviousButton
@onready var next_button: Button =$Panel/MarginContainer/VBoxContainer/Controls/NextButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_current_recipe()
	
func display_current_recipe() -> void:
	var recipe = recipes[current_page]
	
	drink_name.text = "DRINK NAME:"+ str(recipe["name"])
	instructions.text = "Instructions:\n"+ str(recipe["instructions"])
	
	var ingredients_text = "ingredients:\n"
	for item in recipe["ingredients"]:
		ingredients_text += "- "+item +"\n"
	ingredients.text = ingredients_text
	
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
