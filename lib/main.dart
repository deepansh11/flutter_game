import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/pixel_adventurer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  PixelAdventurer game = PixelAdventurer();
  runApp(GameWidget(game: kDebugMode ? PixelAdventurer() : game));
}
