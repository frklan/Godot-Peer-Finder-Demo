extends Control

# warning-ignore-all:return_value_discarded

const DESKTOP_SCALE_FACTOR := 1
const IPHONE_SCALE_FACTOR := 4
var currentScaleFactor := DESKTOP_SCALE_FACTOR

func _ready():
  get_viewport().connect("size_changed", self, "on_window_resize")

  if OS.get_model_name() != "GenericDevice":
    currentScaleFactor = IPHONE_SCALE_FACTOR
    rect_scale = Vector2(currentScaleFactor, currentScaleFactor)
  on_window_resize()

func on_window_resize():
  var win_size = OS.get_window_size()
  rect_position = Vector2(0, 0)  
  rect_size = Vector2(win_size.x / currentScaleFactor, win_size.y / currentScaleFactor)