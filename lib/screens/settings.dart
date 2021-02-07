import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RummyCalculator/constants.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/database.dart';

import 'package:RummyCalculator/screens/menu_draw.dart';
import 'package:wakelock/wakelock.dart';

int duration = 500;

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<Data>(context).isDarkMode
          ? Colors.black
          : kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Provider.of<Data>(context).isDarkMode
            ? Colors.black
            : kBackgroundColor,
        title: Text(
          Provider.of<Data>(context).translations['settings'],
          style: kTitleTextStyle,
        ),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: duration),
        padding: EdgeInsets.only(top: 15.0),
        decoration: BoxDecoration(
          color: Provider.of<Data>(context).isDarkMode
              ? kInverseWhite
              : Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DrawerTile(
                      title:
                          Provider.of<Data>(context).translations['dark_mode'],
                      ikona: Icons.power_settings_new),
                ),
                Container(
                  height: kDrawerTileHeight,
                  child: Switch(
                    activeColor: Colors.white,
                    value: Provider.of<Data>(context).isDarkMode,
                    onChanged: (bool newValue) {
                      Provider.of<Data>(context, listen: false)
                          .setDarkMode(newValue);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DrawerTile(
                      title: Provider.of<Data>(context).translations['sum'],
                      ikona: Icons.add_box),
                ),
                Container(
                  height: kDrawerTileHeight,
                  child: Switch(
                    activeColor: Provider.of<Data>(context).isDarkMode
                        ? Colors.white
                        : null,
                    value: Provider.of<Data>(context).showSum,
                    onChanged: (bool newValue) {
                      Provider.of<Data>(context, listen: false)
                          .setShowSum(newValue);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DrawerTile(
                      title:
                          Provider.of<Data>(context).translations['always_on'],
                      ikona: Icons.screen_lock_portrait),
                ),
                Container(
                  height: kDrawerTileHeight,
                  child: Switch(
                    activeColor: Provider.of<Data>(context).isDarkMode
                        ? Colors.white
                        : null,
                    value: Provider.of<Data>(context).isAlwaysOn,
                    onChanged: (bool newValue) {
                      if (newValue)
                        Wakelock.enable();
                      else
                        Wakelock.disable();
                      Provider.of<Data>(context, listen: false)
                          .setAlwaysOn(newValue);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    Icon(
                      Icons.language,
                      size: 25.0,
                      color: Provider.of<Data>(context).isDarkMode
                          ? Colors.white
                          : Colors.black87,
                    ),
                    SizedBox(width: 12.0),
                    AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: duration),
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Provider.of<Data>(context).isDarkMode
                            ? Colors.white
                            : Colors.black87,
                      ),
                      child: Text(
                        Provider.of<Data>(context).translations['language'],
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Provider.of<Data>(context).isDarkMode
                        ? kInverseWhite
                        : Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 50.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: Provider.of<Data>(context, listen: false)
                                .langCodeConvert[
                            Provider.of<Data>(context, listen: false)
                                .currentLang],
                        onChanged: (String newValue) {
                          Provider.of<Data>(context, listen: false)
                              .changeLang(newValue);
                        },
                        items: [
                          for (int i = 0;
                              i <
                                  Provider.of<Data>(context, listen: false)
                                      .supportedLang
                                      .length;
                              i++)
                            DropdownMenuItem(
                              value: Provider.of<Data>(context, listen: false)
                                      .langCodeConvert[
                                  Provider.of<Data>(context, listen: false)
                                      .supportedLang[i]],
                              child: Text(
                                Provider.of<Data>(context, listen: false)
                                        .langCodeConvert[
                                    Provider.of<Data>(context, listen: false)
                                        .supportedLang[i]],
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Provider.of<Data>(context).isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
