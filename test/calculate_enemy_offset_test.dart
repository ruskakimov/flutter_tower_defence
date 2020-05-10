import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tower_defence/game/calculate_enemy_offset.dart';

void main() {
  test('Down 2 cells', () {
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0,
        path: [Point(0, 0), Point(0, 1)],
      ),
      Offset(0.5, 0),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0.25,
        path: [Point(0, 0), Point(0, 1)],
      ),
      Offset(0.5, 0.25),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0.5,
        path: [Point(0, 0), Point(0, 1)],
      ),
      Offset(0.5, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0.75,
        path: [Point(0, 0), Point(0, 1)],
      ),
      Offset(0.5, 0.75),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1,
        path: [Point(0, 0), Point(0, 1)],
      ),
      Offset(0.5, 1),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.25,
        path: [Point(0, 0), Point(0, 1)],
      ),
      Offset(0.5, 1.25),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.5,
        path: [Point(0, 0), Point(0, 1)],
      ),
      Offset(0.5, 1.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.75,
        path: [Point(0, 0), Point(0, 1)],
      ),
      Offset(0.5, 1.75),
    );
  });

  test('Right 2 cells', () {
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0,
        path: [Point(0, 0), Point(1, 0)],
      ),
      Offset(0, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0.25,
        path: [Point(0, 0), Point(1, 0)],
      ),
      Offset(0.25, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0.5,
        path: [Point(0, 0), Point(1, 0)],
      ),
      Offset(0.5, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0.75,
        path: [Point(0, 0), Point(1, 0)],
      ),
      Offset(0.75, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1,
        path: [Point(0, 0), Point(1, 0)],
      ),
      Offset(1, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.25,
        path: [Point(0, 0), Point(1, 0)],
      ),
      Offset(1.25, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.5,
        path: [Point(0, 0), Point(1, 0)],
      ),
      Offset(1.5, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.75,
        path: [Point(0, 0), Point(1, 0)],
      ),
      Offset(1.75, 0.5),
    );
  });

  test('Left 2 cells', () {
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0,
        path: [Point(1, 0), Point(0, 0)],
      ),
      Offset(2, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0.25,
        path: [Point(1, 0), Point(0, 0)],
      ),
      Offset(1.75, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0.5,
        path: [Point(1, 0), Point(0, 0)],
      ),
      Offset(1.5, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0.75,
        path: [Point(1, 0), Point(0, 0)],
      ),
      Offset(1.25, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1,
        path: [Point(1, 0), Point(0, 0)],
      ),
      Offset(1, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.25,
        path: [Point(1, 0), Point(0, 0)],
      ),
      Offset(0.75, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.5,
        path: [Point(1, 0), Point(0, 0)],
      ),
      Offset(0.5, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.75,
        path: [Point(1, 0), Point(0, 0)],
      ),
      Offset(0.25, 0.5),
    );
  });

  test('Up 2 cells', () {
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0,
        path: [Point(0, 1), Point(0, 0)],
      ),
      Offset(0.5, 2),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0.25,
        path: [Point(0, 1), Point(0, 0)],
      ),
      Offset(0.5, 1.75),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0.5,
        path: [Point(0, 1), Point(0, 0)],
      ),
      Offset(0.5, 1.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 0.75,
        path: [Point(0, 1), Point(0, 0)],
      ),
      Offset(0.5, 1.25),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1,
        path: [Point(0, 1), Point(0, 0)],
      ),
      Offset(0.5, 1),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.25,
        path: [Point(0, 1), Point(0, 0)],
      ),
      Offset(0.5, 0.75),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.5,
        path: [Point(0, 1), Point(0, 0)],
      ),
      Offset(0.5, 0.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.75,
        path: [Point(0, 1), Point(0, 0)],
      ),
      Offset(0.5, 0.25),
    );
  });

  test('Turn from top to right', () {
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.25,
        path: [Point(1, 0), Point(1, 1), Point(0, 1)],
      ),
      Offset(1.5, 1.25),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.75,
        path: [Point(1, 0), Point(1, 1), Point(0, 1)],
      ),
      Offset(1.25, 1.5),
    );
  });

  test('Turn from top to left', () {
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.25,
        path: [Point(1, 0), Point(1, 1), Point(0, 1)],
      ),
      Offset(1.5, 1.25),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.75,
        path: [Point(1, 0), Point(1, 1), Point(2, 1)],
      ),
      Offset(1.75, 1.5),
    );
  });

  test('Turn from left to top', () {
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.25,
        path: [Point(0, 1), Point(1, 1), Point(1, 0)],
      ),
      Offset(1.25, 1.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.75,
        path: [Point(0, 1), Point(1, 1), Point(1, 0)],
      ),
      Offset(1.5, 1.25),
    );
  });

  test('Turn from left to bottom', () {
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.25,
        path: [Point(0, 1), Point(1, 1), Point(1, 2)],
      ),
      Offset(1.25, 1.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.75,
        path: [Point(0, 1), Point(1, 1), Point(1, 2)],
      ),
      Offset(1.5, 1.75),
    );
  });

  test('Turn from right to top', () {
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.25,
        path: [Point(2, 1), Point(1, 1), Point(1, 0)],
      ),
      Offset(1.75, 1.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.75,
        path: [Point(2, 1), Point(1, 1), Point(1, 0)],
      ),
      Offset(1.5, 1.25),
    );
  });

  test('Turn from right to bottom', () {
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.25,
        path: [Point(2, 1), Point(1, 1), Point(1, 2)],
      ),
      Offset(1.75, 1.5),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.75,
        path: [Point(2, 1), Point(1, 1), Point(1, 2)],
      ),
      Offset(1.5, 1.75),
    );
  });

  test('Turn from bottom to right', () {
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.25,
        path: [Point(1, 2), Point(1, 1), Point(0, 1)],
      ),
      Offset(1.5, 1.75),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.75,
        path: [Point(1, 2), Point(1, 1), Point(0, 1)],
      ),
      Offset(1.25, 1.5),
    );
  });

  test('Turn from bottom to left', () {
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.25,
        path: [Point(1, 2), Point(1, 1), Point(2, 1)],
      ),
      Offset(1.5, 1.75),
    );
    expect(
      calculateEnemyOffset(
        tilesTraveled: 1.75,
        path: [Point(1, 2), Point(1, 1), Point(2, 1)],
      ),
      Offset(1.75, 1.5),
    );
  });
}
