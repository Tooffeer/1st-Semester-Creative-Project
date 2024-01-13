extends Node
class_name Singleton

signal loadPLayer(position)

var player = preload("res://Scenes/Game/Player2D/player.tscn").instantiate()

func _ready():
	connect("loadPLayer", spawnPlayer)

func spawnPlayer(position):
	self.add_child(player)
	player.position = position
