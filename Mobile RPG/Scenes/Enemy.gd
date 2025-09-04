extends Node2D

const BattleUnits = preload("res://Assets/MobileRPG Resources/BattleUnits.tres")


@onready var hpLabel = $HPLabel
@onready var animation_player = $AnimationPlayer

signal died
signal end_turn

var target = null

@export var attackDamage = 3
@export var hp = 25:
	get:
		return hp
	set(new_hp):
		hp = new_hp
		if hpLabel != null:
			hpLabel.text = str(hp) + "HP" 
		
		if hp <= 0:
			emit_signal("died")
			queue_free()



func _ready():
	BattleUnits.Enemy = self
	

func _exit_tree():
	BattleUnits.Enemy = null
	


func attack() -> void:
	await get_tree().create_timer(0.4).timeout
	animation_player.play("Attack")
	await animation_player.animation_finished
	emit_signal("end_turn")
	

func deal_damage(amount):
	BattleUnits.PlayerStats.hp -= 4
	

func take_damage(amount):
	self.hp -= amount
	if is_dead():
		emit_signal("died")
		queue_free()
	else:
		animation_player.play("Shake")
		

func is_dead():
	return hp <= 0
	
