extends Node

# Get nodes
@onready var animation_player = $AnimationPlayer
@onready var start = $Title/VBoxContainer/Start
@onready var exit = $Title/VBoxContainer/Exit
@onready var level_1_button = $Title/Level1

# Preload scenes
var gameScene = preload("res://Scenes/Game/game.tscn").instantiate()
var level_1 = preload("res://Scenes/Game/Levels/Level_1/level_1.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	start.grab_focus()
	level_1_button.hide()
	loadScene(gameScene, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Adds the instanced scene to the tree at a specifc location
func loadScene(instance, at):
	at.add_child(instance)

func _on_start_pressed():
	# Fix this garbage later
	level_1_button.show()
	level_1_button.grab_focus()
	$Title/VBoxContainer.hide()

func _on_exit_pressed():
	get_tree().quit()

func _on_level_1_pressed():
	# Load level 1, added to gamescene
	loadScene(level_1, gameScene)
	
	# Hide title for now
	$Title.hide()
	
	# Dissolve animation
	animation_player.play("Dissolve")
	await animation_player.animation_finished
	animation_player.play_backwards("Dissolve")
