package objects;

import flixel.util.FlxTimer;

class Coin extends GameObject {

	var frame_arr = [];
	var current_frame:Float = 0;
	var target_frame:Float = 4;
	var target_angle:Float = 0;
	var max_vertical_velocity = 0;
	var bubble_timer:Float = 0.1;
	var starting = true;

	var heads_state:FaceState;
	var tails_state:FaceState;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic(Images.coin__png, true, 32, 32);
		acceleration.y = COIN_GRAVITY;
		maxVelocity.x = COIN_MAX_X_SPEED;
		new FlxTimer().start(1, t -> starting = false);
		set_face_states(NEUTRAL, NEUTRAL);
	}

	override function update(dt:Float) {
		super.update(dt);

		controls();
		set_visuals();
		set_physics();
		throw_bubbles(dt);
	}

	function controls() {
		// when starting out, coin spins
		if (starting) {
			target_frame += COIN_SPIN_SPEED;
			return;
		}

		// Mooncat controls:
		// if (FlxG.keys.pressed.LEFT && FlxG.keys.pressed.RIGHT) {
		// 	target_frame += COIN_SPIN_SPEED;
		// }

		// UP / DOWN spin coin
		if (FlxG.keys.pressed.UP || FlxG.keys.pressed.DOWN) {
			if (FlxG.keys.pressed.UP) target_frame += COIN_SPIN_SPEED;
			if (FlxG.keys.pressed.DOWN) target_frame -= COIN_SPIN_SPEED;
		}
		// NOT UP or DOWN sets coin to closest: heads, tails, or edge
		else {
			target_frame = Math.round(target_frame/4) * 4;
		}
		// Keep target frame > 0 to prevent issues with using modulo
		if (target_frame < 0) {
			target_frame += 16;
			current_frame += 16;
		}

		// LEFT / RIGHT tilt coin
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT) {
			if (FlxG.keys.pressed.LEFT) target_angle -= COIN_TURN_SPEED;
			if (FlxG.keys.pressed.RIGHT) target_angle += COIN_TURN_SPEED;
		}
		// NOT LEFT or RIGHT sets tilt to 0
		else target_angle += (0 - target_angle) * 0.1;
		// clamp angle to 45 deg in either direction
		target_angle = target_angle.clamp(-45, 45);
	}

	function set_visuals() {
		// set frame
		current_frame += (target_frame - current_frame) * 0.1;
		animation.frameIndex = frame_arr[Math.round(current_frame) % 16];

		// set angle
		angle += (target_angle - angle) * 0.1;
	}

	function set_physics() {
		bounds();

		var frame_idx = Math.round(current_frame) % 8;
		var max_y_speed = COIN_MAX_Y_SPEED_ARR[frame_idx];
		if (velocity.y > max_y_speed) velocity.y += (max_y_speed - velocity.y) * 0.1;
		velocity.x += (angle * 3 * COIN_X_SPEED_MULT[frame_idx] - velocity.x) * 0.25;

		var last_height = height;
		setSize(24, COIN_HEIGHT_ARR[frame_idx]);
		offset.set(4, (32 - height)/2);
		y += (last_height - height)/2;
	}

	function bounds() {
		if (isTouching(LEFT) || x < 112) angle = target_angle = angle + 180;
		if (isTouching(RIGHT) || x > 272 - width) angle = target_angle = angle - 180;
	}

	function throw_bubbles(dt:Float) {
		var time_mult = COIN_BUBBLE_EMIT_DT[Math.round(current_frame) % 8];
		if ((bubble_timer -= dt * time_mult) > 0) return;
		bubble_timer = 0.2.get_random(0.1);
		var bubble_x_offset = (width/2).get_random(-width/2);
		PLAYSTATE.bubbles.fire({ position: getMidpoint().add(bubble_x_offset, 4), util_amount: bubble_x_offset });
	}

	public function set_cur_face_state(state:FaceState) {
		var is_face = Math.round(current_frame) % 8 != 0;
		if (!is_face) return false;
		if (current_frame < 8) set_face_states(state, tails_state);
		else set_face_states(heads_state, state);
		return true;
	}

	function set_face_states(heads:FaceState, tails:FaceState) {
		heads_state = heads;
		tails_state = tails;
		frame_arr = [];
		frame_arr = switch heads {
			case NEUTRAL:frame_arr.concat(COIN_FRAMES_HEADS_NEUTRAL);
			case RED:frame_arr.concat(COIN_FRAMES_HEADS_RED);
			case BLUE:frame_arr.concat(COIN_FRAMES_HEADS_BLUE);
		}
		frame_arr = switch tails {
			case NEUTRAL:frame_arr.concat(COIN_FRAMES_TAILS_NEUTRAL);
			case RED:frame_arr.concat(COIN_FRAMES_TAILS_RED);
			case BLUE:frame_arr.concat(COIN_FRAMES_TAILS_BLUE);
		}
		trace(frame_arr);
	}

}

enum FaceState {
	NEUTRAL;
	RED;
	BLUE;
}