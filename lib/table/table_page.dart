import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TablePage extends StatefulWidget {
  const TablePage({ Key key }) : super(key: key);

  static const String routeName = '/table';

  @override _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  final TransformationController _transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyTable'),
        actions: <Widget>[
          /*
          Draggable(
            feedback: Container(
              width: 50,
              height: 50,
              color: Colors.pink.withOpacity(0.2),
            ),
            child: Container(
              width: 50,
              height: 50,
              color: Colors.purple.withOpacity(0.5),
            ),
          ),
          */
        ],
      ),
      body: GestureDetector(
        onTapUp: (TapUpDetails details) {
          final Offset position = _transformationController.toScene(
            details.localPosition,
          );
          print('justin tapup at $position');
        },
        child: InteractiveViewer(
          constrained: false,
          transformationController: _transformationController,
          /*
          boundaryMargin: const EdgeInsets.fromLTRB(
            double.infinity,
            double.infinity,
            double.infinity,
            double.infinity,
          ),
          */
          scaleEnabled: false,
          child: _getTable(60, 6),
          /*
          child: Center(
            child: Container(
              width: 300,
              height: 75,
              color: Colors.grey.withOpacity(0.1),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type here',
                ),
                maxLength: 30,
              ),
            ),
          ),
          */
        ),
      ),
    );
  }

  static Widget _getTable(int rowCount, int columnCount) {
    return Table(
      // ignore: prefer_const_literals_to_create_immutables
      columnWidths: <int, TableColumnWidth>{
        for (int column = 0; column < columnCount; column++)
          column: const FixedColumnWidth(200.0),
      },
      // ignore: prefer_const_literals_to_create_immutables
      children: <TableRow>[
        for (int row = 0; row < rowCount; row++)
          // ignore: prefer_const_constructors
          TableRow(
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              for (int column = 0; column < columnCount; column++)
                DragTarget(
                  builder: (BuildContext context, List candidateData, List rejectedData) {
                    return Container(
                      height: 26,
                      color: candidateData.isEmpty ? row % 2 + column % 2 == 1 ? Colors.white : Colors.grey.withOpacity(0.1) : Colors.blue,
                      child: Text('$row x $column'),
                    );
                  },
                ),
            ],
          ),
      ],
    );
  }

  Widget get instructionDialog {
    return AlertDialog(
      title: const Text('Bidirectional Scrolling'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Text('Tap to edit hex tiles, and use gestures to move around the scene:\n'),
          Text('- Drag to pan.'),
          Text('- Pinch to zoom.'),
          Text('- Rotate with two fingers.'),
          Text('\nYou can always press the home button to return to the starting orientation!'),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
