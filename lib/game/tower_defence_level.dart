import 'dart:math';
import 'dart:ui';

import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/game/game.dart';
import 'package:flutter/material.dart';

import 'tower.dart';
import 'enemy.dart';

// Point<int> - tile coordinate
// Offset     - position
// Offset * tileSize - canvas coordinate

enum DropType {
  laserTower,
  beamTower,
}

class TowerDefenceLevel extends Game with Resizable {
  static final List<Point<int>> _path = <Point<int>>[
    Point(1, 0),
    Point(1, 1),
    Point(1, 2),
    Point(2, 2),
    Point(3, 2),
    Point(3, 1),
    Point(4, 1),
    Point(5, 1),
    Point(5, 2),
    Point(5, 3),
    Point(5, 4),
    Point(4, 4),
    Point(3, 4),
    Point(2, 4),
    Point(2, 5),
    Point(2, 6),
    Point(3, 6),
    Point(4, 6),
    Point(5, 6),
    Point(5, 7),
    Point(5, 8),
    Point(5, 9),
  ];

  final List<Enemy> _enemies = [
    Enemy(path: _path, health: 1, tilesPerSecond: 1, tilesTraveled: 0),
    Enemy(path: _path, health: 1, tilesPerSecond: 1, tilesTraveled: -1),
    Enemy(path: _path, health: 1, tilesPerSecond: 1, tilesTraveled: -2),
    Enemy(path: _path, health: 1, tilesPerSecond: 1, tilesTraveled: -3),
    Enemy(path: _path, health: 1, tilesPerSecond: 1, tilesTraveled: -4),
    Enemy(path: _path, health: 1, tilesPerSecond: 1, tilesTraveled: -5),
    Enemy(path: _path, health: 1, tilesPerSecond: 1, tilesTraveled: -6),
    Enemy(path: _path, health: 1, tilesPerSecond: 1, tilesTraveled: -7),
  ];

  int coins = 0;
  Function onCoinChange;

  final List<Tower> _towers = [];

  Tower hoveringTower;

  int get rows => 10;
  int get cols => 8;

  bool willDrop({DropType type, Point<int> tileCoord}) {
    if (type == DropType.laserTower) hoveringTower = LaserTower(tileCoord);
    if (type == DropType.beamTower) hoveringTower = BeamTower(tileCoord);
    return _canDrop(tileCoord);
  }

  bool _canDrop(Point<int> tileCoord) =>
      !_path.contains(tileCoord) &&
      _towers.where((tower) => tower.tileCoord == tileCoord).isEmpty;

  void drop() {
    if (hoveringTower != null && _canDrop(hoveringTower.tileCoord))
      _towers.add(hoveringTower);
    hoveringTower = null;
  }

  void dropCancel() {
    hoveringTower = null;
  }

  void addEnemy() {
    _enemies.add(
        Enemy(path: _path, health: 1, tilesPerSecond: 1, tilesTraveled: 0));
  }

  void onTap(Point<int> tileCoord) {
    final targetTower =
        _towers.firstWhere((tower) => tower.tileCoord == tileCoord);
    targetTower.onTap();
  }

  @override
  void render(Canvas canvas) {
    final tileSize = size.width / cols;
    final pathPaint = Paint()..color = Colors.grey[800];
    _path.forEach((tileCoord) {
      canvas.drawRect(
        Rect.fromLTWH(
          tileCoord.x * tileSize,
          tileCoord.y * tileSize,
          tileSize,
          tileSize,
        ),
        pathPaint,
      );
    });
    _enemies.forEach((enemy) => enemy.render(canvas, tileSize: tileSize));
    _towers.forEach((tower) => tower.render(canvas, tileSize: tileSize));
    if (hoveringTower != null)
      hoveringTower.renderRange(canvas, tileSize: tileSize);
  }

  @override
  void update(double t) {
    _enemies.forEach((enemy) => enemy.update(t));
    _towers.forEach((tower) => tower.damage(t, enemies: _enemies));
    _enemies.where((enemy) => enemy.isDead).forEach((enemy) {
      coins += enemy.maxHealth;
      if (onCoinChange != null) onCoinChange(coins);
    });
    _enemies.removeWhere((enemy) => enemy.isDead);
  }
}
