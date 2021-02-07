import 'package:flutter/material.dart';

int animationDuration = 200;

//Colors
final Color kBackgroundColor = Colors.blue;
const Color kPadColor = Colors.blue;
const Color kButtonColor = Colors.blue;

//Dark colors
final Color kInverseWhite = Color(0xff121212);

//Dimensions
const double kTitleContainerHeight = 60.0;
const double kLineThickness = 1.2;
const double kLineMargin = 10.0;
const double kDrawerTileHeight = 40.0;
const double kRoundedButtonMargin = 40.0;
const double kRoundedButtonHeight = 40.0;

//TextStyles
const TextStyle kPointsTextStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w700,
  color: Colors.black,
);

const TextStyle kPadTextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);

const TextStyle kPlayerNameTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: Colors.black,
);

const TextStyle kTitleTextStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.w900,
  color: Colors.white,
);

const TextStyle kSumPointsTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

final kTextFieldDecoration = InputDecoration(
  counterText: '',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blueAccent,
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blueAccent,
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
