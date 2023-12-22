extends Control
@onready var play = $VBoxContainer/Play


# Called when the node enters the scene tree for the first time.
func _ready():
	play.grab_focus()
