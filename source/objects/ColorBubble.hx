package objects;

class ColorBubble extends GameObject {

	var target:Coin;
	var state:BubbleState;
	var target_offset = 0.1;

	public var available = false;

	public function new() {
		super();
		loadGraphic(Images.bubble__png, true, 32, 32);
		animation.add('red_idle', [0,1,2,3], 12);
		animation.add('red_get', [4,5,6,7], 12, false);
		animation.add('blue_idle', [8,9,10,11], 12);
		animation.add('blue_get', [12,13,14,15], 12, false);
		this.make_and_center_hitbox(16, 16);
		kill();
	}

	override function update(elapsed:Float) {
		if (target != null) {
			x += (target.x + target.width/2 - width/2 - x) * target_offset;
			y += (target.y + target.height/2 - height/2 - y) * target_offset;
			if (animation.finished) {
				target.set_cur_face_state(state == RED ? RED : BLUE);
				target = null;
				kill();
			}
			target_offset = (1 - target_offset) * 0.1;
		}
		super.update(elapsed);
	}

	public function spawn(x:Float, y:Float, s:BubbleState) {
		reset(x, y);
		velocity.set(0, -8);
		state = s;
		switch state {
			case RED:animation.play('red_idle');
			case BLUE:animation.play('blue_idle');
		}
		available = true;
		target_offset = 0.1;
	}

	public function get(coin:Coin) {
		available = false;
		if (coin.get_face_status() == EDGE) {
			coin.bounce();
			kill();
			return;
		}
		coin.set_cur_face_state(state == RED ? RED : BLUE);
		kill();
		return;
		switch state {
			case RED:animation.play('red_get');
			case BLUE:animation.play('blue_get');
		}
	}

	override function kill() {
		for (i in 0...4) PLAYSTATE.bubbles.fire({ position: getMidpoint(), util_amount: 12.get_random(-12) });
		super.kill();
	}

}

enum BubbleState {
	RED;
	BLUE;
}

private var state_arr:Array<BubbleState> = [];
var GET_COLOR_BUBBLE = (x:Float, y:Float) -> {
	var bubble:ColorBubble;
	bubble = PLAYSTATE.color_bubbles.getFirstAvailable();
	if (bubble == null) {
		bubble = new ColorBubble();
		PLAYSTATE.color_bubbles.add(bubble);
	}
	if (state_arr.length == 0) {
		for (i in 0...8) state_arr.push(RED);
		for (i in 0...8) state_arr.push(BLUE);
		state_arr.shuffle();
	}
	bubble.spawn(x, y, state_arr.shift());
}