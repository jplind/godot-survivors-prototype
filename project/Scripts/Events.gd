extends Node

signal enemy_despawned
signal player_died
signal battle_started
signal enemy_damaged(damage_number : int, enemy_position : Vector2)
signal enemy_died(enemy : Enemy)
signal book_picked(value : int)
signal fruit_picked(value : int)
signal level_gained
signal upgrade_picked
signal upgrade_maxed(upgrade_card : UpgradeCard)
