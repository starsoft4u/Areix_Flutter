import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';

class OutlineRoundButton extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry margin;
  final double width;
  final double height;
  final bool enabled;
  final bool fill;
  final Color color;
  final dynamic child;
  final VoidCallback onPressed;

  OutlineRoundButton({
    Key key,
    this.title = '',
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.enabled = true,
    this.fill = false,
    Color color,
    this.child,
    this.onPressed,
  })  : this.color = color ?? primaryColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _c = enabled ? color : color.withOpacity(0.5);
    final _tc = fill && enabled ? Colors.black : _c;
    final _fc = fill ? darken(color) : Colors.white24;

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: StadiumBorder(side: BorderSide(color: fill ? Colors.transparent : _c)),
        color: enabled && fill ? color : null,
        highlightColor: _fc,
        elevation: 0,
        disabledElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        splashColor: _fc,
        child: child == null
            ? Text(
                title,
                style: TextStyle(
                  color: _tc,
                  fontSize: 17,
                  fontWeight: fill && enabled ? FontWeight.w400 : FontWeight.w300,
                ),
              )
            : child,
        onPressed: enabled ? onPressed : null,
      ),
    );
  }
}
