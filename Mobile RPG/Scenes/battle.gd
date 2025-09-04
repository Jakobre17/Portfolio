extends Node

const BattleUnits = preload("res://Assets/MobileRPG Resources/BattleUnits.tres")

@export var enemies:Array[PackedScene]


@onready var battle_action_buttons = $UI/BattleActionButtons
@onready var animation_player = $AnimationPlayer
@onready var next_room_button = $UI/CenterContainer/NextRoomButton
@onready var enemy_position = $EnemyPosition




func _ready():
	randomize()
	start_player_turn()
	var enemy = BattleUnits.Enemy
	if enemy != null:
		enemy.died.connect(_on_enemy_died)


func start_enemy_turn():
	battle_action_buttons.hide()
	var enemy = BattleUnits.Enemy
	if enemy!= null and not enemy.is_queued_for_deletion():
		enemy.attack()
		await enemy.end_turn
	start_player_turn()
	

func start_player_turn():
	battle_action_buttons.show()
	var player_stats = BattleUnits.PlayerStats
	player_stats.ap = player_stats.max_ap
	await player_stats.end_turn
	start_enemy_turn()
	

func create_new_enemy():
	enemies.shuffle()
	var Enemy = enemies.front()
	var enemy = Enemy.instantiate()
	enemy_position.add_child(enemy)
	enemy.died.connect(_on_enemy_died)
	

func _on_enemy_died():
	next_room_button.show()
	battle_action_buttons.hide()

func _on_next_room_button_pressed():
	next_room_button.hide()
	animation_player.play("FadeToNewRoom")
	await animation_player.animation_finished
	var playerStats = BattleUnits.PlayerStats
	playerStats.ap = playerStats.max_ap
	battle_action_buttons.show()
	create_new_enemy()
