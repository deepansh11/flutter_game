import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game/actors/player.dart';

class Level extends World {
  late TiledComponent level;
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(levelName, Vector2.all(16));

    add(level);
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
        }
      }
    }
    return super.onLoad();
  }
}
