extends Node2D

class_name HitEffect

@export var text_texture: Texture
@export var color: Color
@export var sparkles: bool = false
@export var arrow_rotation: float = 0.0

func _ready():
	if !sparkles:
		$Sparkles.queue_free()
	$Text.texture = text_texture
	$Outline.process_material = $Outline.process_material.duplicate()
	$Outline.modulate = color

func emit():
	$Outline.rotation_degrees = arrow_rotation
	for child in get_children():
		if child is GPUParticles2D:
			if !child.emitting:
				child.restart()
			child.emitting = true
