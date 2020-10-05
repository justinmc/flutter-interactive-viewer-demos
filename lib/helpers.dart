import 'package:flutter/material.dart';

Column getFlex() {
  return Column(
    children: <Widget>[
      for (int i = 0; i < 4; i++)
        Row(
          children: <Widget>[
            for (int j = 0; j < 4; j++)
              Container(
                width: 75, height: 75,
                color: Colors.teal.withOpacity((16 - (i * 4 + j)) / 16),
              ),
          ],
        ),
    ],
  );
}
