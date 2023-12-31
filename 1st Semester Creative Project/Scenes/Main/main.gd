extends Node

# Preload scenes
var gameScene = preload("res://Scenes/Game/game.tscn")
var level_1 = preload("res://Scenes/Game/Levels/Level_1/level_1.tscn")
var player = preload("res://Scenes/Game/Player2D/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Organize this later
func loadScene():
	# Get game scene
	var instance = gameScene.instantiate()
	player = player.instantiate()
	level_1 = level_1.instantiate()
	# Add scene to the tree
	self.add_child(instance)
	instance.add_child(level_1)
	instance.add_child(player)
	player.position = Vector2(0, -50)
