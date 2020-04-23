import 'dart:math';
import 'package:areix/components/axis.dart';
import 'package:areix/components/dashed-line.dart';
import 'package:areix/components/gradient-button.dart';
import 'package:areix/components/line-chart.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicator/page_view_indicator.dart';

class ResultPage extends StatefulWidget {
  ResultPage({Key key}) : super(key: key);

  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final _pageIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    String title = ModalRoute.of(context).settings.arguments;

    return CommonPage(
      title: title,
      child: Stack(alignment: Alignment.bottomCenter, children: [
        PageView(
          children: [PageOne(), PageTwo()],
          onPageChanged: (index) => _pageIndex.value = index,
        ),
        _pageIndicator(),
      ]),
    );
  }

  Widget _pageIndicator() {
    return Container(
      child: PageViewIndicator(
        pageIndexNotifier: _pageIndex,
        length: 2,
        normalBuilder: (animationController, index) => _dot(false),
        highlightedBuilder: (animationController, index) => ScaleTransition(
          scale: CurvedAnimation(parent: animationController, curve: Curves.ease),
          child: _dot(true),
        ),
        indicatorPadding: const EdgeInsets.all(4),
      ),
    );
  }

  Widget _dot(bool selected) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? Color(0xFF0BF6D5) : Color(0xFF014F52),
        boxShadow: selected ? [BoxShadow(color: Color(0xFF00FFD7), blurRadius: 5)] : null,
      ),
    );
  }
}

class PageOne extends StatefulWidget {
  PageOne({Key key}) : super(key: key);

  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  final _t = TextStyle(fontSize: 26, fontWeight: FontWeight.w400);
  final _r = TextStyle(fontWeight: FontWeight.w400);
  final _c = TextStyle(color: primaryColor);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        _panel(),
        SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            '\$1',
            style: const TextStyle(color: primaryColor, fontSize: 36, fontWeight: FontWeight.w400),
          ),
          Icon(Icons.arrow_right, color: primaryColor, size: 36),
          Text(
            '\$1.18',
            style: const TextStyle(color: primaryColor, fontSize: 36, fontWeight: FontWeight.w400),
          ),
        ]),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Expected time :', style: _r),
            Text('2 years', style: _c),
          ]),
        ),
        SizedBox(height: 24),
      ]),
    );
  }

  Widget _panel() {
    return Stack(overflow: Overflow.visible, children: [
      IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _left(),
          Expanded(child: _right()),
        ]),
      ),
      Positioned(
        left: 16,
        right: 16,
        bottom: -8,
        child: _bottom(),
      ),
    ]);
  }

  Widget _left() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: IntrinsicWidth(
        child: Column(children: [
          Text('Current', style: _t),
          SizedBox(height: 36),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Total', style: _r),
            Text('\$1', style: _c),
          ]),
          Expanded(child: Container()),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Total', style: _r),
            Text('\$1', style: _c),
          ]),
          SizedBox(height: 60),
        ]),
      ),
    );
  }

  Widget _right() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [lightColor.withAlpha(200), darkColor.withAlpha(0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _separator(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text('Expected', style: _t),
                SizedBox(height: 36),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Beginning', style: _r),
                  Text('\$1', style: _c),
                ]),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add :', style: _r),
                    Column(children: [
                      GradientButton(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text('+ Cash Flow', style: _c),
                      ),
                      GradientButton(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text('+ Cash Flow', style: _c),
                      ),
                    ]),
                  ],
                ),
                SizedBox(height: 36),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Ending', style: _r),
                  Text('\$1.18', style: _c),
                ]),
                SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.arrow_drop_up, size: 36, color: primaryColor),
                  Text('18%', style: const TextStyle(color: primaryColor, fontSize: 22, fontWeight: FontWeight.w400)),
                ]),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _separator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      width: 3,
      decoration: BoxDecoration(
        color: Color(0xFF0BF6D5),
        boxShadow: [BoxShadow(color: Color(0xAA00FFD7), blurRadius: 8, spreadRadius: 1)],
      ),
    );
  }

  Widget _bottom() {
    return Container(
      height: 16,
      child: Image.asset('assets/neon.png', fit: BoxFit.contain),
    );
  }
}

