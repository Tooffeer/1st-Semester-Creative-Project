extends Node2D

@onready var autoLoader = $"/root/Global"
var level_1 = preload("res://Scenes/Game/Levels/Level_1/level_1.tscn").instantiate()
var player = preload("res://Scenes/Game/Player2D/player.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	autoLoader.connect("loadPLayer", spawnPlayer)
	self.add_child(level_1)
	
	print("Game loaded")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
  
func loadLevel1():
	pass

func spawnPlayer(position):
	self.add_child(player)
	player.position = position
