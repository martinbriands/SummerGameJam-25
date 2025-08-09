extends MeshInstance3D

class_name IcoSphere

@export var plate : PackedScene
@export var human_scene : PackedScene
@export var heat_map: Sprite2D
@export var sea_level: SeaLevel

var hexagons: Array[Hexagon]
var humans: Array[Node3D]

var bounds_x: Vector2 = Vector2(-0.5, 0.5)
var bounds_y: Vector2 = Vector2(-0.5, 0.5)
var bounds_z: Vector2 = Vector2(-0.5, 0.5)

var spawn_timer: float = 0
@export var spawn_delay: float
@export var max_humans: int

func _ready():    
    
    var max = 0
    var min = 0
    
    var image_data = heat_map.texture.get_image()
    
    var faces = mesh.get_faces()
    var faces_no_duplicates = []

    for face in faces:
        if not faces_no_duplicates.has(face):
            faces_no_duplicates.append(face)
    
    for face in faces_no_duplicates:
        var hexagon = plate.instantiate() as Node3D
        add_child(hexagon)

        hexagon.set_hexagon(self, face)
        hexagon.apply_bounds(bounds_x, bounds_y, bounds_z, image_data)
        
        hexagons.append(hexagon)
        
        max = max(face.y, max)
        min = min(face.y, min)
    
func _process(delta):
    if spawn_timer >= spawn_delay:
        spawn_timer = 0
        
        if humans.size() < max_humans:
            spawn_human()
    
    spawn_timer = clampf(spawn_timer + delta, 0, spawn_delay)

func spawn_human():
    var hexagon = hexagons.pick_random()
    
    var loop_count = 0
    
    while !hexagon.can_spawn_human() && loop_count < 100:
        hexagon = hexagons.pick_random()
        loop_count = loop_count + 1
    
    var human = human_scene.instantiate() as Node3D
    hexagon.spawn_human(human)
        
    humans.append(human)

func _on_sea_level_sea_level_rise(sea_level: int):
    
    print("sea level has risen ", sea_level)
    
    for hexagon in hexagons:
        if sea_level >= hexagon.layer:
            var human_to_kill = hexagon.human
            if human_to_kill == null:
                continue
                
            humans.erase(human_to_kill)
            human_to_kill.queue_free()
            
            hexagon.human = null
            
            print("killed a human")
            
