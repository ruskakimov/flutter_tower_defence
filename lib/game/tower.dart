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
  int price;

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
  final int price = 5;
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
  static final stateDurations = <double>[5, 1];
  final statesPeriod = stateDurations.reduce((a, b) => a + b);

  BeamTower(Point<int> tileCoord) : super(tileCoord);

  int directionIndex = 0;
  final int price = 20;
  final double damagePerSecond = 10;
  double stateTimePosition = 0;

  int get stateIndex {
    double low = 0;
    for (var i = 0; i < stateDurations.length; i++) {
      final high = low + stateDurations[i];
      if (stateTimePosition >= low && stateTimePosition <= high) return i;
      low = high;
    }
    return -1;
  }

  bool get isCharging => stateIndex == 0;
  bool get isShooting => !isCharging;

  double get juiceLevel {
    if (isCharging) {
      return stateTimePosition / stateDurations[0];
    } else {
      return 1 - (stateTimePosition - stateDurations[0]) / stateDurations[1];
    }
  }

  @override
  void render(Canvas canvas, {double tileSize}) {
    final towerCenter = Offset(tileCoord.x + 0.5, tileCoord.y + 0.5) * tileSize;
    canvas.drawCircle(
      towerCenter,
      tileSize / 3,
      towerPaint,
    );

    final d = directions[directionIndex];
    final directionOffset =
        Offset(d.x.toDouble(), d.y.toDouble()) * tileSize * 0.5;
    final laserPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.lightBlue
      ..strokeWidth = tileSize / 5;
    canvas.drawLine(
      towerCenter,
      towerCenter + directionOffset,
      laserPaint,
    );

    if (isShooting) {
      canvas.drawLine(
        towerCenter,
        towerCenter + directionOffset * 20,
        laserPaint,
      );
    }

    canvas.drawArc(
      Rect.fromCenter(
        center: towerCenter,
        width: tileSize / 3,
        height: tileSize / 3,
      ),
      -pi / 2,
      -juiceLevel * pi * 2,
      true,
      Paint()..color = Colors.white,
    );
  }

  @override
  void renderRange(Canvas canvas, {double tileSize}) {}

  @override
  void damage(double t, {List<Enemy> enemies}) {
    _updateStateTimePosition(t);

    if (isShooting) {
      final d = directions[directionIndex];
      final affectedTiles = List.generate(10, (index) => tileCoord + d * index);

      enemies.where((enemy) => enemy.position != null).forEach((enemy) {
        final enemyCoord = _positionToTileCoord(enemy.position);
        if (affectedTiles.contains(enemyCoord))
          enemy.health -= damagePerSecond * t;
      });
    }
  }

  void _updateStateTimePosition(double t) {
    stateTimePosition = (stateTimePosition + t) % statesPeriod;
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
