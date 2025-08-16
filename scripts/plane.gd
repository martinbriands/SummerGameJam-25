extends Human

class_name Airplane

@export var plane_speed: float
@export var plane_height: float

func _on_static_body_3d_area_entered(area: Area3D) -> void:
    if is_lifting_off:
        return
    
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
    
    explode()
    
    await get_tree().create_timer(2).timeout
    IcoSphere.instance.kill_human(self)
    
func explode():
    $Parent/Explosion/Debris.emitting = true
    $Parent/Explosion/Fire.emitting = true
    $Parent/Explosion/Smoke.emitting = true
    
    ($Parent/Explosion/Debris.process_material as ParticleProcessMaterial).gravity = $Parent.position.normalized() * -9.8 / 2
    ($Parent/Explosion/Smoke.process_material as ParticleProcessMaterial).gravity = $Parent.position.normalized() * -5 / 10
    ($Parent/Explosion/Fire.process_material as ParticleProcessMaterial).gravity = $Parent.position.normalized() * -5 / 10

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
    
    if is_lifting_off:
        if lift_off_timer < 1:
            lift_off_timer += delta / 5
            $Parent.position.z = lerp(origin_z, target, lift_off_timer)
            
            if lift_off_timer >= 1:
                is_lifting_off = false
                
var origin_z: float
var target: float

func _ready() -> void:
    var origin = ($Parent.global_position as Vector3)
    global_position = (get_parent().get_parent() as Node3D).global_position
    
    target = plane_height + randf_range(-0.1,0.1)
    $Parent.global_position = origin
    origin_z = $Parent.position.z
    #$Parent.global_position = origin * (plane_height + randf_range(-1,1))
    
    is_lifting_off = true
    lift_off_timer = 0

var is_crashing: bool
var crashing_timer: float
var crash_speed: float
var is_dying: bool
var is_lifting_off: bool
var lift_off_timer: float
 
func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
    if event is InputEventMouseButton and event.is_pressed() and !is_crashing:
        is_crashing = true
        crashing_timer = 0
        is_lifting_off = false
    
    
