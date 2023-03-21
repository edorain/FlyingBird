extends AnimatedSprite2D

var velocity : Vector2
var tilt : float
var max_tilt : float = PI/4
var fix_heading : Vector2 
var direction : float
# Called when the node enters the scene tree for the first time.
func _gliding():
	set_animation("glide")
	
func _flapping():
	set_animation("default")

func animate_each_frame(velocity,state):	
	direction = velocity.angle()
	
	if velocity.x > 0 and abs(direction) < max_tilt:
		flip_h = false
		fix_heading = Vector2(abs(velocity.x),velocity.y)
	elif velocity.x < 0 and abs(direction) > PI-max_tilt:
		flip_h = true
		fix_heading = Vector2(abs(velocity.x),velocity.y*-1)
		
	tilt = (rotation+fix_heading.angle())/2
	
	rotation = tilt
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
