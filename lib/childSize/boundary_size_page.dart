import 'package:flutter/material.dart';

class BoundarySizePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boundary Size Example'),
        actions: <Widget>[
        ],
      ),
      body: Center(
        child: Container(
          width: 100.0,
          height: 200.0,
          color: Colors.limeAccent.withOpacity(0.4),
          child: InteractiveViewer(
            //boundaryMargin: EdgeInsets.all(20),//double.infinity),
            minScale: 5,
            maxScale: 5,
            constrained: false,
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                color: Colors.orangeAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
