import 'package:areix/components/simple-bar-chart.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GradientCell extends StatefulWidget {
  final double width;
  final EdgeInsetsGeometry margin;

  final bool isDark;
  final bool hasOffset;

  final String title;
  final double amount;
  final double offset;
  final List<ChartData> data;
  final VoidCallback onPressed;

  GradientCell({
    Key key,
    this.margin = const EdgeInsets.all(0),
    this.width = double.infinity,
    this.title,
    this.offset,
    this.amount,
    this.isDark = false,
    this.hasOffset = false,
    List<ChartData> data,
    this.onPressed,
  })  : this.data = data ?? [],
        super(key: key);

  @override
  State<StatefulWidget> createState() => _GradientCellState();
}

class _GradientCellState extends State<GradientCell> with SingleTickerProviderStateMixin {
  bool _showGraph = false;
  double _graphHeight = 8;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    if (widget.onPressed == null) {
      _controller = AnimationController(duration: Duration(milliseconds: 400), vsync: this);
      final Animation curve =
          CurvedAnimation(parent: _controller, curve: Curves.decelerate, reverseCurve: Curves.easeIn);
      _animation = Tween<double>(begin: 8, end: 180).animate(curve);
      _animation.addListener(() {
        setState(() {
          _graphHeight = _animation.value;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? 'bg_cell_dark.png' : 'bg_cell.png';
    final bgL = widget.isDark ? 'bg_cell_x_dark.png' : 'bg_cell_x.png';

    return GestureDetector(
      child: Container(
        margin: widget.margin,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        width: widget.width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/${_graphHeight > 32 ? bgL : bg}'), fit: BoxFit.fill),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _top(),
            _content(),
            widget.data.isEmpty
                ? Container()
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // constraints: BoxConstraints.expand(width: widget.data.length * 80.0),
                      width: widget.data.length * 80.0,
                      child: SimpleBarChart(widget.data, height: _graphHeight),
                    ),
                  ),
          ],
        ),
      ),
      onTap: widget.onPressed ?? _onTap,
    );
  }

  void _onTap() {
    _showGraph = !_showGraph;

    if (_showGraph) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Widget _top() {
    if (!widget.hasOffset) {
      return Text(
        widget.title,
        overflow: TextOverflow.fade,
        style: const TextStyle(fontSize: 15),
      );
    }

    final offsetIcon = widget.offset >= 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down;
    final offsetColor = widget.offset >= 0 ? primaryColor : accentColor;

    return Row(children: [
      Expanded(
        child: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15),
        ),
      ),
      SizedBox(width: 4),
      Icon(offsetIcon, size: 24, color: offsetColor),
      Text(
        '${widget.offset} %',
        style: TextStyle(color: offsetColor, fontSize: 11),
      ),
    ]);
  }

  Widget _content() {
    final large = TextStyle(
      color: widget.isDark ? accentColor : primaryColor,
      fontSize: 26,
      fontWeight: FontWeight.w500,
    );
    final small = large.merge(TextStyle(fontSize: 17));
    final fixed = currency(widget.amount, fixed: 2);
    final doubleVal = fixed.substring(fixed.length - 2);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: currency(widget.amount, fixed: 0),
            style: large,
            children: [TextSpan(text: '.$doubleVal', style: small)],
          ),
        ),
      ),
    );
  }
}
