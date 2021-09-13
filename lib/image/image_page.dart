// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

enum GridDemoTileStyle {
  imageOnly,
  oneLine,
  twoLine
}

typedef BannerTapCallback = void Function(Photo photo);

const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class Photo {
  Photo({
    this.assetName,
    this.assetPackage,
    this.title,
    this.caption,
    this.isFavorite = false,
  });

  final String assetName;
  final String assetPackage;
  final String title;
  final String caption;

  bool isFavorite;
  String get tag => assetName; // Assuming that all asset names are unique.

  bool get isValid => assetName != null && title != null && caption != null && isFavorite != null;
}

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(text),
    );
  }
}

class GridDemoPhotoItem extends StatelessWidget {
  GridDemoPhotoItem({
    Key key,
    @required this.photo,
    @required this.tileStyle,
    @required this.onBannerTap,
  }) : assert(photo != null && photo.isValid),
       assert(tileStyle != null),
       assert(onBannerTap != null),
       super(key: key);

  final Photo photo;
  final GridDemoTileStyle tileStyle;
  final BannerTapCallback onBannerTap; // User taps on the photo's header or footer.
  final TransformationController _transformationController = TransformationController();

  void showPhoto(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        // Here's the relevant code for InteractiveViewer for a full screen image.
        return Scaffold(
          appBar: AppBar(
            title: Text(photo.title),
          ),
          /*
          body: Image.asset(
            photo.assetName,
            alignment: Alignment.center,
            fit: BoxFit.fill,
            package: photo.assetPackage,
          ),
          */
          body: Hero(
            tag: photo.tag,
            // TODO(justinmc): Try doing double tap to zoom.
            child: GestureDetector(
              onTapUp: (TapUpDetails details) {
                final Offset position = _transformationController.toScene(
                  details.localPosition,
                );
                print('justin tapup at $position');
              },
              child: IntrinsicSize(
                shrinkVerticalSize: true,
                shrinkHorizontalSize: true,
                child: InteractiveViewer(
                  constrained: true,
                  minScale: 0.000001,
                  maxScale: 1000,
                  //panEnabled: false,
                  //boundaryMargin: EdgeInsets.all(double.infinity),
                  transformationController: _transformationController,
                  child: Center(
                    child: Image.asset(
                      photo.assetName,
                      //fit: BoxFit.fill,
                      width: 200,
                      height: 200,
                      package: photo.assetPackage,
                    ),
                      /*
                    child: IntrinsicSize(
                      shrinkVerticalSize: true,
                      shrinkHorizontalSize: true,
                      child: Image.asset(
                        photo.assetName,
                        //fit: BoxFit.fill,
                        width: 200,
                        height: 200,
                        package: photo.assetPackage,
                      ),
                    ),
                    */
                  ),
                ),
              ),
            ),
          ),
        );
      }
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = GestureDetector(
      onTap: () { showPhoto(context); },
      child: Hero(
        key: Key(photo.assetName),
        tag: photo.tag,
        child: Image.asset(
          photo.assetName,
          package: photo.assetPackage,
          fit: BoxFit.cover,
        ),
      ),
    );

    final IconData icon = photo.isFavorite ? Icons.star : Icons.star_border;

