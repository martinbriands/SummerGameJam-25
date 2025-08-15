extends Node3D

class_name Asteroid

var direction: Vector3
@export var speed: float

func set_destination(pos: Vector3):
    position = pos + pos.normalized() * 15
    
    direction = -pos.normalized()

func _process(delta: float) -> void:
    position += direction * delta * speed
