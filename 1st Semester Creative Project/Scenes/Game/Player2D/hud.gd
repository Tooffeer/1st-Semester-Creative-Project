extends CanvasLayer

@onready var healthbar = $Control/VBoxContainer/Healthbar
@onready var label = $Control/VBoxContainer/Label

func _on_player_health_changed(C, value):
	healthbar.max_value = C
	healthbar.value = value

func _on_player_coin_changed(amount):
	label.text = "Coins: " + str(amount)
