import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/actors/player.dart';
import 'package:flutter_game/levels/level.dart';
import 'package:flutter_game/utils/assets_constants.dart';

class PixelAdventurer extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  late final CameraComponent cam;
  Player player = Player(character: AssetsConstant.maskedDude);
  late JoystickComponent joystick;
  bool showJoystick = false;

  @override
  Color backgroundColor() {
    return const Color(0xFF211F30);
  }

  @override
  FutureOr<void> onLoad() async {
    // Load all images to cache
    await images.loadAllImages();

    final world = Level(
      levelName: AssetsConstant.level1,
      player: player,
    );
    cam = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      world: world,
    )
      ..priority = 0
      ..viewfinder.anchor = Anchor.topLeft;

    if (showJoystick) {
      addJoyStick();
    }

    addAll([cam, world]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);

    if (showJoystick) {
      updateJoyStick();
    }
  }

  void updateJoyStick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.right;
        break;
      default:
        player.playerDirection = PlayerDirection.none;
      //idle
    }
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      priority: 1,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('Joystick/${AssetsConstant.joystickKnob}'),
        ),
      ),
      knobRadius: 64,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('Joystick/${AssetsConstant.joystickBackground}'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }
}