    switch (tileStyle) {
      case GridDemoTileStyle.imageOnly:
        return image;

      case GridDemoTileStyle.oneLine:
        return GridTile(
          header: GestureDetector(
            onTap: () { onBannerTap(photo); },
            child: GridTileBar(
              title: _GridTitleText(photo.title),
              backgroundColor: Colors.black45,
              leading: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          child: image,
        );

      case GridDemoTileStyle.twoLine:
        return GridTile(
          footer: GestureDetector(
            onTap: () { onBannerTap(photo); },
            child: GridTileBar(
              backgroundColor: Colors.black45,
              title: _GridTitleText(photo.title),
              subtitle: _GridTitleText(photo.caption),
              trailing: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          child: image,
        );
    }
    assert(tileStyle != null);
    return null;
  }
}

class ImagePage extends StatefulWidget {
  const ImagePage({ Key key }) : super(key: key);

  static const String routeName = '/material/grid-list';

  @override
  ImagePageState createState() => ImagePageState();
}

class ImagePageState extends State<ImagePage> {
  GridDemoTileStyle _tileStyle = GridDemoTileStyle.twoLine;

  List<Photo> photos = <Photo>[
    Photo(
      assetName: 'images/india_chennai_flower_market.png',
      title: 'Chennai',
      caption: 'Flower Market',
    ),
    Photo(
      assetName: 'images/tall.jpg',
      title: 'Tall',
      caption: 'Image taller than the screen',
    ),
  ];

  void changeTileStyle(GridDemoTileStyle value) {
    setState(() {
      _tileStyle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos'),
        actions: <Widget>[
          PopupMenuButton<GridDemoTileStyle>(
            onSelected: changeTileStyle,
            itemBuilder: (BuildContext context) => <PopupMenuItem<GridDemoTileStyle>>[
              const PopupMenuItem<GridDemoTileStyle>(
                value: GridDemoTileStyle.imageOnly,
                child: Text('Image only'),
              ),
              const PopupMenuItem<GridDemoTileStyle>(
                value: GridDemoTileStyle.oneLine,
                child: Text('One line'),
              ),
              const PopupMenuItem<GridDemoTileStyle>(
                value: GridDemoTileStyle.twoLine,
                child: Text('Two line'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: GridView.count(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.all(4.0),
                childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
                children: photos.map<Widget>((Photo photo) {
                  return GridDemoPhotoItem(
                    photo: photo,
                    tileStyle: _tileStyle,
                    onBannerTap: (Photo photo) {
                      setState(() {
                        photo.isFavorite = !photo.isFavorite;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IntrinsicSize extends SingleChildRenderObjectWidget {
  IntrinsicSize({
    Key key,
    @required this.shrinkHorizontalSize,
    @required this.shrinkVerticalSize,
    Widget child,
  })  : assert(shrinkHorizontalSize != null),
        assert(shrinkVerticalSize != null),
        super(key: key, child: child);

  final bool shrinkHorizontalSize;
  final bool shrinkVerticalSize;

  @override
  RenderIntrinsicSize createRenderObject(BuildContext context) =>
      RenderIntrinsicSize(
        shrinkHorizontalSize: shrinkHorizontalSize,
        shrinkVerticalSize: shrinkVerticalSize,
      );
}

class RenderIntrinsicSize extends RenderProxyBox {
  /// Creates a render object that sizes itself to its child's intrinsic height.
  RenderIntrinsicSize({
    this.shrinkHorizontalSize,
    this.shrinkVerticalSize,
  });

  final bool shrinkHorizontalSize;
  final bool shrinkVerticalSize;

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child == null) return 0.0;
    if (shrinkHorizontalSize) return computeMaxIntrinsicWidth(height);
    return child.getMinIntrinsicWidth(height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child == null) return 0.0;
    return child.getMaxIntrinsicWidth(height).ceil().toDouble();
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child == null) return 0.0;
    if (shrinkVerticalSize) return computeMaxIntrinsicHeight(width);
    return child.getMinIntrinsicHeight(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child == null) return 0.0;
    return child.getMaxIntrinsicHeight(width).ceil().toDouble();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(
      debugCannotComputeDryLayout(
        reason: '$runtimeType does not implement computeDryLayout.',
      ),
    );
    return Size.zero;
  }

  @override
  void performLayout() {
    if (child != null && (shrinkVerticalSize || shrinkHorizontalSize)) {
      // Viewports cannot be requested for intrinsic sizes.
      final hasViewportChild = _hasViewportChild();

      final childConstraints = constraints;
      var width = childConstraints.maxWidth;
      if (shrinkHorizontalSize && !hasViewportChild) {
        width = child
            .getMaxIntrinsicWidth(childConstraints.maxHeight)
            .ceil()
            .toDouble();
        assert(width.isFinite);
        width = width.clamp(0, childConstraints.maxWidth).toDouble();
      }

      var height = childConstraints.maxHeight;
      if (shrinkVerticalSize && !hasViewportChild) {
        height = child.getMaxIntrinsicHeight(width).ceil().toDouble();
        assert(height.isFinite);
        height = height.clamp(0, childConstraints.maxHeight).toDouble();
      }

      child.layout(childConstraints);
      size = Size(width, height);
    } else {
      size = computeSizeForNoChild(constraints);
    }
  }

  bool _hasViewportChild() {
    var hasViewportChild = false;
    void recurseVisitChildren(RenderObject child) {
      if (child is RenderViewportBase) {
        hasViewportChild = true;
      } else {
        child.visitChildren(recurseVisitChildren);
      }
    }

    child.visitChildren(recurseVisitChildren);

    return hasViewportChild;
  }
}
