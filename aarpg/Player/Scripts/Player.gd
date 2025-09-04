class_name Player extends CharacterBody2D

signal direction_changed( new_direction : Vector2 )
signal player_damaged( hurt_box : HurtBox )

# Var for direction Player is facing
var cardinal_direction : Vector2 = Vector2.DOWN
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]
# Var for direction Player is moving
var direction : Vector2 = Vector2.ZERO

var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6


# OnReady grabs the below nodes and sets a var equal to them
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var hit_box: HitBox = $HitBox
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine


signal DirectionChanged( new_direction: Vector2 )


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.Damaged.connect( _take_damage )
	update_hp(99)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( delta ):
	# Takes 2D directional input and calculates the x/y directions and vectors
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	pass



# Allows Player to move and slide against objects smoothly
func _physics_process( delta ):
	move_and_slide()


# Function for changing the direction variables
func SetDirection() -> bool:
	# If the direction the character hasnt changed then it remains zero and will not prompt a change
	if direction == Vector2.ZERO:
		return false
	
	# making var to decide which direction player is facing, using direction var and cardinal_direction
	# var as a means of getting the players last faced direction, and then finding the angle of the directions together
	# and then dividing it by SOMETHING? (TAU?) and then multiplying so that the final out put is a number 
	# 1--4 so that it can referance the different cardinal directions possible
	var direction_id : int = int( round( (direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[ direction_id ]
	
	# Then checks to make sure that the new dir the Player is facing hasn't changed from before
	# and then returns false to avoid setting new direction
	if new_dir == cardinal_direction:
		return false
	
	# Then globally updates the Players diection they are facing to the contained new direction
	cardinal_direction = new_dir
	
	DirectionChanged.emit( new_dir )
	# Flips the sprite based on x direction and any childs attached to it
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	# Finally returns True so that the function isn't skipped on each tick
	return true




# Function for setting the animation player to the current state and direction of the Player
func UpdateAnimation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection())
	pass


# Function that checks which direction the character should be facing and to update the UpdateAnimation func
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"


func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable == true:
		return
	update_hp( -hurt_box.damage )
	if hp > 0:
		player_damaged.emit( hurt_box )
	else:
		player_damaged.emit( hurt_box )
		update_hp(99)
	pass


func update_hp( delta : int ) -> void:
	hp = clampi( hp + delta, 0, max_hp )
	PlayerHud.update_hp(hp, max_hp )
	pass


func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer( _duration ).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass
