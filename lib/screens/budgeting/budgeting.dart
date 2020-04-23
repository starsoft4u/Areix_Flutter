import 'package:areix/components/timeline-node.dart';
import 'package:areix/models/category.dart';
import 'package:areix/models/target.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/components/outline-round-button.dart';
import 'package:areix/components/gradient-button.dart';
import 'package:areix/components/circle-button.dart';
import 'package:areix/utils/constants.dart';

class BudgetingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BudgetingPageState();
}

class _BudgetingPageState extends State<BudgetingPage> with SingleTickerProviderStateMixin {
  final double _timelineX = 24;
  final double _nodeMinWidth = 80;
  final double _nodeOffsetY = 32;

  ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });

    _data = _data.where((x) => x.date.difference(DateTime.now()).inDays > 0).toList();
    _timelineData = _data.map((x) {
      final period = x.date.difference(DateTime.now()).inDays;
      return TimelineData(
        title: period >= 730
            ? '${period ~/ 365} years'
            : period >= 365
                ? '1 year'
                : period >= 60 ? '${period ~/ 30} months' : period >= 30 ? '1 month' : '$period days',
        amount: x.amount,
        purpose: x.category.name,
        style: x.saving,
      );
    }).toList();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Budgeting',
      expandBottom: true,
      child: LayoutBuilder(builder: _layout),
    );
  }

  Widget _layout(BuildContext context, BoxConstraints constraints) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Stack(children: [
        // gradient background
        Container(
          width: 32,
          height: constraints.maxHeight - 100,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: lightColor, blurRadius: constraints.maxWidth, spreadRadius: _timelineX)],
          ),
        ),
        // roadmap
        Positioned.fill(
          child: _roadmap(constraints.maxHeight),
        ),
      ]),
    );
  }

  Widget _roadmap(double height) {
    double y = height - 64;
    double _maxH = height - 112;
    double total = _maxH;

    List<Widget> children = [];

    if (_data.isNotEmpty) {
      total = 112.0 * _data.length;
      y = total + 48;
      for (var i = 0; i < _data.length; i++) {
        y -= 112; //periods[i] * scale;
        children.add(_timeNode(i, y));
        children.add(_timeIndicator(y));
      }
    }
    // content
    children.insert(0, _content(height - 80));
    // timeline
    children.insert(1, _timeline(total + 96));
    //today
    children.insert(2, _today(total + 48));

    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        height: total + 112,
        child: Stack(children: children),
      ),
    );
  }

  Widget _content(double height) {
    final TextStyle _btnStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w400);

    return Positioned(
      left: _timelineX + _nodeMinWidth + 36,
      right: 16,
      top: _scrollOffset,
      height: height,
      // child: SingleChildScrollView(
      child: Column(children: [
        // setup target
        SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: OutlineRoundButton(
            title: 'Set up target',
            onPressed: () => navigate(context, '/budgeting/setup-target'),
          ),
        ),
        // year select
        Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            icon: Icon(Icons.arrow_left, size: 32),
            color: Colors.white,
            onPressed: () {},
          ),
          Text('2019 May', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
          IconButton(
            icon: Icon(Icons.arrow_right, size: 32),
            color: Colors.white,
            onPressed: () {},
          ),
        ]),
        // W/M/Y
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: GradientButton(child: Text('W', style: _btnStyle)),
            flex: 1,
          ),
          SizedBox(width: 8),
          Expanded(
            child: GradientButton(child: Text('M', style: _btnStyle)),
            flex: 1,
          ),
          SizedBox(width: 8),
          Expanded(
            child: GradientButton(child: Text('Y', style: _btnStyle)),
            flex: 1,
          ),
        ]),
        // circle button
        SizedBox(height: 8),
        CircleButton(
          title: '\$2500',
          size: 96,
          titleStyle: const TextStyle(color: primaryColor, fontSize: 22, fontWeight: FontWeight.w400),
          onPressed: () => navigate(context, '/budgeting/remaining'),
        ),
        FlatButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Remaining Budget', style: const TextStyle(color: Colors.white)),
              Icon(Icons.keyboard_arrow_right, color: Colors.white),
            ],
          ),
          onPressed: () => navigate(context, '/budgeting/remaining'),
        ),
        // Total panel
        _totalPanel(),
      ]),
      // ),
    );
  }

  Widget _totalPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/bg_cell_x.png'), fit: BoxFit.fill),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total saving goal:'),
          SizedBox(height: 12),
          Center(
            child: Text('\$100,000',
                style: const TextStyle(color: primaryColor, fontSize: 26, fontWeight: FontWeight.w500)),
          ),
          SizedBox(height: 12),
          Row(children: [
            Text('Due date :'),
            SizedBox(width: 8),
            Expanded(child: Text('2020 Jan 01', textAlign: TextAlign.end)),
          ]),
          SizedBox(height: 12),
          Row(children: [
            Text('Difficulty index :'),
            SizedBox(width: 8),
            Expanded(
                child: Text('4', textAlign: TextAlign.end, style: const TextStyle(color: accentColor, fontSize: 17))),
          ]),
          SizedBox(height: 16),
          Center(
            child: OutlineRoundButton(
              title: 'Tracker',
              width: 140,
              fill: true,
              onPressed: () => navigate(context, '/budgeting/tracker'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeline(double height) {
    return Positioned(
      left: _timelineX,
      top: 0,
      width: 3,
      height: height,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: primaryColor,
          boxShadow: [BoxShadow(color: Color(0xAA00FFD7), blurRadius: 8, spreadRadius: 1)],
        ),
      ),
    );
  }

  Widget _today(double y) {
    return Positioned(
      left: _timelineX - 6.5,
      top: y - 6.5,
      child: Row(children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xFF0BF6D5),
            boxShadow: [BoxShadow(color: Color(0xFF00FFD7), blurRadius: 8, spreadRadius: 1)],
          ),
        ),
        SizedBox(width: 8),
        Text('Today', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
      ]),
    );
  }

  Widget _timeIndicator(double y) {
    return Positioned(
      left: _timelineX - 2.5,
      top: y - 2.5,
      child: IgnorePointer(
        child: Row(children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xFF0BF6D5),
              boxShadow: [BoxShadow(color: Color(0xFF00FFD7), blurRadius: 1, spreadRadius: 1)],
            ),
          ),
          Container(
            width: 8 + _nodeMinWidth + 4,
            height: 3,
            decoration: BoxDecoration(
              color: Color(0xFF0BF6D5),
              boxShadow: [BoxShadow(color: Color(0xAA00FFD7), blurRadius: 8, spreadRadius: 1)],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _timeNode(int index, double y) {
    return TimelineNode(
      _timelineData[index],
      key: ValueKey(index),
      x: _timelineX + 14.5,
      y: y,
      minWidth: _nodeMinWidth,
      maxWidth: _nodeMinWidth * 2.75,
      offsetY: _nodeOffsetY,
      onPressed: () => setState(() {
        for (int i = 0; i < _timelineData.length; i++) {
          if (i == index) {
            _timelineData[i] = _timelineData[i].withExpand(!_timelineData[i].isExpanded);
          } else {
            _timelineData[i] = _timelineData[i].withExpand(false);
          }
        }
      }),
    );
  }

  List<TimelineData> _timelineData = [];
  List<RptTarget> _data = [
    RptTarget(
        category: RptCategory.of(RptCategoryType.dining),
        amount: 1000,
        date: DateTime(2019, 8, 8),
        saving: 'Progressive',
        remarks: '111 111'),
    RptTarget(
        category: RptCategory.of(RptCategoryType.dining),
        amount: 2000,
        date: DateTime(2019, 8, 14),
        saving: 'Regressive',
        remarks: '222 222'),
    RptTarget(
        category: RptCategory.of(RptCategoryType.dining),
        amount: 3000,
        date: DateTime(2019, 8, 21),
        saving: 'Default',
        remarks: '333 333'),
    RptTarget(
        category: RptCategory.of(RptCategoryType.dining),
        amount: 4000,
        date: DateTime(2019, 10, 1),
        saving: 'Progressive',
        remarks: '444 444'),
    RptTarget(
        category: RptCategory.of(RptCategoryType.dining),
        amount: 5000,
        date: DateTime(2019, 10, 13),
        saving: 'Regressive',
        remarks: '555 555'),
    RptTarget(
        category: RptCategory.of(RptCategoryType.dining),
        amount: 6000,
        date: DateTime(2020, 3, 20),
        saving: 'Default',
        remarks: '666 666'),
    RptTarget(
        category: RptCategory.of(RptCategoryType.dining),
        amount: 7000,
        date: DateTime(2020, 6, 5),
        saving: 'Progressive',
        remarks: '777 777 '),
    RptTarget(
        category: RptCategory.of(RptCategoryType.dining),
        amount: 8000,
        date: DateTime(2025, 9, 1),
        saving: 'Regressive',
        remarks: '888 888'),
    RptTarget(
        category: RptCategory.of(RptCategoryType.dining),
        amount: 9000,
        date: DateTime(2030, 7, 4),
        saving: 'Default',
        remarks: '999 999 '),
    RptTarget(
        category: RptCategory.of(RptCategoryType.dining),
        amount: 10000,
        date: DateTime(2030, 8, 30),
        saving: 'Progressive',
        remarks: '101010 101010'),
  ];
}

class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
