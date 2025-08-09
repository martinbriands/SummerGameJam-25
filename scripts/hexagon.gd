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

var origin: Vector3
var normal: Vector3
var layer: layers

func set_hexagon(parent: Node3D, pos: Vector3):
    position = pos
    look_at(parent.position)
    
    parent_position = parent.position
    
func apply_bounds(bounds_x: Vector2, bounds_y: Vector2, bounds_z: Vector2, data: Image):    
    var lat = rad_to_deg(atan2(position.z,sqrt(position.x*position.x+position.y*position.y)))
    var lng =  rad_to_deg(atan2(position.y, position.x))
    
    var x = clampf(data.get_height() * (180 + lng) / 360, 0, 255)
    var y = clampf(data.get_width() * (90 - lat) / 180, 0, 255)
        
    var color = data.get_pixel(x, y)
    layer = color_to_enum(color)
    set_color(color)
    
    
    if layer == layers.WHITE:
        current_health = max_health
    
    origin = position
    normal = (origin - parent_position).normalized()
    
    position += layer * normal / 60
    
func set_color(color: Color):
    var mesh = $Mesh as MeshInstance3D
    mesh.mesh.material.albedo_color = color
    
    if layer == layers.BLACK:
        visible = false
    
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
    
var human: Node3D
func spawn_human(humanNode: Node3D):
    human = humanNode
    add_child(human)
    
    human.look_at(parent_position)
    human.position += (position - parent_position).normalized() * 0.025
    

var hovering: bool
var pressed: bool

var ice_scale: float = 1.0
@export var ice_speed: float
@export var max_health: int

var current_health

func _input(event):
    if hovering and event is InputEventMouseButton:
        if event.pressed:
            pressed = true
        elif pressed:
            tile_clicked()

func _on_static_body_3d_mouse_entered():
    hovering = true

func _on_static_body_3d_mouse_exited():
    hovering = false
    pressed = false
    
func tile_clicked():
    if layer == layers.WHITE and current_health != 0:
        current_health = clampi(current_health - 1, 0, max_health)
        
        var value = (float(current_health) / max_health)
        set_color(Color(value, value, value))
        
        if current_health == 0:
            ice_scale = 0
            var earth = get_parent() as IcoSphere
            earth.sea_level.destory_ice()
            set_color(Color.WHITE)
    
func _process(delta):
    if layer == layers.WHITE:
        position = origin + layer * normal / 60 * ice_scale
    
        ice_scale = clampf(ice_scale + delta * ice_speed, 0, 1)
        
        if current_health == 0 and ice_scale == 1:
            current_health = max_health

func can_spawn_human():
    var sea_level = (get_parent() as IcoSphere).sea_level.height
    
    if sea_level >= layer:
        return false
    
    return layer != layers.BLACK and layer != layers.WHITE

func sea_level_rise(sea_level):
    if layer == layers.WHITE:
        
    
        
        
