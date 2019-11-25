import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './screens/trainer.dart';
import 'package:flutter/services.dart';
import 'data.dart';

void main() {
  data.sort((Map a, Map b) {
    var r = a["finger"].compareTo(b["finger"]);
    if (r != 0) return r;
    return a["saite"].compareTo(b["saite"]);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notentrainer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Notentrainer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _started = false;

  @override
  void initState() {
    super.initState();
  }

  void changeStarted() {
    setState(() {
      _started = !_started;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: SizedBox.expand(
            child: Column(
              children: <Widget>[
                if (_started)
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey[300], width: 2.0))),
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FlatButton.icon(
                        color: Colors.redAccent,
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Beenden",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => changeStarted(),
                      ),
                    ),
                  ),
                Expanded(
                  child: _started
                      ? Trainer()
                      : Container(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Colors.green,
                            onPressed: () => changeStarted(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Text(
                                "Start",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          )),
                ),
              ],
            ),
          ),
        ));
  }
}
