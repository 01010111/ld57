package objects;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Skull extends GameObject {

	public var state:SkullState;
	public var poof_timer:Float = 0.1;

	public function new() {
		super();
		loadGraphic(Images.skull__png, true, 32, 32);
		animation.add('red', [0,0,1,1,1,2,2,1,1,1]);
		animation.add('blue', [3,3,4,4,4,5,5,4,4,4]);
		this.make_and_center_hitbox(16, 16);
		kill();
	}

	override function update(dt:Float) {
		super.update(dt);
		throw_poofs(dt);
		follow_coin();
	}

	public function spawn(x:Float, y:Float, s:SkullState) {
		reset(x, y);
		velocity.set(0, SKULL_Y_SPEED);
		maxVelocity.x = SKULL_MAX_X_SPEED;
		state = s;
		switch state {
			case RED:animation.play('red');
			case BLUE:animation.play('blue');
		}
		this.set_facing_flip_horizontal();
		FlxTween.tween(velocity, { y: -SKULL_Y_SPEED }, 4.get_random(2), { ease: FlxEase.sineInOut, type: PINGPONG });
	}

	function throw_poofs(dt:Float) {
		if ((poof_timer -= dt) > 0) return;
		poof_timer = 0.2.get_random(0.1);
		var c = switch state {
			case RED:0xFFa2324e;
			case BLUE:0xFF467bc6;
		}
		PLAYSTATE.bg_puffs.fire({ position: getMidpoint().add(SKULL_POOF_OFFSET.get_random(-SKULL_POOF_OFFSET), SKULL_POOF_OFFSET.get_random(-SKULL_POOF_OFFSET)), util_color: c });
	}

	function follow_coin() {
		var cx = PLAYSTATE.coin.x + PLAYSTATE.coin.width/2;
		var mx = x + width/2;
		acceleration.x = cx < mx ? -SKULL_X_ACCELERATION : SKULL_X_ACCELERATION;
		facing = velocity.x < 0 ? LEFT : RIGHT;
	}
}

enum SkullState {
	RED;
	BLUE;
}

private var state_arr:Array<SkullState> = [];
var GET_SKULL = (x:Float, y:Float) -> {
	var skull:Skull;
	skull = PLAYSTATE.skulls.getFirstAvailable();
	if (skull == null) {
		skull = new Skull();
		PLAYSTATE.skulls.add(skull);
	}
	if (state_arr.length == 0) {
		for (i in 0...8) state_arr.push(RED);
		for (i in 0...8) state_arr.push(BLUE);
		state_arr.shuffle();
	}
	skull.spawn(x, y, state_arr.shift());
}