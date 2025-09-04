extends Node

const BattleUnits = preload("res://Assets/MobileRPG Resources/BattleUnits.tres")

var max_hp = 25
var hp = max_hp:
	get:
		return hp
	set(value):
		hp = clamp(value, 0, max_hp)
		emit_signal("hp_changed", hp)

var max_ap = 3
var ap = max_ap:
	get:
		return ap
	set(value):
		ap = clamp(value,0, max_ap)
		emit_signal("ap_changed", ap)
		if ap == 0:
			emit_signal("end_turn")

var max_mp = 10
var mp = max_mp:
	get:
		return mp
	set(value):
		mp = clamp(value, 0, max_mp)
		emit_signal("mp_changed", mp)

signal hp_changed(value)
signal ap_changed(value)
signal mp_changed(value)
signal end_turn


func _ready():
	BattleUnits.PlayerStats = self

func _exit_tree():
	BattleUnits.PlayerStats = self
