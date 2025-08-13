extends Human

@export var plane_speed: float
@export var plane_height: float

func _on_static_body_3d_area_entered(area: Area3D) -> void:
    if area.name == "WaterCollisionSphere":
        hit_by_water()
    if area.name == "HexagonCollisionSphere":
        hit_by_land(area)
    
func hit_by_water():
    if is_dying:
        return
        
    is_dying = true
        
    IcoSphere.instance.sea_level.on_water_clicked($Parent.global_position / 10, Vector3.ZERO)
    await get_tree().create_timer(1).timeout
    IcoSphere.instance.kill_human(self)
    
func hit_by_land(area: Area3D):
    if is_dying:
        return
    
    is_dying = true
    
    await get_tree().create_timer(1).timeout
    IcoSphere.instance.kill_human(self)

func _process(delta: float) -> void:
    #translate(Vector3(0.1 * delta,0,0))
    rotate_object_local(Vector3.UP, plane_speed * delta)
    
    if is_crashing:
        
        crash_speed = lerp(0.0, 0.1, crashing_timer)
        crashing_timer += delta
        
        $Parent.position.z-= crash_speed * delta
        $Parent/Node3D2.rotate_object_local(Vector3.UP, crash_speed * delta * 4)
        
        if crashing_timer > 5:
            hit_by_water()
    
func _ready() -> void:
    var origin = ($Parent.global_position as Vector3).normalized()
    global_position = (get_parent().get_parent() as Node3D).global_position
    $Parent.global_position = origin * (plane_height + randf_range(-1,1))

var is_crashing: bool
var crashing_timer: float
var crash_speed: float
var is_dying: bool
 
func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        is_crashing = true
        crashing_timer = 0
    
    
