import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GradientButton extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final double width;
  final double height;
  final bool selected;
  final Widget child;
  final VoidCallback onPressed;
  final double _stop;
  final double _radius;

  GradientButton({
    Key key,
    this.margin,
    this.width,
    this.height,
    this.selected = false,
    this.child,
    this.onPressed,
  })  : _stop = (height == null || height < 36) ? 0 : 0.02,
        _radius = (height == null || height < 36) ? 4 : 8,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: _radius * 2, vertical: 4),
      decoration: BoxDecoration(
        border: selected ? Border.all(color: Colors.white) : null,
        borderRadius: BorderRadius.circular(_radius),
        gradient: LinearGradient(
          colors: [Color(0xFF072329), Color(0xFF05FFD2), Color(0xFF01A288), Color(0xFF067164), Color(0xFF072329), Color(0xFF042026)],
          stops: [0, _stop, _stop * 2.5, _stop * 5, 1 - (_stop * 4), 1],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: InkWell(
        child: Center(child: child),
        onTap: onPressed,
      ),
    );
  }
}
