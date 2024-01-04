extends CharacterBody2D

# Health variables
signal playerHealthChanged(amount : float)
var playerHealth : float = 4
var MAXplayerHealth : float = 3

# Running variables
@export var runSpeed = 120.0

# Jumping variables
@export var jumpHeight : float = 55
@export var jumpTimeToPeak : float = 0.265
@export var jumpTimeToDescent : float = 0.22
@export var coyoteTime : float = 0.16
@export var wallJumpPushback : float = 275
@export var wallJumpGravity : float = 90

@onready var jumpVelocity : float = -((2.0 * jumpHeight) / jumpTimeToPeak)
@onready var jumpGravity : float = -((-2.0 * jumpHeight) / pow(jumpTimeToPeak, 2.0))
@onready var fallGravity : float = -((-2.0 * jumpHeight) / pow(jumpTimeToDescent, 2.0))

var canJump : bool = true
var coyoteTimer = 0.0

var isWallSliding : bool

func _ready():
	# When player scene is created
	playerHealth = MAXplayerHealth

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Movement functions
	jump(delta)
	wallSlide(delta)
	
	# Get player input direction
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * runSpeed, delta * 500)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * 500)
	
	# Clamp falling velocity
	if velocity.y > 300:
		velocity.y = 300
	
	move_and_slide()
	
	# Health system
	if playerHealth <= 0:
		die()

func jump(delta):
	if not is_on_floor():
		# Apply gravity when in air
		velocity.y += get_gravity() * delta
		
		# Starts the coyote timer
		coyoteTimer += delta
		# Player can still jump until the coyote timer goes over the time limit
		if coyoteTimer > coyoteTime:
			canJump = false
	else:
		# Since player is grounded the coyoteTimer is reset and allows jump
		coyoteTimer = 0.0
		canJump = true
	
	# When player jumps
	if Input.is_action_just_pressed("jump"):
		# Jumping from floor
		if Input.is_action_pressed("jump"):
			if canJump:
				velocity.y = jumpVelocity
				canJump = false
			
		# Jumping off of a right wall
		if is_on_wall() and Input.is_action_pressed("right"):
			velocity.y = jumpVelocity
			velocity.x = -wallJumpPushback
		
		# Jumping off of a left wall
		if is_on_wall() and Input.is_action_pressed("left"):
			velocity.y = jumpVelocity
			velocity.x = wallJumpPushback

func wallSlide(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			isWallSliding = true
	else:
		isWallSliding = false
	
	if isWallSliding:
		velocity.y += wallJumpGravity * delta
		velocity.y = min(velocity.y, wallJumpGravity)

func get_gravity():
	return jumpGravity if velocity.y < 0.0 else fallGravity

func die():
	# Removes the player scene
	queue_free()
