extends Node

class_name GameRules

static var instance: GameRules

enum human_type 
{
    HUMAN = 0,
    MAGICIAN = 1,
    SCIENTIST = 2,
    RACIST = 3,
    BOAT = 4,
    PLANE = 5,
    ICEBERG = 6
}

func _ready() -> void:
    instance = self
    
    world = IcoSphere.instance
    sea_level = world.sea_level
    
    ui = UI.instance
    
    ui.set_temperature(temperature)
    
@export var racist_lifetime: float
@export var max_sea_level: int
@export var sea_level_curve: Curve

var world: IcoSphere
var sea_level: SeaLevel
var ui: UI

var progress: float = 50
var human_impact: float = 0

var last_clicked_tile: Hexagon

var won: bool

var time = 0
var tsunami_time = 0
var meteor_time = 0

@export var tsunami_delay: int = 5
@export var meteor_delay: int = 10

func _process(delta: float) -> void:
    tsunami_time = clamp(tsunami_time - delta, 0, tsunami_delay)
    meteor_time = clamp(meteor_time - delta, 0, meteor_delay)
    
    if sea_level.height >= max_sea_level:
        return
    
    var desired_sea_level = floor(sea_level_curve.sample(temperature))
    
    if desired_sea_level > sea_level.height:
        sea_level.rise()
    elif desired_sea_level < sea_level.height:
        sea_level.sink()
    
    time += delta
    
var temperature = 15

func on_mayhem(type: human_type):
    #print("on mayhem ", type)
    if type == human_type.BOAT or type == human_type.PLANE or type == human_type.ICEBERG or type == human_type.RACIST:
        temperature += 1
        ui.set_temperature(temperature)
        
    if type == human_type.SCIENTIST:
        temperature += 0.1
        ui.set_temperature(temperature)

func on_progress(type: human_type):
    #print("on progress ", type)
    if type == human_type.ICEBERG or type == human_type.MAGICIAN:
        temperature = clamp(temperature - 1, 15, 999) 
        ui.set_temperature(temperature)

func win():
    won = true
    
    var last_menu = load("res://scenes/last_menu.tscn").instantiate()
    add_child(last_menu)
    
    last_menu.set_text(time)
