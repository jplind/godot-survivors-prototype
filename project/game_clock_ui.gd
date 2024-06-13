extends HBoxContainer

@onready var seconds_label = %SecondsLabel
@onready var minutes_label = %MinutesLabel

func _ready():
	Events.clock_seconds_changed.connect(on_clock_seconds_changed)
	Events.clock_minutes_changed.connect(on_clock_minutes_changed)

func on_clock_seconds_changed(seconds : int):
	seconds_label.text = "%02d" % [seconds]

func on_clock_minutes_changed(minutes : int):
	minutes_label.text = "%02d" % [minutes]
