import 'package:flutter/material.dart';
import 'package:tower_defence/game/tower_defence_level.dart';
import 'package:tower_defence/ui/level_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tower defence game',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
      ),
      home: LevelPage(game: TowerDefenceLevel()),
    );
  }
}
