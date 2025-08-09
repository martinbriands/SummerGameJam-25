extends Node3D

class_name Hexagon
#func _ready() -> void:

enum layers {
    BLACK = 0,
    BLUE = 1,
    AQUA = 2,
    GREEN = 3,
    RED = 4,
    FUCSHIA = 5,
    WHITE = 6
}

var parent_position: Vector3

func set_hexagon(parent: Node3D, pos: Vector3):
    position = pos
    look_at(parent.position)
    
    parent_position = parent.position
    
func apply_bounds(bounds_x: Vector2, bounds_y: Vector2, bounds_z: Vector2, data: Image):    
    var lat = rad_to_deg(atan2(position.z,sqrt(position.x*position.x+position.y*position.y)))
    var lng =  rad_to_deg(atan2(position.y, position.x))
    
    var x = clampf(data.get_height() * (180 + lng) / 360, 0, 255)
    var y = clampf(data.get_width() * (90 - lat) / 180, 0, 255)
    
    #print(Vector2(x, y), data.get_height())
    
    var color = data.get_pixel(x, y)
    set_color(color)
    
    var layer = color_to_enum(color)
    
    #print(layer)
    
    position += layer * (position - parent_position).normalized() / 60
    
func set_color(color: Color):
    var mesh = $Mesh as MeshInstance3D
    mesh.mesh.material.albedo_color = color
    
func color_to_enum(color: Color):
    #print(color)
    
    if color == Color.BLACK:
        return layers.BLACK
    if color == Color.AQUA:
        return layers.AQUA
    if color == Color.BLUE:
        return layers.BLUE
    if color == Color.GREEN:
        return layers.GREEN
    if color == Color.RED:
        return layers.RED
    if color == Color.FUCHSIA:
        return layers.FUCSHIA
    if color == Color.WHITE:
        return layers.WHITE
    
    return layers.WHITE

var hovering: bool
var pressed: bool

#func _on_static_body_3d_input_event(camera, event, event_position, normal, shape_idx):
    #if event is InputEventMouseButton:
        #if event.pressed:
            #print("hexagon clicked")
            #queue_free()
            #
func _input(event):
    if hovering and event is InputEventMouseButton:
        
        if event.pressed:
            pressed = true
        elif pressed:
            queue_free()

func _on_static_body_3d_mouse_entered():
    hovering = true

func _on_static_body_3d_mouse_exited():
    hovering = false
    pressed = false
