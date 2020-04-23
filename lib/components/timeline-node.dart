import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';

class TimelineNode extends StatefulWidget {
  final double x;
  final double y;
  final double minWidth;
  final double maxWidth;
  final double offsetY;
  final VoidCallback onPressed;

  final TimelineData data;

  TimelineNode(
    this.data, {
    Key key,
    @required this.x,
    @required this.y,
    @required this.minWidth,
    @required this.maxWidth,
    @required this.offsetY,
    this.onPressed,
  })  : assert(data != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _TimelineNodeState();
}

class _TimelineNodeState extends State<TimelineNode> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    final Animation curve = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TimelineNode oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data.isExpanded != widget.data.isExpanded) {
      if (widget.data.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final xl = TextStyle(color: primaryColor, fontSize: 26, fontWeight: FontWeight.w400);

    return Positioned(
      key: ValueKey(widget.data.title),
      left: widget.x,
      top: widget.y - widget.offsetY - 4,
      child: GestureDetector(
        onTap: widget.onPressed ?? _onTap,
        child: Material(
          elevation: widget.data.isExpanded ? 2 : 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                colors: [darkColor, lightColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  width: widget.minWidth,
                  height: widget.offsetY,
                  child: Text(currency(widget.data.amount), style: xl),
                ),
                SizedBox(height: 4),
                Text(widget.data.title),
                _timeNodeChild(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeNodeChild() {
    final sb = TextStyle(fontSize: 15, fontWeight: FontWeight.w400);
    final s = TextStyle(fontSize: 15);

    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.vertical,
      child: SizeTransition(
        sizeFactor: _animation,
        axis: Axis.horizontal,
        child: Container(
          width: widget.maxWidth,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 8),
            Row(children: [
              Container(width: 80, child: Text('Style :', style: sb)),
              Expanded(child: Text(widget.data.style, style: s)),
            ]),
            SizedBox(height: 2),
            Row(children: [
              Container(width: 80, child: Text('Purpose :', style: sb)),
              Expanded(child: Text(widget.data.purpose, style: s)),
            ]),
            // widget.data.reverse ? SizedBox(height: 2) : Container(),
            // widget.data.reverse ? Text('reverse', style: s) : Container(),
          ]),
        ),
      ),
    );
  }

  void _onTap() {
    widget.data.isExpanded = !widget.data.isExpanded;
    if (widget.data.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }
}

class TimelineData {
  final String title;
  final double amount;
  final String style;
  final String purpose;
  final bool reverse;
  bool isExpanded;

  TimelineData({
    this.title,
    this.amount,
    this.style,
    this.purpose,
    this.reverse,
    this.isExpanded = false,
  });

  TimelineData withExpand(bool expand) {
    return TimelineData(
      title: title,
      amount: amount,
      style: style,
      purpose: purpose,
      reverse: reverse,
      isExpanded: expand,
    );
  }
}
