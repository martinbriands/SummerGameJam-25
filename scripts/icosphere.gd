extends MeshInstance3D

class_name IcoSphere

static var instance: IcoSphere

@export var plate : PackedScene
@export var human_scene : PackedScene
@export var magician_scene : PackedScene
@export var scientist_scene : PackedScene
@export var racist_scene : PackedScene
@export var boat_scene : PackedScene
@export var plane_scene : PackedScene
@export var heat_map: Sprite2D
@export var sea_level: SeaLevel

var hexagons: Array[Hexagon]
var humans: Array[Node3D]

var bounds_x: Vector2 = Vector2(-0.5, 0.5)
var bounds_y: Vector2 = Vector2(-0.5, 0.5)
var bounds_z: Vector2 = Vector2(-0.5, 0.5)

var spawn_timer: float = 0

var human_types: Vector4i

func _ready():    
    instance = self
        
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
    
func _process(delta):
    #if sea_level.height == 0:
    #    return
    
    if spawn_timer >= GameRules.instance.human_spawn_delay:
        spawn_timer = 0
                
        if humans.size() < GameRules.instance.max_humans:
            spawn_human()
    
    spawn_timer = clampf(spawn_timer + delta, 0, GameRules.instance.human_spawn_delay)

func spawn_human():
    var hexagon = hexagons.pick_random() as Hexagon
    
    #var loop_count = 0
    
    #while !hexagon.can_spawn_human() && loop_count < 100:
        #hexagon = hexagons.pick_random()
        #loop_count = loop_count + 1
    
    #if !hexagon.can_spawn_human():
        #return
    
    var land_types = [human_type.HUMAN, human_type.MAGICIAN, human_type.SCIENTIST, human_type.RACIST]
    var vehicle_types = [human_type.BOAT, human_type.PLANE]
    
    var type = land_types.pick_random()
    if !hexagon.can_spawn_human():
        type = vehicle_types.pick_random()

    var human = instantiate_human(type)
    
    if human == null:
        return
    
    hexagon.spawn_human(human)
        
    humans.append(human)
    
    UI.instance.set_human_count(humans.size(), human_types)

enum human_type 
{
    HUMAN = 0,
    MAGICIAN = 1,
    SCIENTIST = 2,
    RACIST = 3,
    BOAT = 4,
    PLANE = 5
}

func instantiate_human(type: human_type) -> Node3D:                
    match type:
        human_type.HUMAN:
            human_types[human_type.HUMAN] += 1
            return human_scene.instantiate() as Node3D
        human_type.MAGICIAN:
            human_types[human_type.MAGICIAN] += 1
            return magician_scene.instantiate() as Node3D
        human_type.SCIENTIST:
            human_types[human_type.SCIENTIST] += 1
            return scientist_scene.instantiate() as Node3D
        human_type.RACIST:
            human_types[human_type.RACIST] += 1
            return racist_scene.instantiate() as Node3D
        human_type.BOAT:
            #human_types[human_type.RACIST] += 1
            return boat_scene.instantiate() as Node3D
        human_type.PLANE:
            return plane_scene.instantiate() as Node3D

    
    return null

func _on_sea_level_sea_level_rise(sea_level: int):
    print("sea level has risen ", sea_level)
    
    for hexagon in hexagons:
        if sea_level >= hexagon.layer:
            if hexagon.human == null:
                continue
            kill_human(hexagon.human)
            hexagon.human = null

func kill_human(human: Human):  
    var type = get_human_type(human)
    
    if type <= human_type.RACIST:
        human_types[type] -= 1
       
    humans.erase(human)
    human.queue_free()
            
    print("killed a human")
    UI.instance.set_human_count(humans.size(), human_types)

#func evolve_human(human: Human):  
    #print("evolving a human")
    #var h
    #for hexagon in hexagons:
        #if hexagon.human == human:
            #h = hexagon
    #
    #if h == null:
        #print("evolution failed")
        #return
    #
    #var type = get_human_type(human)
    #human_types[type] -= 1
       #
    #humans.erase(human)
    #human.queue_free()
    #
    #var evolved_human = instantiate_human(true)
    #h.spawn_human(evolved_human)
    #humans.append(evolved_human)
                #
    #print("evolved a human")
    #UI.instance.set_human_count(humans.size(), human_types)
    
func get_human_type(human: Human) -> human_type:
    if human is Magician:
        return human_type.MAGICIAN
    if human is Scientist:
        return human_type.SCIENTIST
    if human is Racist:
        return human_type.RACIST
    
    return human_type.HUMAN
    
    
            
