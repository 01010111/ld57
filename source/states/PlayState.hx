package states;

import zero.utilities.Vec2;
import fx.Bubble;
import zero.flixel.ec.ParticleEmitter;
import util.CoinFollower;
import zero.flixel.utilities.Dolly;
import objects.Coin;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxState;

var i:PlayState;

class PlayState extends FlxState {

	public var bubbles:ParticleEmitter = new ParticleEmitter(() -> new Bubble());

	var bubble_timer:Float = 1.5;

	override function create() {
		i = this;

		FlxG.mouse.visible = false;

		var backdrop = new FlxBackdrop(Images.well_bg_simple__png, Y);
		backdrop.x = 96;
		add(backdrop);

		var coin = new Coin(181, 0);
		add(coin);

		add(bubbles);

		var dolly = new Dolly({ target: coin });
		dolly.add_component(new CoinFollower());
		add(dolly);
	}

	override function update(dt:Float) {
		super.update(dt);
		bubble_spawning(dt);
	}

	function bubble_spawning(dt:Float) {
		if ((bubble_timer -= dt) > 0) return;
		bubble_timer = 4.get_random_gaussian();
		var v1 = Vec2.get(FlxG.width/2 + 64.get_random(-64), camera.scroll.y + FlxG.height + 32);
		var v2 = Vec2.get(16);
		var n = [1,2,2,3,3,3,3,4,4].get_random();
		for (i in 0...n) {
			v2.length = 16.get_random(12);
			v2.angle += 360 / n;
			bubbles.fire({ position: FlxPoint.get(v1.x + v2.x, v1.y + v2.y) });
		}
		v1.put();
		v2.put();
	}

}