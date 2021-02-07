import 'package:RummyCalculator/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:RummyCalculator/constants.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/database.dart';

//Screens
import 'package:RummyCalculator/screens/delete_points_pop_up.dart';
import 'package:RummyCalculator/screens/info.dart';
import 'package:RummyCalculator/screens/new_game.dart';

class MenuDraw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<Data>(context).isDarkMode;

    return Drawer(
      elevation: 10.0,
      child: Container(
        color: darkMode ? kInverseWhite : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/cards.jpg',
              fit: BoxFit.cover,
              height: 200,
            ),
            DrawerTile(
              title: Provider.of<Data>(context).translations['new_game'],
              ikona: Icons.add,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => NewGame()));
              },
            ),
            DrawerTile(
              title: Provider.of<Data>(context).translations['undo'],
              ikona: Icons.undo,
              onTap: () {
                Provider.of<Data>(context, listen: false).undoDeletedRow();
                Navigator.of(context).pop();
              },
            ),
            DrawerTile(
              title:
                  Provider.of<Data>(context).translations['delete_all_points'],
              ikona: Icons.delete_sweep,
              onTap: () {
                if (Provider.of<Data>(context, listen: false).points.isNotEmpty)
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return DeletePointsPopUp();
                      });
              },
            ),
            DrawerTile(
              title: Provider.of<Data>(context).translations['settings'],
              ikona: Icons.settings_applications,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Settings(),
                ));
              },
            ),
            Expanded(
              child: Container(),
            ),
            DrawerTile(
              title: 'Developer',
              ikona: Icons.info,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => InfoScreen()));
              },
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData ikona;
  final String title;
  final Function onTap;

  DrawerTile({this.title, this.ikona, this.onTap});

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<Data>(context).isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: kDrawerTileHeight,
//        color: darkMode ? kInverseWhite : Colors.white,
        child: Row(
          children: <Widget>[
            SizedBox(width: 10.0),
            Icon(
              ikona,
              size: 25.0,
              color: darkMode ? Colors.white : Colors.black87,
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: animationDuration),
                style: TextStyle(
                  fontSize: 24.0,
                  color: darkMode ? Colors.white : Colors.black87,
                ),
                child: Text(
                  title,
                  maxLines: 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//AnimatedDefaultTextStyle(
//duration: Duration(milliseconds: duration),
//style: TextStyle(
//fontSize: 24.0,
//color: Provider.of<Data>(context).isDarkMode
//? Colors.white
//    : Colors.black87,
//),
//child: Text(
//Provider.of<Data>(context).translations['language'],
//maxLines: 1,
//),
//)
