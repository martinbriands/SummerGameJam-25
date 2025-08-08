extends Node2D

var isClicking
@export var line2D: Line2D

var points: Array[Vector2] = []
var pointsMax = 20
var minDistanceForNewPoint = 50

func _input(event):
    # Mouse in viewport coordinates.
    if event is InputEventMouseButton:
        if event.pressed:
            isClicking = true
        else:
            isClicking = false
        print("Mouse Click/Unclick at: ", event.position)
    elif event is InputEventMouseMotion:
        if isClicking:
            print("Mouse Motion at: ", event.position)
            
            if points.is_empty():
                points.push_front(event.position)
                line2D.points = points
            elif points.back().distance_to(event.position) >= minDistanceForNewPoint:
                points.pop_back()
                points.push_front(event.position)
                line2D.points = points
            else:
                print("Mouse Motion at: ", points.back().distance_to(event.position))

                
        
