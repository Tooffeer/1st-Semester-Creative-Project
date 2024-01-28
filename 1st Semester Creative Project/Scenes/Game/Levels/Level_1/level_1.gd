extends Node2D

@onready var autoLoader = $"/root/Global"
@onready var spawner = $Spawners/Spawner
@onready var tile_map = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Level 1 loaded")
	autoLoader.emit_signal("loadPLayer", spawner.global_position)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.playerHealth -= 100

func _on_area_2d_2_body_entered(body):
	if body.is_in_group("player"):
		var x := [Vector2i(90, -13),Vector2i(90, -12),Vector2i(90, -11),Vector2i(90, -10), Vector2i(90, -9), Vector2i(90, -8), Vector2i(90, -7), Vector2i(90, -6)]
		for i in x:
			tile_map.set_cell(0, i, 1, Vector2i(2, 6))
