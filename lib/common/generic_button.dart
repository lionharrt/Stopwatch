import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  final Icon icon;
  final Alignment alignment;
  final EdgeInsets margin;
  final Function method;
  final double size;
  final double elevation;
  final Color color;
  final ShapeBorder shape;
  final Text text;

  const GenericButton(
      {this.icon,
      this.alignment,
      this.margin,
      this.method,
      this.size,
      this.elevation,
      this.color,
      this.shape,
      this.text,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (alignment == null) {
      return Container(
        margin: margin,
        child: RawMaterialButton(
          onPressed: () => method(),
          elevation: elevation,
          fillColor: color,
          child: icon,
          padding: EdgeInsets.all(size),
          shape: shape,
        ),
      );
    } else {
      return Align(
          alignment: alignment,
          child: Container(
            margin: margin,
            child: RawMaterialButton(
              onPressed: () => method(),
              elevation: elevation,
              fillColor: color,
              child: icon,
              padding: EdgeInsets.all(size),
              shape: shape,
            ),
          ));
    }
  }
}
