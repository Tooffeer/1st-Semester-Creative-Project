extends CharacterBody2D

const SPEED = 45

# Jumping
const JUMP_VELOCITY = -300
var canJump : bool = true
var coyote_timer = 0
var coyoteTime = 0.18

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") / 2


func _physics_process(delta):
	# Apply gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Determine coyote jump 
	if is_on_floor():
		canJump = true
		coyote_timer = 0
	else:
		coyote_timer += delta
		if coyote_timer > coyoteTime:
			canJump = false
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if canJump == true:
			jump()
			canJump = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func jump():
	velocity.y = JUMP_VELOCITY
