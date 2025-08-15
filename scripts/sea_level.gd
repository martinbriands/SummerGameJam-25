extends MeshInstance3D

class_name SeaLevel

var height: int = 0
var base_size: float
var base_scale: Vector3

var targetHeight: float = 0
var startingHeight: float = 0
@export var sea_level_change_speed: float

var t: float = 999

var sub_height: int
@export var sub_height_max: int

var oil_spills: Array[OilSpill]

signal sea_level_rise(height: int)
signal iceberg_destroyed

func _ready():
    base_size = scale.x

func rise():
    height = clamp(height + 1, 0, GameRules.instance.max_sea_level)
    
    set_sea_level()

func sink():
    height = clamp(height - 1, 0, GameRules.instance.max_sea_level)
    
    set_sea_level()
    
func destory_ice():
    #sub_height = sub_height + 1
    #
    #if sub_height >= sub_height_max:
        #sub_height = 0
        #rise()    
    iceberg_destroyed.emit()

func set_sea_level():
    targetHeight = 1 + height * 0.04
    startingHeight = scale.x
    
    t = 0
    
var time: float
func _process(delta):
    if t < sea_level_change_speed:
        t = clampf(t + delta, 0, sea_level_change_speed)
    
        var lerp = lerpf(startingHeight, targetHeight, t / sea_level_change_speed)
        scale = Vector3(lerp, lerp, lerp)
        
        if t == sea_level_change_speed:
            risen()
            
    if intensity_timer < intensity_timer_max:
        intensity_timer = clampf(intensity_timer + delta, 0, intensity_timer_max)
        
        shockwave_intensity_value = intensity_curve.sample(intensity_timer) * shockwave_intensity
        mesh.material.set_shader_parameter("intensity", shockwave_intensity_value)
        
        if intensity_timer == intensity_timer_max:
            $ShockwaveCollisionSphere.position = Vector3.ZERO


    time += delta
    mesh.material.set_shader_parameter("time", time)
    
    var oil_spill_positions = []
    var oil_spill_timers = []
    
    for i in range(10):
        oil_spill_positions.append(Vector3.ZERO)
        oil_spill_timers.append(-1)
        
    var index = 0
    
    while oil_spills.size() > 10:
        print("poppop")
        oil_spills.pop_front()
    
    for oil_spill in oil_spills:
        oil_spill.time = clamp(oil_spill.time - delta, 0, 5)
        
        oil_spill_positions[index] = oil_spill.position
        oil_spill_timers[index] = oil_spill.time
        index += 1
    
    mesh.material.set_shader_parameter("oil_spills", oil_spill_positions)
    mesh.material.set_shader_parameter("oil_spill_timers", oil_spill_timers)

func risen():
    sea_level_rise.emit(height)
    UI.instance.set_water_level(height)


var shockwave_intensity_value: float = 0
@export var shockwave_intensity: float
var intensity_timer: float = 1
var intensity_timer_max: float = 1
@export var intensity_curve: Curve

func on_water_clicked(tile_pos: Vector3, earth_center: Vector3):
    if intensity_timer < intensity_timer_max:
        return
    
    intensity_timer = 0
    time = -0.4
    
    mesh.material.set_shader_parameter("center_3D", tile_pos)
    mesh.material.set_shader_parameter("intensity", shockwave_intensity_value)
    mesh.material.set_shader_parameter("time", time)
    
    $ShockwaveCollisionSphere.position = tile_pos

@onready var camera = get_viewport().get_camera_3d()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
    if event is InputEventMouseButton and !event.is_pressed():
        var from = camera.project_ray_origin(event.position)
        var to = from + camera.project_ray_normal(event.position) * 1000
        
        var space_state = get_world_3d().direct_space_state
        var query = PhysicsRayQueryParameters3D.create(from, to)
        
        var result = space_state.intersect_ray(query)
                
        if result:
            on_water_clicked(result.position / 10, position)

func create_oil_spill(pos: Vector3):
    
    print("oil spill ", pos)
    
    var oil_spill = OilSpill.new()
    oil_spill.position = pos
    oil_spill.time = 5
    
    oil_spills.append(oil_spill)
