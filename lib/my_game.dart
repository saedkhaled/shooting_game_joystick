import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shooting_game_joystick/bullet.dart';
import 'package:shooting_game_joystick/enemy.dart';
import 'package:shooting_game_joystick/utils.dart';

class MyGame extends FlameGame
    with HasDraggables, TapDetector, HasCollisionDetection {
  late final JoystickPlayer player;
  late final JoystickComponent joystick;
  var _isFirstIntract = true;
  var _enemyCount = 20;

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
    FlameAudio.bgm.initialize();
    FlameAudio.audioCache.loadAll(['spit.mp3', 'hit.mp3', 'missile_flyby.wav', 'laugh.mp3']);
    player = JoystickPlayer(joystick);
    add(player);
    add(joystick);
    createEnemies();
  }

  createEnemies() async {
    var newPosition = Vector2(size.x / Random().nextInt(10), 100);
    add(Enemy()..position = newPosition);
    // while (true) {
    //   await Future.delayed(const Duration(seconds: 10));
    //   if (_enemyCount <= 20) {
    //     newPosition = Vector2(size.x / Random().nextInt(10), 100);
    //     add(Enemy()..position = newPosition);
    //   }
    // }
  }

  @override
  void onTapUp(TapUpInfo info) {
    var velocity = Vector2(0, -1);
    velocity.rotate(player.angle);
    add(Bullet(player.position, velocity)..size = Vector2.all(5));
    if (_isFirstIntract) {
      // FlameAudio.bgm.play('background_3.mp3', volume: 0.2);
      _isFirstIntract = false;
    }
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
      position = Utils.wrapPosition(gameRef.size, position);
      angle = joystick.delta.screenAngle();
    }
  }
}
