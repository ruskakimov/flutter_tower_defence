import 'dart:math';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/particle_component.dart';
import 'package:flame/game/game.dart';
import 'package:flame/particle.dart';
import 'package:flame/particles/accelerated_particle.dart';
import 'package:flame/particles/circle_particle.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const PATH = [
  0,
  1,
  2,
  10,
  18,
  19,
  20,
  12,
  4,
  5,
  6,
  14,
  22,
  30,
  38,
  46,
  45,
  44,
  43,
  42,
  41,
  40,
  48,
  56,
  64,
  72,
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final game = MyGame();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  AspectRatio(aspectRatio: 8 / 10, child: game.widget),
                  GridView.count(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    crossAxisCount: 8,
                    childAspectRatio: 1,
                    children: List.generate(
                      8 * 10,
                      (index) => Cell(
                        isPath: PATH.contains(index),
                        onAccept: (_) {
                          game.add(Turret(index: index));
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Add'),
                    onPressed: () {
                      game.add(Enemy());
                    },
                  ),
                  Draggable<String>(
                    data: 'Hello',
                    maxSimultaneousDrags: 1,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Container(
                          height: 20,
                          width: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    feedbackOffset: Offset(0, -80),
                    dragAnchor: DragAnchor.child,
                    feedback: Transform.translate(
                      offset: Offset(0, -80),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Cell extends StatefulWidget {
  const Cell({
    Key key,
    this.isPath = false,
    this.onAccept,
  }) : super(key: key);

  final bool isPath;
  final Function onAccept;

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAccept: widget.onAccept,
      onWillAccept: (_) => !widget.isPath,
      builder: (context, candidates, rejects) {
        return Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(color: getBgColor(candidates, rejects)),
        );
      },
    );
  }

  Color getBgColor(candidates, rejects) {
    if (rejects.isNotEmpty) return Colors.redAccent.withOpacity(0.8);
    if (candidates.isNotEmpty) return Colors.greenAccent.withOpacity(0.8);
    return Colors.transparent;
  }
}

class Enemy extends PositionComponent with Resizable {
  double progress = 0;
  static final paint = Paint()..color = Colors.red;
  List<int> path = PATH;

  @override
  void render(Canvas c) {
    c.drawRect(
      Rect.fromCenter(
        center: getOffsetFromProgress(
          cols: 8,
          path: path,
          width: size.width,
          progress: progress,
        ),
        height: 10,
        width: 10,
      ),
      paint,
    );
  }

  @override
  void update(double t) {
    this.progress += 1 * t / path.length;
  }

  @override
  bool destroy() {
    return this.progress >= 1;
  }
}

class MyGame extends BaseGame {
  MyGame() {
    add(Enemy());
  }
}

Offset getOffsetFromProgress({
  int cols,
  List<int> path,
  double width,
  double progress, // between 0 and 1
}) {
  final cellWidth = width / cols;
  final pathIndex = (progress * path.length).floor();
  final cellProgress = progress * path.length % 1;
  final cellIndex = path[pathIndex];
  final x = cellIndex % cols;
  final y = (cellIndex / cols).floor();
  return Offset(x * cellWidth, y * cellWidth) +
      getCellOffset(cols, path, pathIndex, cellProgress) * cellWidth;
}

Offset getCellOffset(
  int cols,
  List<int> path,
  int pathIndex,
  double cellProgress, // between 0 and 1
) {
  bool fromTop() =>
      pathIndex == 0 || path[pathIndex - 1] == path[pathIndex] - cols;
  bool fromLeft() => path[pathIndex - 1] == path[pathIndex] - 1;
  bool fromRight() => path[pathIndex - 1] == path[pathIndex] + 1;
  bool fromBottom() => path[pathIndex - 1] == path[pathIndex] + cols;

  bool toBottom() =>
      pathIndex == path.length - 1 ||
      path[pathIndex + 1] == path[pathIndex] + cols;
  bool toRight() => path[pathIndex + 1] == path[pathIndex] + 1;
  bool toLeft() => path[pathIndex + 1] == path[pathIndex] - 1;
  bool toTop() => path[pathIndex + 1] == path[pathIndex] - cols;

  if (cellProgress < 0.5) {
    if (fromTop()) {
      return Offset(0.5, cellProgress);
    }
    if (fromLeft()) {
      return Offset(cellProgress, 0.5);
    }
    if (fromRight()) {
      return Offset(1 - cellProgress, 0.5);
    }
    if (fromBottom()) {
      return Offset(0.5, 1 - cellProgress);
    }
  } else {
    if (toBottom()) {
      return Offset(0.5, cellProgress);
    }
    if (toRight()) {
      return Offset(cellProgress, 0.5);
    }
    if (toLeft()) {
      return Offset(1 - cellProgress, 0.5);
    }
    if (toTop()) {
      return Offset(0.5, 1 - cellProgress);
    }
  }
  return Offset(0.5, 0.5);
}

class Turret extends Component with Resizable {
  Turret({this.index});

  final int index;

  @override
  void render(Canvas c) {
    final cellWidth = size.width / 8;
    c.drawRect(
      Rect.fromLTWH(
        index % 8 * cellWidth,
        (index / 8).floor() * cellWidth,
        cellWidth,
        cellWidth,
      ),
      Paint()..color = Colors.blueAccent,
    );
  }

  @override
  void update(double t) {
    // TODO: implement update
  }
}
