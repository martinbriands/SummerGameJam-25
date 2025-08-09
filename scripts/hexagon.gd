extends Node3D

class_name Hexagon
#func _ready() -> void:
    
    
func set_color(color: Color):
    var mesh = $Mesh as MeshInstance3D
    mesh.mesh.material.albedo_color = color
