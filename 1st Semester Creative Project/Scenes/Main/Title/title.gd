extends Control

@onready var startButton = $VBoxContainer/Start

# Called when the node enters the scene tree for the first time.
func _ready():
	startButton.grab_focus()
