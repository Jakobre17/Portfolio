extends Node

signal level_load_started
signal level_loaded
signal TileMapBoundsChanged( bounds : Array[ Vector2 ])

var current_tilemap_bounds : Array[ Vector2 ]
var target_transition : String
var position_offset : Vector2



func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()


func ChangeTilemapBounds( bounds : Array[ Vector2 ]) -> void:
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit( bounds )


# Function takes in 3 args to handle the change of scene
func load_new_level(
		level_path : String,
		_target_transition : String,
		_position_offset : Vector2
		) -> void:
	
	# Pauses the game while loading then sets the global transition object and its position to whats been
	#passed through the function
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	await SceneTransition.fade_out()
	
	#  emits a signal to tell game that its started loading new scene
	level_load_started.emit()
	
	# awaits for the tick after the scenes tree is loaded
	await get_tree().process_frame
	
	# Then changes the scene to the loaded scene file
	get_tree().change_scene_to_file( level_path )
	
	await SceneTransition.fade_in()
	
	# Unpauses the game
	get_tree().paused = false
	
	# Awaits til the tick of the new file
	await get_tree().process_frame
	
	# emits a global signal that the level has loaded
	level_loaded.emit()
	
	
	pass
