import 'package:flutter/material.dart';

class MinuteButton extends StatelessWidget {
  final Function method;
  final int number;
  const MinuteButton({this.number, this.method, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 120),
      child: RawMaterialButton(
        onPressed: () => method(number),
        elevation: 2.0,
        fillColor: themeData.accentColor,
        child: Column(children: [
          Text('$number',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          Text('mins', style: TextStyle(fontWeight: FontWeight.w400))
        ]),
        padding: EdgeInsets.all(12),
        shape: CircleBorder(),
      ),
    );
  }
}
