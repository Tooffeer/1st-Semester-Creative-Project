extends Node2D

@onready var autoLoader = $"/root/Global"
@onready var spawner = $Spawners/Spawner

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Level 1 loaded")
	autoLoader.emit_signal("loadPLayer", spawner.global_position)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.playerHealth -= 100
