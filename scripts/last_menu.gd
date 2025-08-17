extends Control


func _on_button_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_button_2_pressed() -> void:
    get_tree().quit()

func set_text(time: float):
    var minutes = time / 60
    var seconds = fmod(time, 60)
    var milliseconds = fmod(time, 1) * 100
    var time_string = "%02d:%02d" % [minutes, seconds]
    $Text.text = "Earth was cleansed in " + time_string
