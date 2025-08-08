extends Node3D

var isClicking
var previousMousePos: Vector2 

@export var rotationSpeed: float

func _input(event):
    if event is InputEventMouseButton:
        if event.pressed:
            isClicking = true
            previousMousePos = event.position
        else:
            isClicking = false
        print("Mouse Click/Unclick at: ", event.position)
    elif event is InputEventMouseMotion:
        if isClicking:
            print("Mouse Motion at: ", event.position)
            var delta = previousMousePos - event.position
            
            delta = delta / rotationSpeed
            
            rotate_object_local(Vector3.UP, delta.x)
            rotate_object_local(Vector3.RIGHT, delta.y)
            
            previousMousePos = event.position

            

    
