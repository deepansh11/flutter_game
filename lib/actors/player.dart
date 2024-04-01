import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/pixel_adventurer.dart';
import 'package:flutter_game/utils/assets_constants.dart';

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventurer>, KeyboardHandler {
  String character;

  Player({this.character = AssetsConstant.ninjaFrog, position})
      : super(
          position: position,
        );

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updatePlayerMovement(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = checkIfKeyIsPressed([
      LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.arrowLeft,
    ], keysPressed);

    final isRightKeyPressed = checkIfKeyIsPressed([
      LogicalKeyboardKey.keyD,
      LogicalKeyboardKey.arrowRight,
    ], keysPressed);

    directionBasedOnKeys(isLeftKeyPressed, isRightKeyPressed);

    return super.onKeyEvent(event, keysPressed);
  }

  void directionBasedOnKeys(bool isLeftKeyPressed, bool isRightKeyPressed) {
    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }
  }

  bool checkIfKeyIsPressed(
      List<LogicalKeyboardKey> keys, Set<LogicalKeyboardKey> keysPressed) {
    for (final key in keys) {
      if (keysPressed.contains(key)) {
        return true;
      }
    }
    return false;
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        break;
      default:
    }
    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }

  void _loadAllAnimation() {
    idleAnimation = _sequencedSpriteAnimation("Idle", 11);
    runningAnimation = _sequencedSpriteAnimation("Run", 12);

    // List of all animation
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    // Set Current Animation
    current = PlayerState.idle;
  }

  SpriteAnimation _sequencedSpriteAnimation(
    String animationState,
    int amount,
  ) {
    return SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Main Characters/$character/$animationState (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(
          32,
        ),
      ),
    );
  }
}
