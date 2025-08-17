extends Node3D

class_name Spawner

var magicians: Array[Magician]
var racists: Array[Racist]
var icebergs: Array[Iceberg]
var scientists: Array[Scientist]
var boats: Array[Boat]
var airplanes: Array[Airplane]

@export var magician_scene : PackedScene
@export var magician_max: int
@export var magician_spawn_rate: float
var timer_magician = 0

@export var racist_scene : PackedScene
@export var racist_max: int
@export var racist_spawn_rate: float
var timer_racist = 0

@export var iceberg_scene : PackedScene
@export var iceberg_max: int
@export var iceberg_spawn_rate: float
var timer_iceberg = 0

@export var scientist_scene : PackedScene
@export var scientist_max: int
@export var scientist_spawn_rate: float
var timer_scientist = 0

@export var boat_scene : PackedScene
@export var boat_max: int
@export var boat_spawn_rate: float
var timer_boat = 0

@export var airplane_scene : PackedScene
@export var airplane_max: int
@export var airplane_spawn_rate: float
var timer_airplane = 0

var hexagons: Array[Hexagon]

func _ready():
    pass
    
func init():
    hexagons = IcoSphere.instance.hexagons
    
#region process
func _process(delta):
    if GameRules.instance.won:
        return
    
    var sea_level = IcoSphere.instance.sea_level
    if sea_level.height >= GameRules.instance.max_sea_level:
        
        if icebergs.size() == 0:
            GameRules.instance.win()
        
        return
        
    process_magician(delta)
    process_racist(delta)
    process_iceberg(delta)
    process_scientist(delta)
    process_boat(delta)
    process_airplane(delta)

func process_magician(delta: float):
    timer_magician = clamp(timer_magician + delta, 0, magician_spawn_rate)
    if timer_magician >= magician_spawn_rate:
        timer_magician = 0
        if magicians.size() < magician_max:
            spawn_magician()

func process_racist(delta: float):
    timer_racist = clamp(timer_racist + delta, 0, racist_spawn_rate)
    if timer_racist >= racist_spawn_rate:
        timer_racist = 0
        if racists.size() < racist_max:
            spawn_racist()

func process_iceberg(delta: float):
    timer_iceberg = clamp(timer_iceberg + delta, 0, iceberg_spawn_rate)
    if timer_iceberg >= iceberg_spawn_rate:
        timer_iceberg = 0
        if icebergs.size() < iceberg_max:
            spawn_iceberg()

func process_scientist(delta: float):
    timer_scientist = clamp(timer_scientist + delta, 0, scientist_spawn_rate)
    if timer_scientist >= scientist_spawn_rate:
        timer_scientist = 0
        if scientists.size() < scientist_max:
            spawn_scientist()
    
func process_boat(delta: float):
    timer_boat = clamp(timer_boat + delta, 0, boat_spawn_rate)
    if timer_boat >= boat_spawn_rate:
        timer_boat = 0
        if boats.size() < boat_max:
            spawn_boat()
    
func process_airplane(delta: float):
    timer_airplane = clamp(timer_airplane + delta, 0, airplane_spawn_rate)
    if timer_airplane >= airplane_spawn_rate:
        timer_airplane = 0
        if airplanes.size() < airplane_max:
            spawn_airplane()
    
#endregion

#region spawn
func spawn_magician():
    var target = null
    hexagons.shuffle()
    for hexagon in hexagons:
        if hexagon.layer == IcoSphere.instance.sea_level.height + 2:
            target = hexagon as Hexagon
            break
    
    if target == null or target.human != null:
        return
    
    var magician = magician_scene.instantiate() as Node3D
    target.spawn_human(magician)
    magicians.append(magician as Magician)
    
    #print("spawned wind turbine")

func spawn_racist():
    var target = null
    hexagons.shuffle()
    for hexagon in hexagons:
        if hexagon.layer == IcoSphere.instance.sea_level.height + 1:
            target = hexagon as Hexagon
            break
    
    if target == null or target.human != null:
        return
    
    var racist = racist_scene.instantiate() as Node3D
    target.spawn_human(racist)
    racists.append(racist as Racist)
    
    #print("spawned factory")

