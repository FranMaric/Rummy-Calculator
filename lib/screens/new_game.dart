import 'package:flutter/material.dart';
import 'package:RummyCalculator/constants.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/database.dart';

//Screens
// import 'package:calculator/screens/game.dart';

List<String> _players = ['', ''];

class NewGame extends StatefulWidget {
  @override
  _NewGameState createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  void warningSheet(String warningText) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              color: Provider.of<Data>(context).isDarkMode
                  ? kInverseWhite
                  : Color(0xff757575),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                    color: Provider.of<Data>(context).isDarkMode
                        ? Colors.black
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                child: Center(
                  child: Text(
                    warningText,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<Data>(context).isDarkMode
          ? Colors.black
          : kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Provider.of<Data>(context).isDarkMode
            ? Colors.black
            : kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          Provider.of<Data>(context).translations['title'],
          style: kTitleTextStyle,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                color: Provider.of<Data>(context).isDarkMode
                    ? kInverseWhite
                    : Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return NameCard(
                          label:
                              '${Provider.of<Data>(context).translations['player']} ${index + 1}',
                          autoFocus: index == 0,
                          onChanged: (String value) {
                            _players[index] = value;
                          },
                        );
                      },
                      itemCount: _players.length,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  MyButton(
                    label:
                        Provider.of<Data>(context).translations['start_game'],
                    onTap: startNewGame,
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: MyButton(
                        label: Provider.of<Data>(context)
                            .translations['delete_player'],
                        onTap: () {
                          if (_players.length > 2) {
                            setState(() => _players.removeLast());
                          }
                        },
                      )),
                      Expanded(
                        child: MyButton(
                          label: Provider.of<Data>(context)
                              .translations['add_player'],
                          onTap: () {
                            setState(() {
                              if (_players.length < 11) {
                                _players.add('');
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void startNewGame() {
    bool _emptyName = false;
    for (int i = 0; i < _players.length; i++) {
      if (_players[i] == '') {
        _emptyName = true;
        break;
      }
    }
    if (_emptyName) {
      warningSheet(Provider.of<Data>(context, listen: false)
          .translations['players_name_empty']);
    } else if (_players.length != _players.toSet().toList().length) {
      warningSheet(Provider.of<Data>(context, listen: false)
          .translations['duplicate_players']);
    } else if (_players.length == 0) {
      warningSheet(
          Provider.of<Data>(context, listen: false).translations['no_players']);
    } else if (_players.length == 1) {
      warningSheet(Provider.of<Data>(context, listen: false)
          .translations['only_one_player']);
    } else {
      Provider.of<Data>(context, listen: false).newGame(_players);
      _players = ['', ''];
      Navigator.of(context).pop();
    }
  }
}

class MyButton extends StatelessWidget {
  final Function onTap;
  final String label;

  MyButton({this.onTap, this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: kRoundedButtonHeight,
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color:
              Provider.of<Data>(context).isDarkMode ? Colors.black : kPadColor,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 5.0, // has the effect of softening the shadow
              spreadRadius: 2.0, // has the effect of extending the shadow
              offset: Offset(1.0, 3.0),
            )
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Provider.of<Data>(context).isDarkMode
                    ? Colors.white
                    : Colors.black),
          ),
        ),
      ),
    );
  }
}

class NameCard extends StatelessWidget {
  final bool autoFocus;
  final String label;
  final Function onChanged;

  NameCard({this.autoFocus, this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kRoundedButtonHeight,
      margin: EdgeInsets.all(10.0),
      child: TextField(
        onChanged: onChanged,
        maxLines: 1,
        maxLength: 20,
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        decoration: kTextFieldDecoration.copyWith(
          hintText: label,
          hintStyle: TextStyle(
            color: Provider.of<Data>(context).isDarkMode
                ? Colors.white
                : Colors.black,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Provider.of<Data>(context).isDarkMode
                  ? Colors.white
                  : Colors.blueAccent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
        ),
        style: TextStyle(
          color: Provider.of<Data>(context).isDarkMode
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final Function onTap;
  final String label;
  final double leftMargin;
  final double rightMargin;

  RoundedButton(
      {this.onTap,
      this.label,
      this.leftMargin = kRoundedButtonMargin,
      this.rightMargin = kRoundedButtonMargin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
        height: kRoundedButtonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(kRoundedButtonHeight),
          ),
          boxShadow: [
            BoxShadow(
              color: Provider.of<Data>(context).isDarkMode
                  ? Colors.white
                  : Colors.grey,
              offset: Offset(0.0, 10.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: 'BalooThambi',
//              color: Provider.of<Data>(context).isDarkMode
//                  ? Colors.white
//                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
