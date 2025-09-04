extends CharacterBody2D


#Setting constants that will help with world physics
@export var ACCELERATION = 500
@export var MAX_SPEED = 77
@export var FRICTION = 750
@export var ROLL_SPEED = 117


#Player state machine enum constants
enum{
	MOVE,
	ROLL,
	ATTACK
}


#Variables set
var state = MOVE
var roll_vector = Vector2.DOWN
var stats = PlayerStats


#Variables that need to wait t be set onReady
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitbox = $HitboxPivot/SwordHitbox
@onready var hurtbox = $Hurtbox







#When everything is loaded and ready run this
func _ready():
	stats.connect("no_health", Callable(self, "queue_free"))
	print("DEBUG NO HEALTH CONNECTION MADE")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector




#On every interaction with physics environment (constantly basically)
func _physics_process(delta):
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
			
		
	
	





#Method for setting the state to moving
func move_state(delta):
	#Variable vector that is used to manipulate position based on input
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	
	
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	
	move()
	
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	





func attack_state(delta):

	velocity = Vector2.ZERO
	animationState.travel("Attack")
	

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()


func move():
	#control players movement and using delta to help edge lag spikes
	move_and_slide()



func attack_animation_finished():
	state = MOVE
	
func roll_animation_finished():
	velocity = velocity * .7
	state = MOVE
	


func _on_hurtbox_area_entered(area):
	stats.health -= 1
	stats.set_health(stats.health)
	print("DEBUG PLAYER HURTBOX ENTERED")
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
