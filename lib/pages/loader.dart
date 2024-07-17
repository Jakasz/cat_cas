import 'dart:async';

import 'package:cas_cat/components/simple_text.dart';
import 'package:cas_cat/pages/main_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';

class LoaderPage extends Component with HasGameRef<MainGameScreen> {
  bool loadCompleted = false;
  bool timerComplete = false;
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
// This returns a List<String> with all your images
    List<String> imageAssetsList = assetManifest
        .listAssets()
        .where((string) => string.startsWith("assets/images/"))
        .toList();
    await loadAssets(imageAssetsList);
    add(SpriteComponent()
      ..sprite = await Sprite.load('loader_back.png')
      ..size = gameRef.size
      ..position = Vector2.zero());
    addSetIfNotExtists();
    add(SpriteComponent()
      ..sprite = await Sprite.load('loader.png')
      ..size = Vector2.all(151)
      ..anchor = Anchor.center
      ..position = Vector2(gameRef.size.x / 2, gameRef.size.y / 1.25)
      ..add(RotateEffect.to(-5, EffectController(duration: 3), onComplete: () {
        if (loadCompleted) {
          timerComplete = true;
        }
      })));
    add(
      SimpleText(
          inputText: '50%',
          pos: Vector2(gameRef.size.x / 2.4, gameRef.size.y / 1.3),
          textSize: Vector2(5, 5),
          fontTextSize: 30),
    );
  }

  @override
  void update(double dt) {
    if (loadCompleted && timerComplete) {
      loadCompleted = false;
      timerComplete = false;
      gameRef.goInMenu = true;
    }
  }

  Future<void> loadAssets(List<String> imageAssetsList) async {
    for (var el in imageAssetsList) {
      await gameRef.images.load(el.replaceAll('assets/images/', ''));
    }
    loadCompleted = true;
  }

  void addSetIfNotExtists() {
    var prefs = gameRef.prefs;
    prefs.setInt('score', 100);
    var boughtItems = prefs.getStringList('storedBackgrounds');
    if (boughtItems == null) {
      prefs.setStringList('storedBackgrounds', []);
    }
  }
}
