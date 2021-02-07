import 'package:RummyCalculator/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:RummyCalculator/database.dart';

List<List<String>> pads = [
  ['1', '2', '3', 'X2', 'Esc'],
  ['4', '5', '6', '-', 'del'],
  ['7', '8', '9', '0', 'Add'],
];

class NumberPad extends StatelessWidget {
  final int index;

  NumberPad({this.index});

  @override
  Widget build(BuildContext context) {
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

    List<Widget> _rows = [];
    for (int y = 0; y < pads.length; y++) {
      List<Widget> _row = [];
      for (int x = 0; x < pads[0].length; x++) {
        String value = pads[y][x];
        if (value == 'del') {
          _row.add(Pad(
            color: Provider.of<Data>(context).isDarkMode ? Colors.black : null,
            child: Icon(
              Icons.backspace,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              Provider.of<Data>(context, listen: false)
                  .removeLastFromTextField();
            },
          ));
        } else if (value == 'Esc') {
          _row.add(
            Pad(
              color: Colors.red,
              child: Text(
                pads[y][x],
                style: kPadTextStyle,
              ),
              onTap: () {
                Provider.of<Data>(context, listen: false).clearAllTextFields();
              },
            ),
          );
        } else {
          _row.add(Pad(
              color: (value == 'X2' && Provider.of<Data>(context).doubled)
                  ? Colors.red
                  : Provider.of<Data>(context).isDarkMode ? Colors.black : null,
              child: Text(
                pads[y][x],
                style: kPadTextStyle,
              ),
              onTap: () {
                //Remove last character
                if (value == '-') {
                  Provider.of<Data>(context, listen: false)
                      .convertTextFieldToNegative();
                } else if (value == 'Add') {
                  try {
                    bool haveWinner = false;
                    for (TextEditingController cont
                        in Provider.of<Data>(context, listen: false)
                            .controllers) {
                      if ((int.tryParse(cont.text) ?? 0) <= -40) {
                        haveWinner = true;
                        break;
                      }
                    }
                    if (haveWinner) {
                      Provider.of<Data>(context, listen: false).newRow();
                    } else {
                      warningSheet(Provider.of<Data>(context, listen: false)
                          .translations['no_winner']);
                    }
                  } catch (e) {
                    print('Nope');
                  }
                } else if (value == 'X2') {
                  Provider.of<Data>(context, listen: false).doubleTextFields();
                }

                //Else just add that character to textField
                else {
                  Provider.of<Data>(context, listen: false)
                      .addToTextField(value);
                }
              }));
        }
      }
      _rows.add(
        Expanded(
          child: Row(children: _row),
        ),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.width * 3 / 4 * 0.8,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: _rows,
      ),
    );
  }
}

class Pad extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final Color color;

  Pad({this.child, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: color == null ? kPadColor : color,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(5, 5), color: Colors.black38, blurRadius: 5)
            ],
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
