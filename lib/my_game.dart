import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:shooting_game_joystick/bullet.dart';

class MyGame extends FlameGame with HasDraggables, TapDetector {
  late final JoystickPlayer player;
  late final JoystickComponent joystick;

  MyGame();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final joystick = JoystickComponent(
      knob: CircleComponent(
          radius: 15, paint: BasicPalette.green.withAlpha(200).paint()),
      background: CircleComponent(
          radius: 50, paint: BasicPalette.green.withAlpha(100).paint()),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    player = JoystickPlayer(joystick);
    add(player);
    add(joystick);
  }

  @override
  void onTapUp(TapUpInfo info) {
    var velocity = Vector2(0, -1);
    velocity.rotate(player.angle);
    add(Bullet(player.position, velocity));
    super.onTapUp(info);
  }

}

class JoystickPlayer extends SpriteComponent with HasGameRef {
  JoystickPlayer(this.joystick)
      : super(
          anchor: Anchor.center,
          size: Vector2.all(100.0),
        );

  /// Pixels/s
  double maxSpeed = 1000.0;

  final JoystickComponent joystick;

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('asteroids_ship.png');
    position = gameRef.size / 2;
  }

  @override
  void update(double dt) {
    if (joystick.direction != JoystickDirection.idle) {
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
  }
}
