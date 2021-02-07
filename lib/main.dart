import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/screens/game.dart';
import 'package:RummyCalculator/database.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OrientationBuilder(
          builder: (context, orientation) {
            return Game(orientation: orientation, context: context);
          },
        ),
      ),
    );
  }
}
