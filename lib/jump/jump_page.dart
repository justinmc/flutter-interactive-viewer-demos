import 'package:flutter/material.dart' hide Gradient;
import 'dart:developer';

class JumpPage extends StatefulWidget {
  JumpPage({Key key}) : super(key: key);

  @override
  _JumpPageState createState() => _JumpPageState();
}

class _JumpPageState extends State<JumpPage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {  // This call to setState tells the Flutter framework that something has changed in this State
      _counter++;
    });
  }

  Widget letter(double size, String txt) {
    return Stack(
        children: <Widget>[Image.asset('images/letter.png',
            width: size,
            height: size,
            fit:BoxFit.fitHeight),
          Positioned.fill(
            child: Center(
              child: Material(type:MaterialType.transparency,
                child: Text(txt,
                    style: new TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontSize: size / 1.5,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                              offset: Offset(0, 0),
                              blurRadius: 20.0,
                              color: Colors.black),
                        ]
                    )),
              ),
            ),
          )]
    );
  }

  Widget draggableLetter(double size, String txt) {
    return Draggable(
      child: letter(size, txt),
      feedback: letter(size*1.3, txt),
      childWhenDragging: Container(),
    );
  }

  Widget positionedLetter(double x, double y, size, String txt) {
    return
      Positioned(
          left: (x) * size,
          top:(y) * size,
          child: draggableLetter(size, txt)
      );
  }

  @override
  Widget build(BuildContext context) { // This method is rerun every time setState is called
    log( '%%%%%%%% BUILD State %%%%%%');

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the JumpPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Jump Page'),
      ),
      body: Center(

        child: LayoutBuilder( /* Useful to take decisions based on the parent's
          constraints (that you cannot access in general) */
          builder: (context, constraints) {
            double letterSize = constraints.maxWidth / 15;
            return
              Column(
                  children: [
                    SizedBox(
                        width: constraints.maxWidth, height: constraints.maxWidth,
                        child: ClipRect(
                            child: InteractiveViewer(
                              maxScale: 10,
                              disableRotation: true,
                              child: Stack(children:
                              [Image.asset('images/board1500.png', fit:BoxFit.cover),
                                positionedLetter(7,7, letterSize, 'A'),
                                positionedLetter(7,10, letterSize, 'B'),
                                positionedLetter(7,13, letterSize, 'C')]),
                            )
                        )
                    ),
                    Row(children: <Widget>[Text('Bottom bar')],)]
              );
          },
        ),
      ),
    );
  }
}

