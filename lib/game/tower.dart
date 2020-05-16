import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'calculate_enemy_offset.dart';
import 'enemy.dart';

abstract class Tower {
  static final rangeBorderPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  static final rangeAreaPaint = Paint()
    ..color = Colors.white12
    ..style = PaintingStyle.fill;

  Tower(this.tileCoord);

  Point<int> tileCoord;

  void render(Canvas canvas, {double tileSize});

  void renderRange(Canvas canvas, {double tileSize});

  void damage(double t, {List<Enemy> enemies});

  void onTap();
}

class LaserTower extends Tower {
  static final towerPaint = Paint()..color = Colors.yellow;
  static final laserPaint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = 2;

  LaserTower(Point<int> tileCoord) : super(tileCoord);

  final int range = 1;
  final double damagePerSecond = 0.5;
  Enemy target;

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
      Tower.rangeAreaPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: center, width: size, height: size),
      Tower.rangeBorderPaint,
    );
  }

  @override
  void damage(double t, {List<Enemy> enemies}) {
    target = enemies.firstWhere((enemy) => _inRange(enemy), orElse: () => null);
    if (target != null) target.health -= damagePerSecond * t;
  }

  bool _inRange(Enemy enemy) {
    if (enemy.position == null) return false;
    final minX = tileCoord.x - range;
    final maxX = tileCoord.x + 1 + range;
    final minY = tileCoord.y - range;
    final maxY = tileCoord.y + 1 + range;
    final x = enemy.position.dx;
    final y = enemy.position.dy;
    return x >= minX && x <= maxX && y >= minY && y <= maxY;
  }

  @override
  void onTap() {}
}

class BeamTower extends Tower {
  static final towerPaint = Paint()
    ..color = Colors.lightBlue
    ..strokeWidth = 2;
  static final directions = [TOP, RIGHT, BOTTOM, LEFT];

  BeamTower(Point<int> tileCoord) : super(tileCoord);

  int directionIndex = 0;
  final double damagePerSecond = 10;

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
    final d = directions[directionIndex];
    final directionOffset =
        Offset(d.x.toDouble(), d.y.toDouble()) * tileSize * 10;
    canvas.drawLine(towerCenter, towerCenter + directionOffset, towerPaint);
  }

  @override
  void renderRange(Canvas canvas, {double tileSize}) {}

  @override
  void damage(double t, {List<Enemy> enemies}) {
    final d = directions[directionIndex];
    final affectedTiles = List.generate(10, (index) => tileCoord + d * index);

    enemies.where((enemy) => enemy.position != null).forEach((enemy) {
      final enemyCoord = _positionToTileCoord(enemy.position);
      if (affectedTiles.contains(enemyCoord))
        enemy.health -= damagePerSecond * t;
    });
  }

  Point _positionToTileCoord(Offset pos) {
    return Point(pos.dx.floor(), pos.dy.floor());
  }

  @override
  void onTap() {
    _changeDirection();
  }

  void _changeDirection() {
    directionIndex = (directionIndex + 1) % directions.length;
  }
}
