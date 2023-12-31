extends Control

signal levelSelected

@onready var startButton = $VBoxContainer/Start
@onready var level_1 = $LevelContainer/Level1

# Called when the node enters the scene tree for the first time.
func _ready():
	startButton.grab_focus()


func _process(delta):
	pass 

func _on_start_pressed():
	level_1.grab_focus()

func _on_exit_pressed():
	get_tree().quit()

func _on_level_1_pressed():
	print("Clicked")
