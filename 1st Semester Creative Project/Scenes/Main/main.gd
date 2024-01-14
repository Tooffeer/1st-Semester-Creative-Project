extends Node

# Get nodes
@onready var animation_player = $AnimationPlayer
@onready var start = $Title/VBoxContainer/Start
@onready var exit = $Title/VBoxContainer/Exit
@onready var audio_stream_player_2d = $Title/AudioStreamPlayer2D

# Preload scenes
var gameScene = preload("res://Scenes/Game/game.tscn").instantiate()


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main loaded")
	start.grab_focus()
	audio_stream_player_2d.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_start_pressed():
	animation_player.play("Dissolve")
	await animation_player.animation_finished
	
	self.add_child(gameScene)
	
	$Title.hide()

func _on_exit_pressed():
	get_tree().quit()
