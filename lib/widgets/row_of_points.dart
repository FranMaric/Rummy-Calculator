import 'package:flutter/material.dart';
import 'package:RummyCalculator/constants.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/database.dart';

class RowOfPoints extends StatelessWidget {
  final List<String> rowOfPoints;

  RowOfPoints(this.rowOfPoints);

  @override
  Widget build(BuildContext context) {
    List<Widget> _row = [];
    for (String point in rowOfPoints) {
      _row.add(
        Expanded(
          child: Center(
            child: Text(
              point,
              style: Provider.of<Data>(context).isDarkMode
                  ? kPointsTextStyle.copyWith(
                      color: Colors.white,
                    )
                  : kPointsTextStyle,
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