func spawn_iceberg():
    var target = null
    hexagons.shuffle()
    for hexagon in hexagons:
        if hexagon.layer >= IcoSphere.instance.sea_level.height:
            continue
        
        var z = hexagon.position.z
        if z >= 0.45 or z <= -0.45:
            target = hexagon as Hexagon
            break
            
    if target == null or target.human != null:
        return
    
    var iceberg = iceberg_scene.instantiate() as Node3D
    target.spawn_human(iceberg)
    icebergs.append(iceberg as Iceberg)
    
    #print("spawned iceberg")
    
func spawn_scientist():
    var target = null
    hexagons.shuffle()
    if scientists.size() == 0 or randf_range(0, 1) > 0.8:
        for hexagon in hexagons:
            if hexagon.layer < IcoSphere.instance.sea_level.height:
                continue
            if hexagon.layer == IcoSphere.instance.sea_level.height + 1:
                target = hexagon as Hexagon
                break
    else:
        scientists.shuffle()
        var target_neighbor = scientists[0]
        for hexagon in hexagons:
            if hexagon.layer < IcoSphere.instance.sea_level.height:
                continue
            
            var distance = (target_neighbor.hexagon.global_position - hexagon.global_position).length()
            
            if distance < 1:
                target = hexagon as Hexagon
                break
            
    if target == null or target.human != null:
        #print("no neighbour found")
        return
    
    var scientist = scientist_scene.instantiate() as Node3D
    target.spawn_human(scientist)
    scientists.append(scientist as Scientist)
    
    #print("spawned house")
    
func spawn_boat():
    var target = null
    hexagons.shuffle()
    for hexagon in hexagons:
        if hexagon.layer < IcoSphere.instance.sea_level.height:
            target = hexagon as Hexagon
            break
    
    if target == null or target.human != null:
        return
    
    var boat = boat_scene.instantiate() as Node3D
    target.spawn_human(boat)
    boats.append(boat as Boat)
    
    #print("spawned boat")
    
func spawn_airplane():
    var target = null
    hexagons.shuffle()
    for hexagon in hexagons:
        if hexagon.layer >= IcoSphere.instance.sea_level.height:
            target = hexagon as Hexagon
            break
    
    if target == null or target.human != null:
        return
    
    var airplane = airplane_scene.instantiate() as Node3D
    target.spawn_human(airplane)
    target.human = null
    airplanes.append(airplane as Airplane)
    
    #print("spawned airplane")
    
#endregion

func kill(killed: Human, score: bool):
    var name = ""
    var type = GameRules.human_type.HUMAN
    
    if killed is Magician:
        magicians.erase(killed)
        name = "wind turbine"
        type = GameRules.human_type.MAGICIAN
    if killed is Racist:
        racists.erase(killed)
        name = "factory"
        type = GameRules.human_type.RACIST
    if killed is Iceberg:
        icebergs.erase(killed)
        name = "iceberg"
        type = GameRules.human_type.ICEBERG
    if killed is Scientist:
        scientists.erase(killed)
        name = "scientist"
        type = GameRules.human_type.SCIENTIST
    if killed is Boat:
        boats.erase(killed)
        name = "boat"
        type = GameRules.human_type.BOAT
    if killed is Airplane:
        airplanes.erase(killed)
        name = "airplane"
        type = GameRules.human_type.PLANE
    
    if score:
        GameRules.instance.on_mayhem(type)
    if killed.hexagon != null:
        killed.hexagon.human = null
    killed.queue_free()
    
    #print("killed a ", type)

func _on_sea_level_rise(height):
    for magician in magicians:
        if magician.hexagon.layer <= height:
            kill(magician, false)
            _on_sea_level_rise(height)
            return
    for racist in racists:
        if racist.hexagon.layer <= height:
            kill(racist, false)
            _on_sea_level_rise(height)
            return
    for scientist in scientists:
        if scientist.hexagon.layer <= height:
            kill(scientist, false)
            _on_sea_level_rise(height)
            return
    
    var sea_level = IcoSphere.instance.sea_level
    if sea_level.height >= GameRules.instance.max_sea_level:
        for boat in boats:
            boat.hit_by_water()
        for airplane in airplanes:
            airplane.crash()
