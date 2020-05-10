import 'dart:math';

import 'dart:ui';

const TOP = Point(0, -1);
const LEFT = Point(-1, 0);
const RIGHT = Point(1, 0);
const BOTTOM = Point(0, 1);

Offset calculateEnemyOffset({double tilesTraveled, List<Point<int>> path}) {
  if (tilesTraveled < 0 || tilesTraveled >= path.length)
    throw Exception('`tilesTraveled` value $tilesTraveled is out of bounds.');
  if (path.length < 2) throw Exception('Path length should be above 1');

  final pathIndex = tilesTraveled.floor();
  final tileCoord = path[pathIndex];

  return Offset(
        tileCoord.x.toDouble(),
        tileCoord.y.toDouble(),
      ) +
      _calculateTileOffset(
        pathIndex: pathIndex,
        tilesTraveled: tilesTraveled,
        path: path,
      );
}

Offset _calculateTileOffset({
  int pathIndex,
  double tilesTraveled,
  List<Point<int>> path,
}) {
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
