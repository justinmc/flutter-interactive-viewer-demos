import 'package:flutter/material.dart';
import '../helpers.dart';

class DoubleTapPage extends StatelessWidget {
  TransformationController controller = TransformationController();

  @override
  Widget build(BuildContext context) {
    controller.value = null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Double Tap Demo'),
        actions: [],
      ),
      body: Center(
          child: InteractiveViewer(
            child: Container(width: 200, height: 200, color: Colors.redAccent),
          ),
      ),
    );
  }
}
