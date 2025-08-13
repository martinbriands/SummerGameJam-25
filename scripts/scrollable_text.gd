extends RichTextLabel

@export var speed: float

func _ready() -> void:
    self_destruct()
    
func self_destruct():
    await get_tree().create_timer(25).timeout
    
    queue_free()

func _process(delta: float) -> void:
    position.x += delta * speed
