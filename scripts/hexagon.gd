extends Node3D

class_name Hexagon
#func _ready() -> void:

var parent_position: Vector3

func set_hexagon(parent: Node3D, pos: Vector3):
    position = pos
    look_at(parent.position)
    
    parent_position = parent.position
    
func apply_bounds(bounds_x: Vector2, bounds_y: Vector2):
    var x_span = (bounds_x.y - bounds_x.x) / 2
    var y_span = (bounds_y.y - bounds_y.x) / 2
    var map_position = Vector2(position.x + x_span, position.y + y_span)
    
    set_color(Color(map_position.y, map_position.x, 0, 1))
    
    
    
func set_color(color: Color):
    var mesh = $Mesh as MeshInstance3D
    mesh.mesh.material.albedo_color = color
