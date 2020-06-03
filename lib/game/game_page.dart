// Copyright 2014 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show Vertices;
import 'package:flutter/material.dart';
import 'transformations_demo_board.dart';
import 'transformations_demo_edit_board_point.dart';

// BEGIN transformationsDemo#1

class GamePage extends StatefulWidget {
  const GamePage({Key key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  // The radius of a hexagon tile in pixels.
  static const _kHexagonRadius = 32.0;
  // The margin between hexagons.
  static const _kHexagonMargin = 1.0;
  // The radius of the entire board in hexagons, not including the center.
  static const _kBoardRadius = 12;

  Board _board = Board(
    boardRadius: _kBoardRadius,
    hexagonRadius: _kHexagonRadius,
    hexagonMargin: _kHexagonMargin,
  );

  bool _firstRender = true;
  Matrix4 _homeTransformation;
  final TransformationController _transformationController = TransformationController();
  Animation<Matrix4> _animationReset;
  AnimationController _controllerReset;

  // Handle reset to home transform animation.
  void _onAnimateReset() {
    _transformationController.value = _animationReset.value;
    if (!_controllerReset.isAnimating) {
      _animationReset?.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  // Initialize the reset to home transform animation.
  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: _homeTransformation,
    ).animate(_controllerReset);
    _controllerReset.duration = const Duration(milliseconds: 400);
    _animationReset.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

  // Stop a running reset to home transform animation.
  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onScaleStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  void _onTapUp(TapUpDetails details) {
    final Offset scenePoint = _transformationController.toScene(details.localPosition);
    final BoardPoint boardPoint = _board.pointToBoardPoint(scenePoint);
    setState(() {
      _board = _board.copyWithSelected(boardPoint);
    });
  }

  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(GamePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // The scene is drawn by a CustomPaint, but user interaction is handled by
    // the InteractiveViewer parent widget.
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('Game Board demo'),
        actions: <Widget>[resetButton],
      ),
      body: Container(
        color: backgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Draw the scene as big as is available, but allow the user to
            // translate beyond that to a visibleSize that's a bit bigger.
            final Size viewportSize = Size(
              constraints.maxWidth,
              constraints.maxHeight,
            );

            // The board is drawn centered at the origin, which is the top left
            // corner in InteractiveViewer, so shift it to the center of the
            // viewport initially.
            if (_firstRender) {
              _firstRender = false;
              _homeTransformation = Matrix4.identity()..translate(
                viewportSize.width / 2,
                viewportSize.height / 2,
              );
              //_homeTransformation = Matrix4.identity();
              _transformationController.value = _homeTransformation;
            }

            // TODO(justinmc): There is a bug where the scale gesture doesn't
            // begin immediately, and it's caused by wrapping IV in a
            // GestureDetector. Removing the onTapUp fixes it.
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: _onTapUp,
              child: InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: EdgeInsets.fromLTRB(
                  _board.size.width / 2,
                  _board.size.height / 2,
                  _board.size.width / 4 - 70.0,
                  -180.0,
                ),
                minScale: 0.1,
                onInteractionStart: _onScaleStart,
                child: CustomPaint(
                  size: _board.size,
                  painter: _BoardPainter(
                    board: _board,
                  ),
                  // This child gives the CustomPaint an intrinsic size.
                  child: SizedBox(
                    width: _board.size.width,
                    height: _board.size.height,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      //persistentFooterButtons: [resetButton, editButton],
    );
  }

  IconButton get resetButton {
    return IconButton(
      onPressed: () {
        setState(() {
          _animateResetInitialize();
        });
      },
      tooltip: 'Reset',
      color: Theme.of(context).colorScheme.surface,
      icon: const Icon(Icons.replay),
    );
  }

  IconButton get editButton {
    return IconButton(
      onPressed: () {
        if (_board.selected == null) {
          return;
        }
        showModalBottomSheet<Widget>(
            context: context,
            builder: (context) {
              return Container(
                width: double.infinity,
                height: 150,
                padding: const EdgeInsets.all(12),
                child: EditBoardPoint(
                  boardPoint: _board.selected,
                  onColorSelection: (color) {
                    setState(() {
                      _board = _board.copyWithBoardPointColor(
                          _board.selected, color);
                      Navigator.pop(context);
                    });
                  },
                ),
              );
            });
      },
      tooltip: 'Edit',
      color: Theme.of(context).colorScheme.surface,
      icon: const Icon(Icons.edit),
    );
  }

  @override
  void dispose() {
    _controllerReset.dispose();
    super.dispose();
  }
}

// CustomPainter is what is passed to CustomPaint and actually draws the scene
// when its `paint` method is called.
class _BoardPainter extends CustomPainter {
  const _BoardPainter({
    this.board,
  });

  final Board board;

  @override
  void paint(Canvas canvas, Size size) {
    void drawBoardPoint(BoardPoint boardPoint) {
      final Color color = boardPoint.color.withOpacity(
        board.selected == boardPoint ? 0.7 : 1,
      );
      final Vertices vertices =
          board.getVerticesForBoardPoint(boardPoint, color);
      canvas.drawVertices(vertices, BlendMode.color, Paint());
    }

    board.forEach(drawBoardPoint);
  }

  // We should repaint whenever the board changes, such as board.selected.
  @override
  bool shouldRepaint(_BoardPainter oldDelegate) {
    return oldDelegate.board != board;
  }
}

// END
