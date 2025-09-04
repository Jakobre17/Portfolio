extends Node

@onready var points_label = %PointsLabel

var points = 0

func add_points():
	points += 1
	print(points)
	points_label.text = "POINTS: " + str(points)

