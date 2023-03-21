extends CharacterBody2D

# Movement

var lift : float
var weight : float = 5
var direction_x = 1 # Default fly to the right
var gliding_speed : float = 150
var target_speed_x : float
var target_speed_y : float
var acceleration : float
var key_pressed : int = 0
var cruising : bool = false
var u_turn : bool = false
var climbing : bool = false
var falling : bool = false

enum Movement_State {Gliding,Flapping,Turning,Soaring,Diving}
var state = Movement_State.Gliding
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Animation
var Anim_Node

func _ready():
	Anim_Node = $AnimatedSprite2D
	Anim_Node.animate_each_frame(velocity,state)
	
	velocity.x = gliding_speed
	_gliding() # Default gliding

func _input(event):
	if event.is_action_pressed("ui_right"):
		key_pressed += 1
		_flapping(1)
		
	if event.is_action_released("ui_right"):
		key_pressed -= 1
		if Input.is_action_pressed("ui_left"):
			_flapping(-1)
			
	
	if event.is_action_pressed("ui_left"):
		key_pressed += 1
		_flapping(-1)
		
	if event.is_action_released("ui_left"):
		key_pressed -= 1
		if Input.is_action_pressed("ui_right"):
			_flapping(1)
			
			
	if event.is_action_pressed("ui_up"):
		key_pressed += 1
		climbing = true
		Anim_Node._flapping()
		
	if event.is_action_released("ui_up"):
		key_pressed -= 1
		climbing = false

	if event.is_action_pressed("ui_down"):
		key_pressed += 1
		falling = true
		Anim_Node._gliding()
		
	if event.is_action_released("ui_down"):
		key_pressed -= 1
		falling = false

		
func _unhandled_input(event):
	pass

func _flapping(direction):
	state = Movement_State.Flapping
	direction_x = direction
	acceleration = 800
	target_speed_x = 350 * direction_x
	target_speed_y = -20
	lift = 50
	
	Anim_Node._flapping()

func _gliding():
	state = Movement_State.Gliding
	acceleration = 10
	target_speed_x = 200 * direction_x
	target_speed_y = 20
	lift = 50
	
	Anim_Node._gliding()

func _turning():
	if state != Movement_State.Turning:
		state = Movement_State.Turning
		target_speed_y = 0

func _soaring():
	state = Movement_State.Soaring
	acceleration = 200
	target_speed_y = -300
	lift = 300
	

func _diving():
	state = Movement_State.Diving
	acceleration = 400
	target_speed_y = 400
	lift = 500

func _physics_process(delta):
	if key_pressed == 0 and state != Movement_State.Gliding:
		_gliding()
		
	cruising = Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")
	
	if velocity.x * target_speed_x < 0 and cruising:
		u_turn = true
	elif velocity.x * target_speed_x > 0:
		u_turn = false
		if cruising:
			_flapping(Input.get_axis("ui_left","ui_right"))
			
	
	if u_turn:
		_turning()
		
	if climbing:
		_soaring()
	if falling:
		_diving()
	# Movement aiming for the target speed
	if velocity.x > target_speed_x :
		velocity.x -= acceleration * delta
		
	elif velocity.x < target_speed_x :
		velocity.x += acceleration * delta
		
	if velocity.y > target_speed_y:
		velocity.y -= lift * delta
	elif velocity.y < target_speed_y :
		velocity.y += lift * delta

	velocity.normalized()
	move_and_slide()
	

func _process(delta):
	# Animation
	if not u_turn:
		Anim_Node.animate_each_frame(velocity,state)
	

