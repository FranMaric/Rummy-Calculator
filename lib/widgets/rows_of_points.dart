import 'package:flutter/material.dart';
// import 'package:calculator/constants.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/database.dart';

//Screens
import 'package:RummyCalculator/screens/delete_pop_up.dart';

//Widgets
import 'package:RummyCalculator/widgets/row_of_lines.dart';
import 'package:RummyCalculator/widgets/row_of_text_fields.dart';
import 'package:RummyCalculator/widgets/row_of_points.dart';

class RowsOfPoints extends StatelessWidget {
  final Function onDoubleTap;

  RowsOfPoints({this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    int rowCount;

    return Consumer<Data>(builder: (context, data, child) {
      if (data.players.length != 0)
        rowCount =
            data.points.length + data.points.length ~/ data.players.length;
      //

      if (rowCount != 0 &&
          rowCount != null &&
          data.textfieldsVisible &&
          data.points.length % data.players.length == 0 &&
          data.inputPointsIndex == data.points.length)
        rowCount--;
      //
      else if (rowCount == 0 && data.textfieldsVisible) rowCount = 1;
      if (rowCount != null) {
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index != 0 && (index + 1) % (1 + data.players.length) == 0) {
              return RowOfLines();
            }
            //

            else if (data.textfieldsVisible &&
                index - (index + 1) ~/ (1 + data.players.length) ==
                    data.inputPointsIndex) {
              return RowOfTextFields();
            }
            //

            else {
              List<String> points = [];
              for (int i = 0; i < data.players.length; i++) {
                points.add(data
                    .points[index - (index + 1) ~/ (1 + data.players.length)][i]
                    .toString());
              }
              if (data.textfieldsVisible &&
                  data.inputPointsIndex == data.points.length &&
                  data.points.length - 1 ==
                      index - (index + 1) ~/ (1 + data.players.length)) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RowOfPoints(points),
                    RowOfTextFields(),
                  ],
                );
              } else
                return GestureDetector(
                  child: Container(
                      color: Color(0x00ffffff), child: RowOfPoints(points)),
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return DeletePopUp(
                          index: index -
                              (index + 1) ~/ (1 + data.players.length) +
                              1,
                          deleteFunction: () {
                            Provider.of<Data>(context, listen: false).deleteRow(
                                index -
                                    (index + 1) ~/ (1 + data.players.length));
                          },
                        );
                      },
                    );
                  },
                  onDoubleTap: () {
                    if (!data.textfieldsVisible)
                      Provider.of<Data>(context, listen: false).showNumberPad(
                          index:
                              index - (index + 1) ~/ (1 + data.players.length));
                  },
                );
            }
          },
          itemCount: rowCount,
        );
      } else {
        return Container();
      }
    });
  }

//  Widget rowBuilder() {
//    List<String> _rowOfPoints = [];
//    for (int i = 0; i < data.players.length; i++) {
//      _rowOfPoints.add(data.points[index][i].toString());
//    }
//
//    Widget rowOfPoints = GestureDetector(
//      onLongPress: () {
//        showModalBottomSheet(
//          context: context,
//          builder: (BuildContext context) {
//            return DeletePopUp(
//              index: index + 1,
//              deleteFunction: () {
//                Provider.of<Data>(context, listen: false).deleteRow(index);
//              },
//            );
//          },
//        );
//      },
//      onDoubleTap: () {
//        for (int i = 0;
//            i < Provider.of<Data>(context).controllers.length;
//            i++) {
//          Provider.of<Data>(context).controllers[i].text =
//              Provider.of<Data>(context).points[index][i].toString();
//        }
//        Provider.of<Data>(context).showNumberPad(index: index);
//      },
//      child: true
//          ? RowOfPoints(
//              rowOfPoints: _rowOfPoints,
//            )
//          : RowOfTextFields,
//    );
//    if ((index + 1) % data.players.length == 0) {
//      return Column(
//        children: <Widget>[
//          rowOfPoints,
//          RowOfLines(),
//        ],
//      );
//    }
//    return rowOfPoints;
//  }
}
