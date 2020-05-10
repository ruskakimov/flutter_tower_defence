import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tower_defence/game/tower_defence_level.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({Key key, this.game}) : super(key: key);

  final TowerDefenceLevel game;

  @override
  _LevelPageState createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    final cols = game.cols;
    final rows = game.rows;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: cols / rows,
              child: game.widget,
            ),
            GridView.count(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              crossAxisCount: cols,
              childAspectRatio: 1,
              children: List.generate(
                cols * rows,
                (index) {
                  final tileCoord = Point(index % cols, (index / cols).floor());

                  Color getBgColor(candidates, rejects) {
                    if (rejects.isNotEmpty)
                      return Colors.redAccent.withOpacity(0.8);
                    if (candidates.isNotEmpty)
                      return Colors.greenAccent.withOpacity(0.8);
                    return Colors.transparent;
                  }

                  return DragTarget<TowerType>(
                    onWillAccept: (_) => game.canDrop(tileCoord),
                    onAccept: (towerType) => game.drop(
                      type: towerType,
                      tileCoord: tileCoord,
                    ),
                    builder: (context, candidates, rejects) {
                      return Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: getBgColor(candidates, rejects),
                        ),
                      );
                    },
                  );
                },
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
                  game.addEnemy();
                }),
            Draggable<TowerType>(
              data: TowerType.laser,
              maxSimultaneousDrags: 1,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
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
    );
  }
}
