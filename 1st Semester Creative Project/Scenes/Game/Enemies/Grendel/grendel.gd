extends CharacterBody2D

# Get nodes
@onready var sprite = $AnimatedSprite2D
@onready var stun_timer = $StunTimer

# Health
@export var health = 2

# Movement 
var direction = 0
@export var speed = 350.0
var charging = false
var attacking = false

var player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var fireball = preload("res://Scenes/Game/Enemies/Grendel/fireball.tscn")

func _physics_process(delta):
	# Apply gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Move in the direction of movement
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, delta * 500)
	else:
		velocity.x = move_toward(velocity.x, 0.0, delta * 400)
	
	# Detect if bumping into wall
	if is_on_wall() and charging:
		# Knockback off of wall
		var knockback = Vector2(-direction * speed, -310)
		velocity = knockback
		
		stunned()
	
	move_and_slide()
	animate()
	
	if health <= 0:
		die()

func _on_player_detection_body_entered(body):
	if body.is_in_group("player") and attacking == false:
		player = body
		attacking = false
		
		charge()

func charge():
	charging = true
	
	# Determine if player is on the right or left side of Grendel
	if ((position.x - player.position.x) > 0):
		direction = -1
	elif ((position.x - player.position.x) < 0):
		direction = 1
	
	launchFireball()
	
	sprite.play("Charge")

func stunned():
	# No longer moving
	charging = false
	direction = 0
	sprite.play("Stun Fall")
	await sprite.animation_finished
	sprite.play("Stunned")
	# Stunnesd for a moment
	stun_timer.start()
	await stun_timer.timeout
	
	
	charge()
	 
func launchFireball():
	var x = fireball.instantiate()
	var f = (player.global_position - global_position).normalized()
	print(rad_to_deg(f.angle()))
	
	
	x.global_position = global_position
	x.global_rotation = f.angle()
	
	add_child(x)

func animate():
	# Flip sprite in the direction of movement. 
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false

func die():
	direction = 0
	sprite.play("Die")
	await sprite.animation_finished
	queue_free()
