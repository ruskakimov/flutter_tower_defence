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

enum TowerType {
  laser,
}

class TowerDefenceLevel extends Game with Resizable {
  static final List<Point<int>> _path = <Point<int>>[
    Point(1, 0),
    Point(1, 1),
    Point(1, 2),
  ];

  final List<Enemy> _enemies = [
    Enemy(path: _path, health: 1, tilesPerSecond: 0.25, tilesTraveled: 0),
    Enemy(path: _path, health: 1, tilesPerSecond: 0.25, tilesTraveled: -1),
    Enemy(path: _path, health: 1, tilesPerSecond: 0.25, tilesTraveled: -2),
  ];

  final List<Tower> _towers = [];

  int get rows => 3;
  int get cols => 3;

  bool canDrop(Point<int> tileCoord) =>
      !_path.contains(tileCoord) &&
      _towers.where((tower) => tower.tileCoord == tileCoord).isEmpty;

  void drop({TowerType type, Point<int> tileCoord}) {
    _towers.add(LaserTower(tileCoord));
  }

  @override
  void render(Canvas canvas) {
    final tileSize = size.width / cols;
    _enemies.forEach((enemy) => enemy.render(canvas, tileSize: tileSize));
    _towers.forEach((tower) => tower.render(canvas, tileSize: tileSize));
  }

  @override
  void update(double t) {
    _enemies.forEach((enemy) => enemy.update(t));
    _towers.forEach((tower) => tower.damage(t, enemies: _enemies));
    _enemies.removeWhere((enemy) => enemy.isDead);
  }
}
