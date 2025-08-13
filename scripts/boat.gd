extends Human

@export var boat_speed: float

func _process(delta: float) -> void:
    #translate(Vector3(0.1 * delta,0,0))
    rotate_object_local(Vector3.UP, boat_speed * delta)
    
    if is_crashing:
        
        var crash_speed = lerp(0.0, 0.1, crashing_timer)
        crashing_timer += delta
        $Parent.position.z -= delta * crash_speed
    
func _ready() -> void:
    var origin = ($Parent.global_position as Vector3).normalized()
    global_position = (get_parent().get_parent() as Node3D).global_position
    $Parent.global_position = origin * 5

var crashing_timer: float
var is_crashing: bool
func hit_by_water():
    if is_crashing:
        return
        
    is_crashing = true
    crashing_timer = 0
    await get_tree().create_timer(2).timeout
    IcoSphere.instance.kill_human(self)

func hit_by_land(area: Area3D):
    #var bounce = global_transform.basis.x.bounce(area.global_position - global_position) as Vector3
    if is_crashing:
        return
        
    rotate_object_local(Vector3.BACK, 1)
