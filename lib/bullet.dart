import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shooting_game_joystick/enemy.dart';
import 'package:shooting_game_joystick/utils.dart';
import 'package:flame_audio/flame_audio.dart';

class Bullet extends PositionComponent with HasGameRef, CollisionCallbacks {
  static final _paint = Paint()..color = Colors.white;
  final double _speed = 200;
  late Vector2 _velocity;

  Bullet(Vector2 position, Vector2 velocity)
      : _velocity = velocity,
        super(
          position: position,
          size: Vector2.all(2),
          anchor: Anchor.center,
        );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
    _velocity = _velocity..scaleTo(_speed);
    FlameAudio.play('spit.mp3');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(_velocity * dt);
    if (Utils.isPositionOutOfBounds(gameRef.size,position)) {
      removeFromParent();
      FlameAudio.play('hit.mp3');
      // gameRef.camera.shake();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
  }
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is Enemy) {
      removeFromParent();
      FlameAudio.play('hit.mp3');
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
