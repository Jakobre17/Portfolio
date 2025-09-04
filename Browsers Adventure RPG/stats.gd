extends Node

signal no_health


@export var max_health = 1


@onready var health : int = max_health:
	get:
		return health
	set(value): 
		health = value
		



func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
		print("DEBUG: NO HEALTH SIGNAL SENT")



	
