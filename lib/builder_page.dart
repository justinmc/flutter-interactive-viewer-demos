import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';

class BuilderPage extends StatefulWidget {
  const BuilderPage({ Key key }) : super(key: key);

  static const String routeName = '/builder';

  @override _BuilderPageState createState() => _BuilderPageState();
}

class _BuilderPageState extends State<BuilderPage> {
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
      body: InteractiveViewer(
        transformationController: _transformationController,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        minScale: 1.0,
        maxScale: 1.0,
        onInteractionUpdate: (ScaleUpdateDetails details) {
          //print('justin onInteractionUpdate ${details.scale}');
        },
        child: _Table(
          rowCount: 4,
          columnCount: 6,
        ),
      ),
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
          column: const FixedColumnWidth(100.0),
      },
      // ignore: prefer_const_literals_to_create_immutables
      children: <TableRow>[
        for (int row = 0; row < rowCount; row++)
          // ignore: prefer_const_constructors
          TableRow(
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              for (int column = 0; column < columnCount; column++)
                Image.network('https://dummyimage.com/100x100/000/f00&text=${(row * columnCount) + column + 1}'),
            ],
          ),
      ],
    );
  }
}
