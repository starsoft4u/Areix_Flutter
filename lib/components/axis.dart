import 'package:flutter/material.dart';

class RptAxis {
  final bool enabled;
  final String title;
  final List<dynamic> labels;
  final double max;
  final Color color;
  final double width;
  final TextStyle titleTextStyle;
  final TextStyle labelTextStyle;

  RptAxis({
    this.enabled = true,
    this.title,
    List<dynamic> labels,
    @required this.max,
    this.color = Colors.white,
    this.width = 2,
    TextStyle titleTextStyle,
    TextStyle labelTextStyle,
  })  : labels = labels ?? [],
        titleTextStyle = titleTextStyle ?? TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        labelTextStyle = labelTextStyle ?? TextStyle(fontSize: 12, fontWeight: FontWeight.w400);

  List<Widget> get labelsWidget {
    return labels
        .map((item) => (item is Widget) ? item : Center(child: Text(item, style: labelTextStyle)))
        .toList();
  }
}
