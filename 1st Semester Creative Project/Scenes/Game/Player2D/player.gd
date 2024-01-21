extends CharacterBody2D

# Get nodes
@onready var sprite = $AnimatedSprite2D
@onready var attack_area = $attackArea

# Running variables
@export var runSpeed = 120.0

# Jump variables
@export var jumpHeight : float = 55
@export var jumpTimeToPeak : float = 0.295
@export var jumpTimeToDescent : float = 0.22

# Coyote jump variables
@export var coyoteTime : float = 0.16
var coyoteTimer = 0.0
var canJump : bool = true

# Wall jumping variables
@export var wallJumpPushback : float = 275
@export var wallJumpGravity : float = 90
var isWallSliding : bool

# Health variables
var MAXplayerHealth : float = 3
var playerHealth : float = 0

# Attack variables
var isAttacking = false

func _ready():
	# Set player's health to full
	playerHealth = MAXplayerHealth

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Input direction from player
	var direction = Input.get_axis("left", "right")
	
	jump(delta, direction)
	wallSlide(delta, direction)
	
	# Get horizontal velocity
	if direction:
		velocity.x = move_toward(velocity.x, direction * runSpeed, delta * 600)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * 600)
	
	# Clamp falling speed
	if velocity.y > 300:
		velocity.y = 300
	
	# Move and animate plater
	move_and_slide()
	attack(delta)
	
	# Check player health
	if playerHealth <= 0:
		
		die()
	
	animate(direction)

func jump(delta, direction):
	var jumpVelocity : float = -((2.0 * jumpHeight) / jumpTimeToPeak)
	var jumpGravity : float = -((-2.0 * jumpHeight) / pow(jumpTimeToPeak, 2.0))
	var fallGravity : float = -((-2.0 * jumpHeight) / pow(jumpTimeToDescent, 2.0))
	
	if not is_on_floor():
		# Apply gravity when in air
		velocity.y += getGravity(jumpGravity, fallGravity) * delta
		
		# Start the coyote timer since player has left floor
		coyoteTimer += delta
		
		# Player can still jump until the coyote timer goes over the time limit
		if coyoteTimer > coyoteTime:
			canJump = false
	else:
		# Player is on floor so they can jump and coyoteTimer is reset
		coyoteTimer = 0.0
		canJump = true
	
	# Jumping from ground
	if Input.is_action_pressed("jump"):
		if canJump:
			velocity.y = jumpVelocity
			canJump = false
	
	# Jumping off of a wall
	if Input.is_action_just_pressed("jump") and is_on_wall():
		# If player is on wall and pushing against it
		if direction != 0:
			velocity.y = jumpVelocity
			# Push off from the wall, oriented correctly
			if direction < 0:
				velocity.x = wallJumpPushback
			if direction > 0:
				velocity.x = -wallJumpPushback

func wallSlide(delta, direction):
	if is_on_wall() and !is_on_floor():
		if direction != 0:
			isWallSliding = true
	else:
		isWallSliding = false
	
	if isWallSliding:
		velocity.y += wallJumpGravity * delta
		velocity.y = min(velocity.y, wallJumpGravity)

func getGravity(jumpGravity, fallGravity):
	if velocity.y < 0.0: 
		return jumpGravity
	else:
		return fallGravity

func attack(_delta):
	attack_area.monitoring = false
	if Input.is_action_just_pressed("attack") and is_on_floor():
		print("Attacking")
		isAttacking = true
		attack_area.monitoring = true
		await sprite.animation_finished
		isAttacking = false
		attack_area.monitoring = false

func _on_attack_area_body_entered(body):
	if body.is_in_group("enemy"):
		body.health -= 2
		print("Enemy :", body.health)

func animate(direction):
	# Face sprite in the direction of movement
	if velocity.x > 0 or isWallSliding and direction < 0:
		sprite.flip_h = false
		attack_area.position = Vector2(22.564, 0.5)
	elif velocity.x < 0 or isWallSliding and direction > 0:
		sprite.flip_h = true
		attack_area.position = Vector2(-22.564, 0.5)
	
	# Play animations
	if isAttacking == true:
		sprite.play("Attack")
		await sprite.animation_finished
	elif isWallSliding == true:
		sprite.play("Wallslide")
	elif velocity.y < 0:
		sprite.play("Jump")
	elif velocity.y > 0:
		sprite.play("Fall")
	elif velocity.x != 0:
		sprite.play("Run")
	elif velocity == Vector2.ZERO:
		sprite.play("Idle")

func die():
	get_tree().reload_current_scene()
