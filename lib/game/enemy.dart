import 'dart:math';

import 'package:flutter/material.dart';

const TOP = Point(0, -1);
const LEFT = Point(-1, 0);
const RIGHT = Point(1, 0);
const BOTTOM = Point(0, 1);

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
    final pathIndex = tilesTraveled.floor();
    final tileCoord = path[pathIndex];
    position = Offset(tileCoord.x.toDouble(), tileCoord.y.toDouble()) +
        _calculateTileOffset(pathIndex);
  }

  Offset _calculateTileOffset(int pathIndex) {
    final tileProgress = tilesTraveled % 1;

    if (tileProgress < 0.5) {
      Point<int> from = pathIndex == 0
          ? path[pathIndex] - path[pathIndex + 1]
          : path[pathIndex - 1] - path[pathIndex];

      if (from == TOP) {
        return Offset(0.5, tileProgress);
      }
      if (from == LEFT) {
        return Offset(tileProgress, 0.5);
      }
      if (from == RIGHT) {
        return Offset(1 - tileProgress, 0.5);
      }
      if (from == BOTTOM) {
        return Offset(0.5, 1 - tileProgress);
      }
    } else {
      Point<int> to = pathIndex == path.length - 1
          ? path[pathIndex] - path[pathIndex - 1]
          : path[pathIndex + 1] - path[pathIndex];

      if (to == BOTTOM) {
        return Offset(0.5, tileProgress);
      }
      if (to == RIGHT) {
        return Offset(tileProgress, 0.5);
      }
      if (to == LEFT) {
        return Offset(1 - tileProgress, 0.5);
      }
      if (to == TOP) {
        return Offset(0.5, 1 - tileProgress);
      }
    }
    return Offset.zero;
  }

  void render(Canvas canvas, {double tileSize}) {
    if (position == null) return;
    canvas.drawRect(
      Rect.fromCenter(
        center: position * tileSize,
        width: tileSize / 4,
        height: tileSize / 4,
      ),
      paint,
    );
  }
}
