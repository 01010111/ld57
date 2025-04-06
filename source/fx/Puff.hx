package fx;

import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.components.KillAfterAnimation;
import zero.flixel.ec.ParticleEmitter.Particle;

class Puff extends Particle {

	public function new() {
		super();
		loadGraphic(Images.puff__png, true, 16, 16);
		animation.add('play', [0,1,2,3,4,5,6,7,8], 16, false);
		add_component(new KillAfterAnimation());
		drag.set(256, 256);
		this.make_and_center_hitbox(0, 0);
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		animation.play('play');
		if (options.util_int != null) animation.curAnim.curFrame = options.util_int;
		if (options.util_amount != null) acceleration.y = options.util_amount;
		if (options.util_color != null) color = options.util_color;
	}

}