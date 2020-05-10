import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tower_defence/game/calculate_enemy_offset.dart';

class Enemy {
  static final paint = Paint()..color = Colors.red;

  Enemy({
    this.path,
    this.health,
    this.tilesPerSecond,
    this.tilesTraveled = 0,
  });

  final List<Point<int>> path;
  final double tilesPerSecond;
  double health;
  double tilesTraveled;
  Offset position;

  bool get isDead => tilesTraveled >= path.length || health <= 0;

  void update(double t) {
    tilesTraveled += tilesPerSecond * t;
    _updatePosition();
  }

  void _updatePosition() {
    if (tilesTraveled < 0 || tilesTraveled >= path.length) return;
    position = calculateEnemyOffset(tilesTraveled: tilesTraveled, path: path);
  }

  void render(Canvas canvas, {double tileSize}) {
    if (position == null) return;
    canvas.drawRect(
      Rect.fromCenter(
        center: position * tileSize,
        width: tileSize * _enemySize,
        height: tileSize * _enemySize,
      ),
      paint,
    );
  }

  double get _enemySize => 0.25 * (health * 2).ceil() / 2;
}
