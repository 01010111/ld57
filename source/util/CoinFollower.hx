package util;

import zero.flixel.ec.Component;
import objects.GameObject;
import zero.flixel.utilities.Dolly;

class CoinFollower extends Component {

	var dolly:Dolly;

	public function new() {
		super('coin follower');
	}

	override function on_add() {
		dolly = cast entity;
	}

	override function update(dt:Float) {
		dolly.set_position_y(Math.max(dolly.y, dolly.get_target().y + dolly.get_target().height/2 + CAMERA_OFFSET));
	}

}