import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final double dashWidth;
  final double dashHeight;
  final double space;
  final Color color;

  const DashedLine({
    Key key,
    this.dashWidth = 6,
    this.dashHeight = 1,
    this.space = 2,
    this.color = Colors.green,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      final count = constraint.maxWidth / (dashWidth + space);
      return Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(count.floor(), (_) {
          return Container(width: dashWidth, height: dashHeight, color: color);
        }),
      );
    });
  }
}
