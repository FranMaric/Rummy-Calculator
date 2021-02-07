import 'package:flutter/material.dart';
import 'package:RummyCalculator/constants.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/database.dart';
//import 'package:wakelock/wakelock.dart';

//Screens
import 'package:RummyCalculator/screens/menu_draw.dart';
import 'package:RummyCalculator/screens/new_game.dart';

//Widgets
import 'package:RummyCalculator/widgets/paper.dart';

class Game extends StatefulWidget {
  final Orientation orientation;
  final BuildContext context;

  Game({this.context, this.orientation});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Provider.of<Data>(context).isDarkMode
            ? Colors.black
            : kBackgroundColor,
        drawer: widget.orientation == Orientation.portrait ? MenuDraw() : null,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Provider.of<Data>(context).isDarkMode
              ? Colors.black
              : kBackgroundColor,
          title: Text(
            Provider.of<Data>(context).translations['title'],
            style: kTitleTextStyle,
          ),
        ),
        floatingActionButton: widget.orientation == Orientation.portrait
            ? Visibility(
                visible: Provider.of<Data>(context).addButtonVisible,
                child: FloatingActionButton(
                  backgroundColor: Provider.of<Data>(context).isDarkMode
                      ? Colors.black
                      : kButtonColor,
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  onPressed: () {
//                    Wakelock.enable();
                    if (Provider.of<Data>(context, listen: false)
                            .players
                            .length !=
                        0)
                      Provider.of<Data>(context, listen: false).showNumberPad();
                    else
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => NewGame()));
                  },
                ),
              )
            : null,
        body: Paper(orientation: widget.orientation),
      );
    } catch (e) {
      setState(() {
//        print('NEW STATE');
      });
      return Scaffold(
        backgroundColor: kBackgroundColor,
      );
    }
  }
}
