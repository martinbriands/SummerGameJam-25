extends Human

class_name Iceberg

var origin: Vector3

func hit_by_water():
    pass

func hit_by_land(area: Area3D):
    pass

func hit_by_asteroid():
    pass

var spawn_timer = 0
var float_timer = 0
var shake_timer = 1
var progress_timer = 0
@export var progress_delay = 10
@export var shake_magnitude = 1.0
@export var debris_scene: PackedScene

@export var max_hp: int
var hp: int

func _ready():
    origin = position
    origin.z = IcoSphere.instance.sea_level.scale.x * 0.5 - 0.5
    position -= basis.z * 0.1
    
    hp = max_hp

func _process(delta):
    if progress_timer < progress_delay:
        progress_timer += delta
        
        if progress_timer >= progress_delay:
            progress_timer = 0
            GameRules.instance.on_progress(GameRules.human_type.ICEBERG)
    
    if spawn_timer < 1:
        spawn_timer += delta
        position = lerp(position, origin, spawn_timer)
        return
    
    float_timer += delta
    origin.z = IcoSphere.instance.sea_level.scale.x * 0.5 - 0.5
    position = origin + basis.z * sin(float_timer) / 100
        
    if shake_timer < 0.1:
        shake_timer += delta
        
        var offset = Vector3(
        randf_range(-shake_magnitude, shake_magnitude),
        randf_range(-shake_magnitude, shake_magnitude),
        randf_range(-shake_magnitude, shake_magnitude))
        
        $Parent/Node3D.position = offset
    else:
        $Parent/Node3D.position = Vector3.ZERO
        
        
func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
    if hp <= 0:
        return
    
    if event is InputEventMouseButton and event.is_pressed():
        shake_timer = 0
        
        var debris = debris_scene.instantiate()
        $Parent.add_child(debris)
        
        (debris.process_material as ParticleProcessMaterial).gravity = basis.z * -9.8 / 2
        debris.emitting = true
        
        #await get_tree().create_timer(1).timeout
        #debris.queue_free()
        
        hp -= 1
        
        if hp <= 0:
            origin = position - basis.z * 0.2
            spawn_timer = 0
            
            await get_tree().create_timer(1).timeout
            IcoSphere.instance.kill_human(self)
        
    
