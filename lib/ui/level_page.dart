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

    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
              child: Text('Spawn enemy'),
              onPressed: () {
                game.addEnemy();
              }),
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
                    final tileCoord =
                        Point(index % cols, (index / cols).floor());

                    Color getBgColor(candidates, rejects) {
                      if (rejects.isNotEmpty)
                        return Colors.redAccent.withOpacity(0.8);
                      if (candidates.isNotEmpty)
                        return Colors.greenAccent.withOpacity(0.8);
                      return Colors.transparent;
                    }

                    return DragTarget<DropType>(
                      onWillAccept: (type) =>
                          game.willDrop(type: type, tileCoord: tileCoord),
                      onAccept: (_) => game.drop(),
                      onLeave: (_) => game.dropCancel(),
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
              DraggableDropItem(
                item: DropType.laserTower,
                label: 'L',
              ),
              DraggableDropItem(
                item: DropType.beamTower,
                label: 'B',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DraggableDropItem extends StatelessWidget {
  const DraggableDropItem({
    Key key,
    this.item,
    this.label,
  }) : super(key: key);

  final DropType item;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Draggable<DropType>(
      data: item,
      maxSimultaneousDrags: 1,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(child: Text(label)),
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
    );
  }
}