class PageTwo extends StatefulWidget {
  PageTwo({Key key}) : super(key: key);

  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  String _period = '1M';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 80),
      child: LayoutBuilder(builder: (context, constraint) {
        return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _data.keys.map((x) {
                return Expanded(
                  child: GradientButton(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      x,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    selected: _period == x,
                    onPressed: () => setState(() => _period = x),
                  ),
                );
              }).toList(),
            ),
          ),
          // chart
          Column(children: [
            _chart(constraint.maxHeight * 0.6),
            SizedBox(height: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(width: 36, height: 2, color: primaryColor),
                SizedBox(width: 16),
                Text('Expected'),
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  width: 36,
                  child: DashedLine(
                    color: accentColor,
                    dashHeight: 2,
                  ),
                ),
                SizedBox(width: 16),
                Text('Current'),
              ]),
            ]),
          ]),
          SizedBox(height: 16),
        ]);
      }),
    );
  }

  Widget _chart(double height) {
    final chartData = _data[_period];
    final values = chartData.map((x) => x.data).expand((x) => x).toList();
    final maxValue = values.map((x) => x.value).reduce(max);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      constraints: BoxConstraints.expand(height: height),
      child: RptLineChart(
        chartData,
        key: ValueKey(_period),
        axisX: RptAxis(
          title: 'Date',
          labels: _axisXLabels[_period],
          max: _axisXMax[_period],
        ),
        axisY: RptAxis(
          title: 'Cash',
          max: maxValue,
        ),
        paddingTop: 16,
      ),
    );
  }

  final Map<String, double> _axisXMax = {
    '1D': 24,
    '1W': 7,
    '1M': 30,
    '6M': 6,
    '1Y': 12,
  };
  final Map<String, List<dynamic>> _axisXLabels = {
    '1D': ['1', '3', '6', '9', '12', '15', '18', '21', '24'],
    '1W': ['Mon', 'Tue', 'Wed', 'Tur', 'Fri', 'Sat', 'Sun'],
    '1M': ['1', '15', '30'],
    '6M': ['1th', '2nd', '3rd', '4th', '5th', '6th'],
    '1Y': ['Jan', 'Feb', 'Mar', 'Api', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
  };
  final Map<String, List<RptLineChartData>> _data = {
    '1D': [
      RptLineChartData([
        RptPointData(index: 0, value: 0),
        RptPointData(index: 3, value: 6500),
        RptPointData(index: 6, value: 9000),
        RptPointData(index: 9, value: 12000),
        RptPointData(index: 12, value: 15000),
        RptPointData(index: 15, value: 16000),
        RptPointData(index: 18, value: 18000),
        RptPointData(index: 23, value: 23000),
      ]),
      RptLineChartData([
        RptPointData(index: 0, value: 0),
        RptPointData(index: 3, value: 3500),
        RptPointData(index: 6, value: 7000),
        RptPointData(index: 9, value: 10500),
        RptPointData(index: 12, value: 9000),
        RptPointData(index: 15, value: 12500),
        RptPointData(index: 18, value: 17500),
        RptPointData(index: 23, value: 22000),
      ], lineColor: accentColor, lineMode: RptLineMode.dash),
    ],
    '1W': [
      RptLineChartData([
        RptPointData(index: 0, value: 0),
        RptPointData(index: 1, value: 6500),
        RptPointData(index: 2, value: 9000),
        RptPointData(index: 3, value: 12000),
        RptPointData(index: 4, value: 15000),
        RptPointData(index: 5, value: 16000),
        RptPointData(index: 6, value: 18000),
      ]),
      RptLineChartData([
        RptPointData(index: 0, value: 0),
        RptPointData(index: 1, value: 3500),
        RptPointData(index: 2, value: 7000),
        RptPointData(index: 3, value: 10500),
        RptPointData(index: 4, value: 9000),
        RptPointData(index: 5, value: 12500),
        RptPointData(index: 6, value: 17500),
      ], lineColor: accentColor, lineMode: RptLineMode.dash),
    ],
    '1M': [
      RptLineChartData([
        RptPointData(index: 0, value: 0),
        RptPointData(index: 5, value: 6500),
        RptPointData(index: 10, value: 9000),
        RptPointData(index: 15, value: 12000),
        RptPointData(index: 17, value: 15000),
        RptPointData(index: 20, value: 16000),
        RptPointData(index: 22, value: 18000),
        RptPointData(index: 29, value: 23000),
      ]),
      RptLineChartData([
        RptPointData(index: 0, value: 0),
        RptPointData(index: 5, value: 3500),
        RptPointData(index: 10, value: 7000),
        RptPointData(index: 15, value: 10500),
        RptPointData(index: 17, value: 9000),
        RptPointData(index: 20, value: 11500),
        RptPointData(index: 27, value: 10500),
        RptPointData(index: 29, value: 12000),
      ], lineColor: accentColor, lineMode: RptLineMode.dash),
    ],
    '6M': [
      RptLineChartData([
        RptPointData(index: 0, value: 0),
        RptPointData(index: 1, value: 6500),
        RptPointData(index: 2, value: 9000),
        RptPointData(index: 3, value: 12000),
        RptPointData(index: 4, value: 15000),
        RptPointData(index: 5, value: 16000),
      ]),
      RptLineChartData([
        RptPointData(index: 0, value: 0),
        RptPointData(index: 1, value: 3500),
        RptPointData(index: 2, value: 7000),
        RptPointData(index: 3, value: 10500),
        RptPointData(index: 4, value: 9000),
        RptPointData(index: 5, value: 12500),
      ], lineColor: accentColor, lineMode: RptLineMode.dash),
    ],
    '1Y': [
      RptLineChartData([
        RptPointData(index: 0, value: 0),
        RptPointData(index: 3, value: 6500),
        RptPointData(index: 5, value: 9000),
        RptPointData(index: 6, value: 12000),
        RptPointData(index: 8, value: 15000),
        RptPointData(index: 9, value: 16000),
        RptPointData(index: 11, value: 18000),
      ]),
      RptLineChartData([
        RptPointData(index: 0, value: 0),
        RptPointData(index: 3, value: 3500),
        RptPointData(index: 5, value: 7000),
        RptPointData(index: 6, value: 10500),
        RptPointData(index: 8, value: 9000),
        RptPointData(index: 9, value: 12500),
        RptPointData(index: 11, value: 17500),
      ], lineColor: accentColor, lineMode: RptLineMode.dash),
    ],
  };
}
