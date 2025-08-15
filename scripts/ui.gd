extends Control

class_name UI

static var instance: UI

var water_level: RichTextLabel
var human_label: RichTextLabel
var resistance_label: RichTextLabel
var icebergs_label: RichTextLabel
var human_impact_label: RichTextLabel

var temperature_label: RichTextLabel
var temperature_image: TextureRect

@export var weather_images: Array[Texture2D]
@export var weather_curve: Curve

func _ready() -> void:
    instance = self
    
    water_level = $GridContainer/WaterLevelLabel
    human_label = $GridContainer/HumanCountLabel
    resistance_label = $GridContainer/ResistanceLabel
    icebergs_label = $GridContainer/IcebergsDestroyedLabel
    human_impact_label = $GridContainer/HumanImpactLabel
    temperature_label = $BreakingNews/Weather/Temperature
    temperature_image = $BreakingNews/Weather/TemperatureImage

func set_water_level(value: int):
    water_level.text = "Water Level : " + str(value)
    
func set_human_count(value: int, human_types: Vector4i):
    human_label.text = "Human Count : " + str(value) + " " + str(human_types)
    
func set_human_impact(value: float):
    human_impact_label.text = "Human Impact : " + str(value)
    
func set_temperature(value: int):
    temperature_label.text = str(value) + "°"
    
    var index = int( floor(weather_curve.sample(value)))
    
    temperature_image.texture = weather_images[index]
    
