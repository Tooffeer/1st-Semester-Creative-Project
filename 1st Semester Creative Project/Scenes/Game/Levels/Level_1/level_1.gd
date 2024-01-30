extends Node2D

@onready var autoLoader = $"/root/Global"
@onready var spawner = $Spawners/Spawner
@onready var tile_map = $TileMap
@onready var canvas_layer = $CanvasLayer
@onready var background_music = $"Background music"
@onready var battle_music = $"Battle Music"
@onready var end_music = $"End Music"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Level 1 loaded")
	canvas_layer.hide()
	autoLoader.emit_signal("loadPLayer", spawner.global_position)
	autoLoader.connect("endGame", startEnding)
	background_music.play()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.playerHealth -= 100

func _on_area_2d_2_body_entered(body):
	if body.is_in_group("player"):
		background_music.stop()
		battle_music.play()
		
		var x := [Vector2i(90, -13),Vector2i(90, -12),Vector2i(90, -11),Vector2i(90, -10), Vector2i(90, -9), Vector2i(90, -8), Vector2i(90, -7), Vector2i(90, -6)]
		for i in x:
			tile_map.set_cell(0, i, 1, Vector2i(2, 6))

func startEnding():
	battle_music.stop()
	end_music.play()
	canvas_layer.show()
