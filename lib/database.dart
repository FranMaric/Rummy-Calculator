import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:async';
import 'package:wakelock/wakelock.dart';

import 'package:flutter/services.dart' show rootBundle;

class Data extends ChangeNotifier {
  // ---------------------- Variables ----------------------

  List<String> supportedLang = ['hr', 'en', 'de'];

  Map<String, String> langCodeConvert = {
    'hr': 'hrvatski',
    'en': 'english',
    'de': 'Deutsche'
  };
  Map<String, String> convertToLangCode = {
    'hrvatski': 'hr',
    'english': 'en',
    'Deutsche': 'de'
  };
  String currentLang;

  String supportedNameChars =
      'yxcvbnmasdfghjklčćqwertzuiopšđžYXCVBNMASDFGHJKLČĆQWERTZUIOPŠĐŽ';

  List<String> _players = [];
  List<List<int>> _points = [];
  List<int> sumPoints = [];

  bool addButtonVisible = true;
  bool numberpadVisible = false;
  bool textfieldsVisible = false;

  bool _isDarkMode;
  bool _showSum = true;

  bool _isAlwaysOn;

  int _inputPointsIndex;

  bool _doubled = false;

  int selectedTextField = 0;

  List<List<List<int>>> _deletedPoints = [];
  List<TextEditingController> controllers = [];

  Map<String, dynamic> translations;

  // ---------------------- Initializer ----------------------

  Data() {
    _inputPointsIndex = _points.length;

    _readAlwaysOn().then((bool value) {
      if (value != null) {
        _isAlwaysOn = value;
        if (value)
          Wakelock.enable();
        else
          Wakelock.disable();
      } else {
        _isAlwaysOn = true;
        Wakelock.enable();
      }
    });

    _readDarkMode().then((bool darkModeValue) {
      if (darkModeValue != null) {
        _isDarkMode = darkModeValue;
      } else {
        _isDarkMode = false;
      }
    });

    _readShowSum().then((bool value) {
      if (value != null) {
        _showSum = value;
      } else {
        _showSum = true;
      }
    });

    _readPlayers().then((List<String> value) {
      if (value != null) {
        _players = value;
        controllers = List<TextEditingController>.generate(
            _players.length, (int index) => TextEditingController());
        notifyListeners();
      }
    });

    _readPoints().then((List<List<int>> value) {
      if (value != null && value.isNotEmpty) {
        _points = value;
        sumPoints = [];
        for (int player = 0; player < _points[0].length; player++) {
          int sum = 0;
          for (int row = 0; row < _points.length; row++) {
            sum += _points[row][player];
          }
          sumPoints.add(sum);
        }
        notifyListeners();
      } else {
        sumPoints = List<int>.generate(_players.length, (int _index) => 0);
      }
    });

    _readDeletedPoints().then((List<List<List<int>>> value) {
      if (value != null) {
        _deletedPoints = value;
        notifyListeners();
      }
    });

    startupLang();
  }

  // ---------------------- Getters ----------------------
  List<String> get players => _players;

  List<List<int>> get points => _points;

  bool get doubled => _doubled;

  int get inputPointsIndex => _inputPointsIndex;

  bool get isDarkMode => _isDarkMode;

  bool get showSum => _showSum;

  bool get isAlwaysOn => _isAlwaysOn;

  List<int> get currentWinners {
    double lowest = double.infinity;
    List<int> lowestIndex;

    if (_points.length == 0) {
      return [];
    } else if (sumPoints.toSet().toList().length == 1) {
      return [];
    }
    for (int i = 0; i < _players.length; i++) {
      if (sumPoints[i] < lowest) {
        lowest = sumPoints[i].toDouble();
        lowestIndex = [i];
      } else if (sumPoints[i] == lowest) {
        lowestIndex.add(i);
      }
    }
    return lowestIndex;
  }

  // ---------------------- DarkMode management ----------------------

  void setAlwaysOn(bool newValue) {
    _isAlwaysOn = newValue;
    _writeAlwaysOn();
    notifyListeners();
  }

  void setDarkMode(bool newValue) {
    _isDarkMode = newValue;
    _writeDarkMode();
    notifyListeners();
  }

  void setShowSum(bool newValue) {
    _showSum = newValue;
    _writeShowSum();
    notifyListeners();
  }

  // ---------------------- TextField management ----------------------

  void clearAllTextFields() {
    for (int i = 0; i < _players.length; i++) {
      controllers[i].text = '';
    }
    _doubled = false;
    numberpadVisible = false;
    addButtonVisible = true;
    textfieldsVisible = false;
    notifyListeners();
  }

