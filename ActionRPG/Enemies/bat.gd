extends CharacterBody2D


@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var sprite = $AnimatedSprite
@onready var hurtbox = $Hurtbox


const KNOCKBACK_SPEED = 300
const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")


@export var ACCELERATION = 500
@export var MAX_SPEED = 30
@export var FRICTION = 300



enum {
	IDLE,
	WONDER,
	CHASE
}

var state = CHASE





func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, KNOCKBACK_SPEED * delta)
	move_and_slide()
	
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WONDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	move_and_slide()
	


func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE


func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * 170
	hurtbox.create_hit_effect()
	



func _on_stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
