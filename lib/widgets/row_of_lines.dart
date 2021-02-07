import 'package:flutter/material.dart';
import 'package:RummyCalculator/constants.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/database.dart';

class RowOfLines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> _row = List<Widget>.generate(
      Provider.of<Data>(context).players.length,
      (int index) => Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: kLineMargin, vertical: 2.0),
          height: kLineThickness,
          color: Provider.of<Data>(context).isDarkMode
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
    return Row(
      children: _row,
    );
  }
}
