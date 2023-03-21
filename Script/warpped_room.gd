extends Node

var screen_size
@export var warpable_obj : Node

var db_obj

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size
	db_obj = $Bird


func _on_visible_on_screen_notifier_2d_screen_exited():
	warpable_obj.position.x = wrapf(warpable_obj.position.x, 0, screen_size.x)
	warpable_obj.position.y = wrapf(warpable_obj.position.y, 0, screen_size.y)

func _process(delta):
	# Debug label
	$DebugNode/Label.text = "State " + str(db_obj.state) + "
	Animation " + str(db_obj.Anim_Node.get_animation()) + "
	Animation playing " + str(db_obj.Anim_Node.is_playing()) + "
	Velocity " + str (db_obj.velocity) + "
	Rotation " + str (db_obj.Anim_Node.rotation) + "
	abs(tilt) " + str (abs(db_obj.Anim_Node.tilt))
