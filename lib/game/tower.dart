import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'enemy.dart';

abstract class Tower {
  final rangeBorderPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  final rangeAreaPaint = Paint()
    ..color = Colors.white12
    ..style = PaintingStyle.fill;

  Tower(this.tileCoord);

  Point<int> tileCoord;
  int range;

  void render(Canvas canvas, {double tileSize});

  void renderRange(Canvas canvas, {double tileSize});

  void damage(double t, {List<Enemy> enemies});

  bool inRange(Enemy enemy) {
    if (enemy.position == null) return false;
    final minX = tileCoord.x - range;
    final maxX = tileCoord.x + 1 + range;
    final minY = tileCoord.y - range;
    final maxY = tileCoord.y + 1 + range;
    final x = enemy.position.dx;
    final y = enemy.position.dy;
    return x >= minX && x <= maxX && y >= minY && y <= maxY;
  }
}

class LaserTower extends Tower {
  static final towerPaint = Paint()..color = Colors.yellow;
  static final laserPaint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = 2;

  LaserTower(Point<int> tileCoord) : super(tileCoord);

  double damagePerSecond = 0.5;
  Enemy target;

  @override
  int get range => 1;

  @override
  void render(Canvas canvas, {double tileSize}) {
    final towerCenter = Offset(tileCoord.x + 0.5, tileCoord.y + 0.5) * tileSize;
    canvas.drawRect(
      Rect.fromCenter(
        center: towerCenter,
        width: tileSize / 2,
        height: tileSize / 2,
      ),
      towerPaint,
    );
    if (target != null) {
      canvas.drawLine(towerCenter, target.position * tileSize, laserPaint);
    }
  }

  @override
  void renderRange(Canvas canvas, {double tileSize}) {
    final center = Offset(tileCoord.x + 0.5, tileCoord.y + 0.5) * tileSize;
    final size = tileSize * (2 * range + 1);
    canvas.drawRect(
      Rect.fromCenter(center: center, width: size, height: size),
      rangeAreaPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: center, width: size, height: size),
      rangeBorderPaint,
    );
  }

  @override
  void damage(double t, {List<Enemy> enemies}) {
    target = enemies.firstWhere((enemy) => inRange(enemy), orElse: () => null);
    if (target != null) target.health -= damagePerSecond * t;
  }
}
