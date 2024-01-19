extends CharacterBody2D

# Get nodes
@onready var hitbox = $Hitbox
@onready var gpu_particles_2d = $GPUParticles2D

# Signals
signal healthChanged

@export var health = 3
@export var damage = 1
@export var x = health

@export var cooldown = 0.7
var cooldownTimer = 0.0
var playerInRange = false
var isAttacking = false
var player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	if health != x:
		gpu_particles_2d.emitting = true
		x = health
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	
	attack(delta)
	
	# Check health
	if health <= 0:
		die()

func attack(delta):
	cooldownTimer  += delta
	
	if playerInRange and cooldownTimer > cooldown:
		player.playerHealth -= damage
		cooldownTimer = 0.0
		print("Player: ", player.playerHealth)

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		playerInRange = true
		player = body

func _on_hitbox_body_exited(body):
	if body.is_in_group("player"):
		playerInRange = false

func die():
	queue_free()
