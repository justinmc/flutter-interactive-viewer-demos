import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import '../helpers.dart';

class RotatePage extends StatefulWidget {
  const RotatePage({ Key key }) : super(key: key);

  static const String routeName = '/rotate';

  @override _RotatePageState createState() => _RotatePageState();
}

class _RotatePageState extends State<RotatePage> {
  final TransformationController _transformationController = TransformationController();

  static List<Container> _getGridChildren(int n) {
    final List<Container> children = <Container>[];
    for (int i = 0; i < n; i++) {
      children.add(Container(
        color: Colors.teal.withOpacity((n - i) / n),
      ));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
        actions: <Widget>[
        ],
      ),
      body: Center(
        child: Container(
          color: Colors.pink,
          width: 300,
          height: 300,
          child: ClipRect(
            child: GestureDetector(
              onTapUp: (TapUpDetails details) {
                final Offset sceneOffset =_transformationController.toScene(details.localPosition);
                print('justin tapped at viewport ${details.localPosition} and scene $sceneOffset');
              },
              child: InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: const EdgeInsets.all(0),
                minScale: 0.0001,
                maxScale: 10000,
                onInteractionUpdate: (ScaleUpdateDetails details) {
                  //print('justin onInteractionUpdate ${details.scale}');
                },
                child: Container(color: Colors.black, child: getFlex()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

