extends Node3D

class_name AsteroidManager

static var instance: AsteroidManager

@export var asteroid_scene: PackedScene

func _ready() -> void:
    instance = self

func create_asteroid(destination: Vector3):
    var asteroid = asteroid_scene.instantiate() as Node3D
    add_child(asteroid)
    
    (asteroid as Asteroid).set_destination(destination)
