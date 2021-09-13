import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Text result: Text will not make itself wider than the screen.
// TODO try text that wrapsss, and try min/max range.
class ChildSizePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Size'),
      ),
      body: Center(
        child: Container(
          //width: 200.0,
          //height: 200.0,
          color: Colors.limeAccent.withOpacity(0.4),
          child: InteractiveViewer(
            constrained: true,
            boundaryMargin: const EdgeInsets.all(20.0),
            scaleEnabled: false,
            child: Container(
              color: Colors.orangeAccent,
              child: const Text('To be or not to be that is the question whether tis nobler in the mind to suffer the slings and arrows of no nvm. antidisestablishmentarianismaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'),
            ),
            /*
            child: Container(
              color: Colors.purpleAccent,
              width: 3000.0,
              height: 3000.0,
            ),
            */
            /*
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 2000,
                maxWidth: 4000,
                minHeight: 2001,
                maxHeight: 4001,
              ),
              child: Container(color: Colors.orangeAccent),
            ),
            */
          ),
        ),
      ),
    );
  }
}