  void doubleTextFields() {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text == '') {
        return;
      }
    }
    if (_doubled) {
      for (int i = 0; i < _players.length; i++) {
        if (controllers[i].text == '-40' || controllers[i].text == '-140') {
          controllers[i].text = '-40';
        } else if (controllers[i].text != '') {
          controllers[i].text =
              (int.parse(controllers[i].text) ~/ 2).toString();
        }
      }
      _doubled = false;
    } else if (!_doubled) {
      for (int i = 0; i < _players.length; i++) {
        if (controllers[i].text == '-40' || controllers[i].text == '-140') {
          controllers[i].text = '-140';
        } else if (controllers[i].text != '') {
          controllers[i].text = (int.parse(controllers[i].text) * 2).toString();
        }
      }
      _doubled = true;
    }
    notifyListeners();
  }

  void removeLastFromTextField() {
    controllers[selectedTextField].text = controllers[selectedTextField]
        .text
        .substring(0, controllers[selectedTextField].text.length - 1);
    if (controllers[selectedTextField].text == '-') {
      controllers[selectedTextField].text = '';
    }
  }

  void addToTextField(String _addValue) {
    if (controllers[selectedTextField].text.length < 4) {
      controllers[selectedTextField].text += _addValue;
    }
    try {
      if (int.parse(controllers[selectedTextField].text) < -140) {
        controllers[selectedTextField].text = '-140';
      }
    } catch (e) {}
  }

  void convertTextFieldToNegative() {
    if (controllers[selectedTextField].text == '-') {
      controllers[selectedTextField].text = '';
    } else if (controllers[selectedTextField].text != '') {
      controllers[selectedTextField].text =
          (-int.parse(controllers[selectedTextField].text)).toString();
    } else {
      controllers[selectedTextField].text = '-';
    }
  }

  // ---------------------- Game management ----------------------

  void newGame(List<String> newPlayersList) {
    _players = newPlayersList;
    _points = [];
    _deletedPoints = [];
    _doubled = false;

    for (int i = 0; i < _players.length; i++) {
      for (String char in _players[i].split('')) {
        if (!supportedNameChars.contains(char)) {
          _players[i] = _players[i].replaceAll(char, '');
        }
      }
    }

    controllers = List<TextEditingController>.generate(
        _players.length, (int index) => TextEditingController());

    sumPoints = List<int>.generate(_players.length, (int index) => 0);

    numberpadVisible = false;
    addButtonVisible = true;
    textfieldsVisible = false;

    _writePlayers();
    _writePoints();
    _writeDeletedPoints();
    notifyListeners();
  }

  void newRow() {
    List<int> _newRow = [];

    if (_inputPointsIndex != points.length) {
      for (int i = 0; i < players.length; i++) {
        try {
          _newRow.add(int.parse(controllers[i].text));
          sumPoints[i] -= _points[_inputPointsIndex][i] - _newRow.last;
        } catch (e) {
          return;
//          _newRow.add(0);
        }
        controllers[i].text = '';
      }
      _points[_inputPointsIndex] = _newRow;
    }
    //
    else {
      for (int i = 0; i < players.length; i++) {
        try {
          _newRow.add(int.parse(controllers[i].text));
          sumPoints[i] += _newRow.last;
        } catch (e) {
          _newRow.add(0);
        }
        controllers[i].text = '';
      }

      _points.add(_newRow);
    }

    selectedTextField = 0;
    numberpadVisible = false;
    textfieldsVisible = false;
    addButtonVisible = true;
    _writePoints();
    notifyListeners();
  }

  void deleteRow(int deleteIndex) {
    List<List<int>> _newList = [];

    for (int i = 0; i < _points.length; i++) {
      _newList.add(List.from(_points[i]));
    }

    _deletedPoints.add(_newList);

    for (int i = 0; i < _players.length; i++) {
      sumPoints[i] -= _points[deleteIndex][i];
    }

    _points.removeAt(deleteIndex);

    _writePoints();
    _writeDeletedPoints();
    notifyListeners();
  }

  void undoDeletedRow() {
    if (_deletedPoints.length != 0) {
      _points = _deletedPoints.last;
      _deletedPoints.removeLast();

      sumPoints = [];
      for (int player = 0; player < _players.length; player++) {
        int sum = 0;
        for (int row = 0; row < _points.length; row++) {
          sum += _points[row][player];
        }
        sumPoints.add(sum);
      }

      _writePoints();
      _writeDeletedPoints();
      notifyListeners();
    }
  }

  void clearAllPoints() {
    List<List<int>> _newList = [];

    for (int i = 0; i < _points.length; i++) {
      _newList.add(List.from(_points[i]));
    }

    _deletedPoints.add(_newList);

    _points = [];
    sumPoints = List<int>.generate(_players.length, (int index) => 0);
    _writePoints();
    _writeDeletedPoints();

    notifyListeners();
  }

  void showNumberPad({int index = -1}) {
    if (index != -1) {
      _inputPointsIndex = index;
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text = _points[index][i].toString();
      }
    } else {
      _inputPointsIndex = _points.length;
    }
    if (numberpadVisible) {
      numberpadVisible = false;
      addButtonVisible = true;
      textfieldsVisible = false;
    } else {
      numberpadVisible = true;
      addButtonVisible = false;
      textfieldsVisible = true;
    }

    _doubled = false;
    selectedTextField = 0;
    notifyListeners();
  }

  // ---------------------- Language management ----------------------

  void startupLang() async {
    String sysLng = ui.window.locale.languageCode;

    await getApplicationDocumentsDirectory().then((Directory dir) {
      try {
        File file = File("${dir.path}/lang.txt");
        String content = file.readAsStringSync();
        rootBundle.loadString("locale/$content.json").then((String value) {
          translations = json.decode(value);
        });
        currentLang = content;
      } catch (e) {
        try {
          rootBundle.loadString("locale/$sysLng.json").then((String value) {
            translations = json.decode(value);
          });
          currentLang = sysLng;
        } catch (e) {
          rootBundle.loadString("locale/en.json").then((String value) {
            translations = json.decode(value);
          });
          currentLang = 'en';
        }
      }

      notifyListeners();
    });
  }

  Future<Null> changeLang(String newLang) async {
    newLang = convertToLangCode[newLang];
    String value = await rootBundle.loadString("locale/$newLang.json");
    translations = json.decode(value);

    await (await _localFile('lang')).writeAsString(newLang);
    currentLang = newLang;
    notifyListeners();
  }

  // ---------------------- File management ----------------------

  Future<File> _localFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/$fileName.txt');
  }

  Future<bool> _readAlwaysOn() async {
    try {
      File file = await _localFile('alwaysOn');
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      if (contents.contains('true')) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> _readShowSum() async {
    try {
      File file = await _localFile('showSum');
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      if (contents.contains('true')) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> _readDarkMode() async {
    try {
      File file = await _localFile('darkMode');
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      if (contents.contains('true')) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> _readPlayers() async {
    try {
      File file = await _localFile('players');
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      List<String> out = contents.split(',');

      for (int i = 0; i < out.length; i++) {
        out[i] = out[i]
            .replaceAll("'", "")
            .replaceAll("[", "")
            .replaceAll("]", "")
            .replaceAll(" ", "");
      }

      return out;
    } catch (e) {
      return null;
    }
  }

  Future<List<List<int>>> _readPoints() async {
    try {
      File file = await _localFile('points');
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      List<List<int>> out = [];

      List<String> firstSplit = contents.split(', [');

      for (int i = 0; i < firstSplit.length; i++) {
        out.add(firstSplit[i]
            .replaceAll("'", "")
            .replaceAll("[", "")
            .replaceAll("]", "")
            .replaceAll(" ", "")
            .split(',')
            .map(int.parse)
            .toList());
      }

      return out;
    } catch (e) {
      return null;
    }
  }

  Future<List<List<List<int>>>> _readDeletedPoints() async {
    try {
      File file = await _localFile('deletedPoints');
      String contents = await file.readAsString();
      List<List<List<int>>> out = [];

      List<String> firstSplit = contents.split(']], [[');

      for (int i = 0; i < firstSplit.length; i++) {
        List<List<int>> onePoints = [];
        for (String oneRowOfPoints in firstSplit[i].split(', [')) {
          onePoints.add(oneRowOfPoints
              .replaceAll("[", "")
              .replaceAll("]", "")
              .replaceAll(" ", "")
              .split(',')
              .map(int.parse)
              .toList());
        }
        out.add(onePoints);
      }

      return out;
    } catch (e) {
      return null;
    }
  }

  Future<Null> _writeAlwaysOn() async {
    await (await _localFile('alwaysOn')).writeAsString(_isAlwaysOn.toString());
  }

  Future<Null> _writeShowSum() async {
    await (await _localFile('showSum')).writeAsString(_showSum.toString());
  }

  Future<Null> _writeDarkMode() async {
    await (await _localFile('darkMode')).writeAsString(_isDarkMode.toString());
  }

  Future<Null> _writeDeletedPoints() async {
    // write the variable as a string to the file
    await (await _localFile('deletedPoints')).writeAsString('$_deletedPoints');
  }

  Future<Null> _writePoints() async {
    // write the variable as a string to the file
    await (await _localFile('points')).writeAsString('$_points');
  }

  Future<Null> _writePlayers() async {
    // write the variable as a string to the file
    await (await _localFile('players')).writeAsString('$_players');
  }
}
