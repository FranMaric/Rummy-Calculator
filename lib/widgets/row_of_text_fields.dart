import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/database.dart';
import 'package:RummyCalculator/constants.dart';

class RowOfTextFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> _row = [];

    for (int i = 0; i < Provider.of<Data>(context).players.length; i++) {
      _row.add(Expanded(
        child: Container(
          height: kPointsTextStyle.fontSize * 1.7,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Provider.of<Data>(context).isDarkMode
                  ? Colors.white
                  : kBackgroundColor,
            ),
          ),
          child: TextField(
            onTap: () =>
                Provider.of<Data>(context, listen: false).selectedTextField = i,
            textAlign: TextAlign.center,
            controller:
                Provider.of<Data>(context, listen: false).controllers[i],
            showCursor: true,
            readOnly: true,
            autofocus: true,
            style: Provider.of<Data>(context).isDarkMode
                ? kPointsTextStyle.copyWith(
                    color: Colors.white,
                  )
                : kPointsTextStyle,
          ),
        ),
      ));
    }

    return Row(
      children: _row,
    );
  }
}
