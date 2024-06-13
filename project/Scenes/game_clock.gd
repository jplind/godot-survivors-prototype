extends Node

#var seconds : int = 0:
	#set(value):
		#seconds = value
		#Events.clock_seconds_changed.emit(seconds)
#var minutes : int = 0:
	#set(value):
		#minutes = value
		#Events.clock_minutes_changed.emit(minutes)
#
#@onready var seconds_timer = %SecondsTimer
#
#func _ready():
	#Events.battle_started.connect(on_battle_started)
	#Events.player_died.connect(on_player_died)
#
#func on_battle_started():
	#reset_clock()
#
#func _on_second_timer_timeout():
	#seconds += 1
	#if seconds > 59:
		#seconds = 0
		#minutes += 1
#
#func on_player_died():
	#seconds_timer.stop()
#
#func reset_clock():
	#seconds = 0
	#minutes = 0
	#seconds_timer.start()
