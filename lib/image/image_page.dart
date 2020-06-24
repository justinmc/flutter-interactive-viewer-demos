// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

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
              child: InteractiveViewer(
                constrained: true,
                scaleEnabled: false,
                /*
                minScale: 1,
                maxScale: 1,
                */
                //panEnabled: false,
                transformationController: _transformationController,
                child: Center(
                  child: Image.asset(
                    photo.assetName,
                    fit: BoxFit.fill,
                    package: photo.assetPackage,
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
        title: const Text('Grid list'),
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
