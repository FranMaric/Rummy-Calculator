import 'package:flutter/material.dart';
import 'package:RummyCalculator/constants.dart';
import 'package:RummyCalculator/database.dart';
import 'package:provider/provider.dart';

class RowOfNames extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> _row = [];
    List<String> _players = Provider.of<Data>(context).players;
    List<int> winners = Provider.of<Data>(context).currentWinners;
    for (int i = 0; i < _players.length; i++) {
      _row.add(Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: Center(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                winners.contains(i) ? '🏆${_players[i]}' : _players[i],
                style: Provider.of<Data>(context).isDarkMode
                    ? kPlayerNameTextStyle.copyWith(color: Colors.white)
                    : kPlayerNameTextStyle,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ));
    }
    return Row(
      children: _row,
    );
  }
}
