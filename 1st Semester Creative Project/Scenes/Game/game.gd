extends Node2D

var player = preload("res://Scenes/Game/Player2D/player.tscn").instantiate()
@onready var camera_anchor = $CameraAnchor

signal playerDead

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("playerDead", spawnPlayer)
	self.emit_signal("playerDead")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var test = get_node("/root/Global")
	#test.emit_signal("playerDead")
	cameraPosition()
	pass

func spawnPlayer():
	self.add_child(player)
	player.position = Vector2(0, -399)
	camera_anchor.position = player.position

func cameraPosition():
	if player.is_inside_tree():
		camera_anchor.position = player.position
