import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// A little IV in the middle of the page.
class MiddlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            color: Colors.limeAccent.withOpacity(0.4),
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(10.0),
              minScale: 0.8,
              child: Container(width: 200.0, height: 200.0, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}

