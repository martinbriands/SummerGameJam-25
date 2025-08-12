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

signal sea_level_rise(height: int)
signal iceberg_destroyed

func _ready():
    base_size = scale.x
    #base_scale = mesh.surface_get_material().

func rise():
    height = height + 1
    
    set_sea_level()

func sink():
    height = height - 1
    
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
