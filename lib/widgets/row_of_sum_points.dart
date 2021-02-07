import 'package:flutter/material.dart';
import 'package:RummyCalculator/constants.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/database.dart';

class RowOfSumPoints extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!Provider.of<Data>(context).showSum) {
      return Container();
    }
    List<Widget> _row = [];
    List<int> _sumPoints = Provider.of<Data>(context).sumPoints;
    for (int i = 0; i < Provider.of<Data>(context).players.length; i++) {
      _row.add(
        Expanded(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              decoration: BoxDecoration(
                color: Provider.of<Data>(context).isDarkMode
                    ? Colors.black
                    : kPadColor,
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
              child: Text(
                _sumPoints[i].toString(),
                style: kSumPointsTextStyle,
              ),
            ),
          ),
        ),
      );
    }
    return Row(
      children: _row,
    );
  }
}
