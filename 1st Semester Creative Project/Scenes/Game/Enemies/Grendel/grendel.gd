extends CharacterBody2D

# Get nodes
@onready var sprite = $AnimatedSprite2D
@onready var stun_timer = $StunTimer
@onready var gpu_particles_2d = $GPUParticles2D
@onready var cooldown = $Cooldown
@onready var autoLoader = $"/root/Global"
@onready var hit_wall_sound = $HitWallSound

# Health
@export var totalHealth = 37
var health = totalHealth
var prevHealth = health

# Movement
var direction = 0
@export var speed = 200.0
@export var speed2 = 300.0
@export var speed3 = 400.0
@export var stunTime = 4.0
@export var stunTime2 = 3.0
@export var stunTime3 = 2.0
var currentSpeed = speed
var charging = false
var attacking = false

@export var damage = 1
var canAttack = false
var player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var fireball = preload("res://Scenes/Game/Enemies/Grendel/fireball.tscn")

func _physics_process(delta):
	# Apply gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if health >= (totalHealth * 3/4):
		currentSpeed = speed
		stun_timer.wait_time = stunTime
	elif health >= (totalHealth * 2/4):
		currentSpeed = speed2
		stun_timer.wait_time = stunTime2
	elif health >= (totalHealth * 1/4):
		currentSpeed = speed3
		stun_timer.wait_time = stunTime3
	
	if health != prevHealth:
		prevHealth = health
		gpu_particles_2d.emitting = true
	
	# Move in the direction of movement
	if direction:
		velocity.x = move_toward(velocity.x, direction * currentSpeed, delta * 500)
	else:
		velocity.x = move_toward(velocity.x, 0.0, delta * 400)
	
	# Detect if bumping into wall
	if is_on_wall() and charging:
		# Knockback off of wall
		var knockback = Vector2(-direction * currentSpeed, -310)
		velocity = knockback
		hit_wall_sound.play()
		stunned()
	
	move_and_slide()
	animate()
	
	if canAttack == true and health > 0:
		attack()
	
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
 
# Not working rn
func launchFireball():
	var x = fireball.instantiate()
	var f = (player.global_position - global_position).normalized()
	
	
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
	autoLoader.emit_signal("endGame")
	queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		canAttack = true

func attack():
	if cooldown.is_stopped() and canAttack == true:
		player.playerHealth -= damage
		cooldown.start()

func _on_hitbox_body_exited(body):
	if body.is_in_group("player"):
		canAttack = false
