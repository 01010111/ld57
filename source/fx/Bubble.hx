package fx;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.components.KillAfterTimer;
import zero.flixel.ec.ParticleEmitter.Particle;

class Bubble extends Particle {

	var kill_timer:KillAfterTimer;

	public function new() {
		super();
		loadGraphic(Images.bubbles__png, true, 16, 16);
		animation.add('b1', [0,1,2,1], 8);
		animation.add('b2', [3,4,5,6], 4);
		animation.add('b3', [7]);
		animation.add('b4', [8]);
		this.make_and_center_hitbox(0, 0);
		add_component(kill_timer = new KillAfterTimer());
		drag.x = 500;
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		animation.play(['b1', 'b2', 'b3', 'b3', 'b4'].get_random());
		kill_timer.reset(10);
		scale.set();
		FlxTween.tween(scale, { x: 1, y: 1 }, 0.25, { ease: FlxEase.backOut });
		if (options.util_amount != null) velocity.x = options.util_amount * 10;
		velocity.y = -48.get_random(24);
	}

}