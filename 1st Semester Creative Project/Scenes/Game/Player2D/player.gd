extends CharacterBody2D

# Running variables
@export var runSpeed = 52.0

# Jumping variables
@export var jumpHeight : float
@export var jumpTimeToPeak : float
@export var jumpTimeToDescent : float
@export var coyoteTime : float = 0.16
@export var wallJumpPushback : float = 250
@export var wallJumpGravity : float = 90

@onready var jumpVelocity : float = -((2.0 * jumpHeight) / jumpTimeToPeak)
@onready var jumpGravity : float = -((-2.0 * jumpHeight) / pow(jumpTimeToPeak, 2.0))
@onready var fallGravity : float = -((-2.0 * jumpHeight) / pow(jumpTimeToDescent, 2.0))

var canJump : bool = true
var coyoteTimer = 0.0

var wallSliding : bool


func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	jump(delta)
	wallSlide(delta)
	# Get player input direction
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * runSpeed, delta * 500)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * 500)
	
	print(velocity.x)
	
	# Clamp fall velocity
	if velocity.y > 300:
		velocity.y = 300
	
	move_and_slide()
 
func getGravity():
	return jumpGravity if velocity.y < 0.0 else fallGravity

func jump(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += getGravity() * delta
		
		coyoteTimer += delta
		if coyoteTimer > coyoteTime:
			canJump = false
	else:
		coyoteTimer = 0.0
		canJump = true
	
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
			wallSliding = true
	else:
		wallSliding = false
	
	if wallSliding:
		velocity.y += wallJumpGravity * delta
		velocity.y = min(velocity.y, wallJumpGravity)
