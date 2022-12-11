import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:shooting_game_joystick/bullet.dart';

class Enemy extends SpriteComponent with HasGameRef, CollisionCallbacks {
  Enemy()
      : super(
          anchor: Anchor.center,
          size: Vector2.all(100.0),
        );

  var hits = 0;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(size: Vector2.all(100.0), isSolid: true));
    sprite = await gameRef.loadSprite('enemy.png');
    FlameAudio.play('laugh.mp3');
    autoShoot();
  }

  autoShoot() async {
    var velocity = Vector2(0, 1);
    add(Bullet(position, velocity)..size = Vector2.all(5));
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      add(Bullet(position, velocity)..size = Vector2.all(5));
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) {
      hits++;
      if (hits == 10) {
        removeFromParent();
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
