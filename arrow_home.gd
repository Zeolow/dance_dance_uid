extends Node2D

var action_code: String = "left"
@export var sprite_rotation: float = 0

func _ready():
	$Sprite2D.rotation_degrees = sprite_rotation
	for child in $ParticleEffects.get_children():
		if child is HitEffect:
			child.arrow_rotation = sprite_rotation

func _process(delta):
	if Input.is_action_just_pressed(action_code):
		$Anim.play("hit")

func trigger_effect(effect_nr: int):
	match effect_nr:
		Globals.Evaluation.PERFECT:
			$ParticleEffects/Perfect.emit()
		Globals.Evaluation.GREAT:
			$ParticleEffects/Great.emit()
		Globals.Evaluation.GOOD:
			$ParticleEffects/Good.emit()
		Globals.Evaluation.OK:
			$ParticleEffects/Ok.emit()
		Globals.Evaluation.BAD:
			$ParticleEffects/Bad.emit()
		Globals.Evaluation.MISS:
			$ParticleEffects/Miss.emit()
