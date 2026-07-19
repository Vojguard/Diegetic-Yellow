extends Node

signal player_loaded(player: PlayerController)

signal target_hit(target : Target, player_pos : Vector2i)

signal item_collected(item : Collectible)

signal score_updated(score : int)
