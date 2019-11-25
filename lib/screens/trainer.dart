import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../data.dart';

class Trainer extends StatefulWidget {
  @override
  _Trainer createState() => _Trainer();
}

class _Trainer extends State<Trainer> {
  final List<Map> _vioData = data;
  Map _currentOption = _getRandomOption();
  List _btnBgColor = List.filled(data.length, Colors.grey[700]);
  bool _pressed = false;

  double _point = 0.1;

  static Map _getRandomOption() {
    var _random = new Random();
    return data[_random.nextInt(data.length)];
  }

  void setNewOption() {
    setState(() {
      _currentOption = _getRandomOption();
      _btnBgColor = List.filled(_vioData.length, Colors.grey[700]);
      _pressed = false;
    });
  }

  void setBtnBg(int i, bool isTrue) {
    setState(() {
      _btnBgColor[i] = isTrue ? Colors.green : Colors.red;
    });
  }

  bool checkChoice(int i) {
    final Map selectedOption = _vioData[i];
    if (selectedOption["image"] == _currentOption["image"]) {
      return true;
    }
    return false;
  }

  void checkChoiceAndSetBg(int i) {
    setState(() {
      _pressed = true;
    });
    setBtnBg(i, checkChoice(i));
    if (!checkChoice(i)) {
      for (var j = 0; j < _vioData.length; j++) {
        if (checkChoice(j)) {
          setBtnBg(j, true);
        }
      }
    }
  }

  double findPoint(
      double elementHeight, double height, int buttonWidth, int saite) {
    double shift = height / 2 * _point;
    double btnWidth = buttonWidth / 2;
    double withSeg = elementHeight / 2 / 4;

    if (saite > 1) {
      return shift - btnWidth + withSeg * saite + withSeg / 2;
    }
    return shift - btnWidth + withSeg * saite;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Card(
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 8),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    child: Image.asset(
                      'assets/images/' + _currentOption["image"],
                      alignment: Alignment.center,
                    ),
                  ),
                  Text(
                    _currentOption["note"] +
                        _currentOption["octave"].toString(),
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(child: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double _height = constraints.maxHeight;
              return SizedBox(
                height: _height,
                width: _height / 2,
                child: Stack(overflow: Overflow.visible, children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: VioPainter(0.1, 3),
                    ),
                  ),
                  for (var i = 0; i < data.length; i++)
                    Positioned(
                        height: 30,
                        width: 30,
                        top: (_height / 5) * (i / 4).floor(),
                        left: (i % 4) < 2
                            ? findPoint(
                                _height,
                                _height - ((_height / 5) * (i / 4).floor()),
                                30,
                                (i % 4))
                            : findPoint(_height,
                                ((_height / 5) * (i / 4).floor()), 30, (i % 4)),
                        child: RaisedButton(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.all(0),
                          color: _btnBgColor[i],
                          highlightColor: Colors.grey[900],
                          onPressed: () => checkChoiceAndSetBg(i),
                          child: Icon(
                            Icons.brightness_1,
                            size: 10,
                            color: Colors.white,
                          ),
                        )),
                  if (_pressed)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 150,
                        child: RaisedButton(
                          elevation: 30,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          onPressed: () => setNewOption(),
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  "Weiter",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                ]),
              );
            },
          )),
        ],
      ),
    );
  }
}

class VioPainter extends CustomPainter {
  final double _point;
  final double _strokeWidth;

  VioPainter(this._point, this._strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    double _widthSeg = size.width / 4;
    double _pointHeight = _point * (size.height / 2);

    canvas.drawLine(
        Offset(0, 30),
        Offset(size.width - 5, 30),
        Paint()
          ..color = Colors.black
          ..strokeWidth = this._strokeWidth);

    for (int i = 0; i < 4; i++)
      canvas.drawLine(
          Offset(
              i < 2
                  ? (_pointHeight + i * _widthSeg)
                  : (_widthSeg * i) + _widthSeg / 2,
              0),
          Offset(
              i < 2
                  ? (_widthSeg * i)
                  : (_pointHeight + i * _widthSeg) + _widthSeg / 2,
              size.height),
          Paint()
            ..color = Colors.black
            ..strokeWidth = this._strokeWidth);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
