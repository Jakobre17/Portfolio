extends Panel
@onready var hpLabel = $HBoxContainer/HP
@onready var apLabel = $HBoxContainer/AP
@onready var mpLabel = $HBoxContainer/MP


func _on_player_stats_hp_changed(value):
	hpLabel.text = "HP\n"+str(value)


func _on_player_stats_ap_changed(value):
	apLabel.text = "AP\n"+str(value)


func _on_player_stats_mp_changed(value):
	mpLabel.text = "MP\n"+str(value)
