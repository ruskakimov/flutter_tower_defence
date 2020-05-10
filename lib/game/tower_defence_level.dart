import 'dart:math';
import 'dart:ui';

import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/game/game.dart';
import 'package:flutter/material.dart';

import 'enemy.dart';

// Point<int> - tile coordinate
// Offset     - position
// Offset * tileSize - canvas coordinate

class TowerDefenceLevel extends Game with Resizable {
  final tileMatrix = [
    [null, null, null],
    [null, null, null],
    [null, null, null],
  ];

  static final List<Point<int>> _path = <Point<int>>[
    // Point(0, 0),
    // Point(0, 1),
    // Point(0, 2),
    // Point(1, 2),
    // Point(1, 1),
    // Point(1, 0),
    // Point(2, 0),
    // Point(2, 1),
    // Point(2, 2),
    Point(0, 1),
    Point(1, 1),
    Point(2, 1),
  ];

  final List<Enemy> _enemies = [
    Enemy(path: _path, health: 1, tilesPerSecond: 1, tilesTraveled: -1),
    Enemy(path: _path, health: 1, tilesPerSecond: 1, tilesTraveled: -2),
    Enemy(path: _path, health: 1, tilesPerSecond: 1, tilesTraveled: -3),
  ];

  int get rows => tileMatrix.length;
  int get cols => tileMatrix[0].length;

  bool canDrop(Point<int> tileCoord) =>
      !_path.contains(tileCoord) &&
      tileMatrix[tileCoord.y][tileCoord.x] == null;

  @override
  void render(Canvas canvas) {
    final tileSize = size.width / cols;
    _enemies.forEach((enemy) => enemy.render(canvas, tileSize: tileSize));
  }

  @override
  void update(double t) {
    _enemies.forEach((enemy) => enemy.update(t));
    _enemies.removeWhere((enemy) => enemy.isDead);
  }
}
