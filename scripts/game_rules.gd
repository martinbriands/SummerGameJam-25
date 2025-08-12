extends Node

class_name GameRules

static var instance: GameRules

enum human_type 
{
    HUMAN = 0,
    MAGICIAN = 1,
    SCIENTIST = 2,
    RACIST = 3,
}

func _ready() -> void:
    instance = self
    
    progress_bar = UI.instance.get_node('Temperature') as TextureProgressBar
    world = IcoSphere.instance
    sea_level = world.sea_level
    sea_level.iceberg_destroyed.connect(_on_iceberg_destroyed)
    
    ui = UI.instance
    
@export var max_humans_curve: Curve
var max_humans: float
@export var human_spawn_delay: float
@export var human_temperature_impact: float
@export var iceberg_temperature_impact: float
@export var iceberg_respawn_delay: float
@export var racist_lifetime: float
@export var human_evolution_chance: float
@export var max_sea_level: int

var progress_bar: TextureProgressBar
var world: IcoSphere
var sea_level: SeaLevel
var ui: UI

var progress: float = 50
var human_impact: float = 0

func _process(delta: float) -> void:
    #if sea_level.height == 0:
    #    return
    
    process_humans()
    
    progress = clamp(progress - human_impact * delta, 0, 100)
    
    if progress == 0:
        sea_level.sink()
        progress = 75
        
    progress_bar.value = progress
    
    max_humans = max_humans_curve.sample(sea_level.height + 0.01)

func _on_iceberg_destroyed():
    progress = clamp(progress + iceberg_temperature_impact, 0, 100)
    
    if progress == 100:
        sea_level.rise()
        progress = 25
    
    progress_bar.value = progress

func process_humans():
    var magicians = world.human_types[human_type.MAGICIAN]
    var racists = world.human_types[human_type.RACIST]
    var scientists = world.human_types[human_type.SCIENTIST]
    
    human_impact = magicians - racists
        
    ui.set_human_impact(human_impact * human_temperature_impact)
