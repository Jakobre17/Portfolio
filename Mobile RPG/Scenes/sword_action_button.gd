extends "res://ActionButton.gd"

const Slash = preload("res://Scenes/slash.tscn")

#Method called everytime sword button is pressed to deal damage
func _on_pressed():
	var enemy = BattleUnits.Enemy
	var playerStats = BattleUnits.PlayerStats
	if enemy != null and playerStats != null:
		create_slash(enemy.global_position)
		enemy.take_damage(4)
		playerStats.mp += 2
		playerStats.ap -= 1



func create_slash(position):
	var slash = Slash.instantiate()
	var main = get_tree().current_scene
	main.add_child(slash)
	slash.global_position = position
