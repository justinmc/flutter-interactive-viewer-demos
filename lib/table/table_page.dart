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
        ],
      ),
      body: Center(
        child: Container(
          width: 200.0,
          height: 200.0,
          child: GestureDetector(
            onTapUp: (TapUpDetails details) {
              final Offset position = _transformationController.toScene(
                details.localPosition,
              );
              print('tapup at $position');
            },
            child: InteractiveViewer(
              alignPanAxis: true,
              constrained: false,
              transformationController: _transformationController,
              scaleEnabled: false,
              child: _Table(rowCount: 60, columnCount: 6),
            ),
          ),
        ),
      ),
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

class _Table extends StatelessWidget {
  const _Table({
    this.rowCount,
    this.columnCount,
  }) : assert(rowCount != null && rowCount > 0),
       assert(columnCount != null && columnCount > 0);

  final int rowCount;
  final int columnCount;

  @override
  Widget build(BuildContext context) {
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
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('$row x $column'),
                      ),
                    );
                  },
                ),
            ],
          ),
      ],
    );
  }
}
