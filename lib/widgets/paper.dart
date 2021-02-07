import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/database.dart';
import 'package:RummyCalculator/constants.dart';

//Widgets
import 'package:RummyCalculator/widgets/number_pad.dart';
import 'package:RummyCalculator/widgets/rows_of_points.dart';
import 'package:RummyCalculator/widgets/row_of_lines.dart';
import 'package:RummyCalculator/widgets/row_of_names.dart';
import 'package:RummyCalculator/widgets/row_of_sum_points.dart';

class Paper extends StatelessWidget {
  const Paper({
    @required this.orientation,
  });

  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              children: <Widget>[
                RowOfSumPoints(),
                RowOfNames(),
                RowOfLines(),
                Expanded(
                  child: RowsOfPoints(),
                ),
                orientation == Orientation.portrait
                    ? Visibility(
                        visible: Provider.of<Data>(context).numberpadVisible,
                        child: NumberPad(),
                      )
                    : Container(
                        color: Color(0x00ffffff),
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
