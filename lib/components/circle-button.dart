import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:areix/utils/constants.dart';

class CircleButton extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final double size;
  final bool dark;
  final VoidCallback onPressed;

  CircleButton({
    Key key,
    this.title = '',
    this.size = 72,
    this.dark = false,
    this.titleStyle,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colors =
        dark ? [Color(0xFF011D24), Color(0xFF823B19)] : [darkColor, lightColor];
    Color color = dark ? Color(0xFFF7601C) : primaryColor;
    TextStyle style =
        titleStyle ?? TextStyle(color: color, fontWeight: FontWeight.w500);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(size / 2),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: MaterialButton(
        shape: CircleBorder(),
        padding: EdgeInsets.zero,
        child: Text(title, textAlign: TextAlign.center, style: style),
        onPressed: onPressed,
      ),
    );
  }
}
