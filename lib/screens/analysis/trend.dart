import 'dart:convert';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:areix/models/cashflow.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import '../common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:areix/components/outline-round-button.dart';
import 'package:areix/components/line-chart.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:areix/components/dashed-line.dart';
import 'package:areix/components/axis.dart';
import 'package:http/http.dart' as http;

class TrendPage extends StatefulWidget {
  TrendPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> with AfterLayoutMixin<TrendPage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Trend',
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _chart(),
          SizedBox(height: 16),
          _description(),
          SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Insight', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
          SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem Lorem ipsum Lorem ipsum Lorem ipsum Lorem Lorem ipsum Lorem ipsum Lorem ipsum Lorem',
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Center(
            child: OutlineRoundButton(
              margin: const EdgeInsets.symmetric(vertical: 16),
              title: 'Learn more',
              onPressed: () => navigate(context, '/analysis/trend/more', params: filterDate),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _description() {
    final lastMonth = Jiffy(filterDate).subtract(months: 1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(children: [
        Row(children: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 36,
            height: 3,
            color: primaryColor.withOpacity(0.5),
          ),
          Text(DateFormat("MMM").format(lastMonth)),
        ]),
        Row(children: [
          Container(margin: const EdgeInsets.only(right: 16), width: 36, height: 3, color: primaryColor),
          Text('${DateFormat("MMM").format(filterDate)} (this month)'),
        ]),
        Row(children: [
          Container(margin: const EdgeInsets.only(right: 16), width: 36, height: 5, child: DashedLine(dashHeight: 3)),
          Text('Expense limit (by week)'),
        ]),
      ]),
    );
  }

  Widget _chart() {
    if (isLoading) {
      return Container(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor)),
        ),
      );
    }

    return Container(
      height: 300,
      child: RptLineChart(
        data,
        axisX: RptAxis(
          max: 31,
          labels: [
            '1',
            Column(children: [
              Text('15', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              Text('Date', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ]),
            '31',
          ],
          labelTextStyle: const TextStyle(fontSize: 19),
        ),
        axisY: RptAxis(
          max: maxExpense,
          title: '\$',
          labels: yLabels.reversed.toList(),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    http.post(URL_GET_CASHFLOW).then((response) {
      final json = jsonDecode(response.body);
      final cashflows = List<CashFlow>.from(json.map((x) => CashFlow.fromJson(x)));
      Store.setStringList(KEY_CASHFLOW, cashflows.map((x) => cashFlowToJson(x)).toList());

      data.clear();

      double _max = 0;

      // last month
      final lastMonth = Jiffy(filterDate).subtract(months: 1);
      List<RptPointData> points = [];
      List<CashFlow> temp = List<CashFlow>.from(
          cashflows.where((x) => x.madeOn.year == lastMonth.year && x.madeOn.month == lastMonth.month));
      for (var i = 1; i <= 31; i++) {
        if (temp.any((x) => x.madeOn.day == i)) {
          final sum = temp.where((x) => x.madeOn.day == i).map((x) => x.income.abs()).reduce((x, y) => x + y);
          points.add(RptPointData(index: i - 1, value: sum));
          _max = max(_max, sum);
        }
      }
      if (points.isNotEmpty) {
        data.add(RptLineChartData(
          List<RptPointData>.from(points),
          lineColor: primaryColor.withOpacity(0.7),
          fillMode: RptFillMode.below,
          fillColor: primaryColor.withOpacity(0.5),
        ));
      }

      // this month
      points.clear();
      temp = List<CashFlow>.from(
          cashflows.where((x) => x.madeOn.year == filterDate.year && x.madeOn.month == filterDate.month));
      for (var i = 1; i <= 31; i++) {
        if (temp.any((x) => x.madeOn.day == i)) {
          final sum = temp.where((x) => x.madeOn.day == i).map((x) => x.income.abs()).reduce((x, y) => x + y);
          points.add(RptPointData(index: i - 1, value: sum));
          _max = max(_max, sum);
        }
      }
      if (points.isNotEmpty) {
        data.add(RptLineChartData(
          List<RptPointData>.from(points),
          lineColor: primaryColor,
          fillMode: RptFillMode.below,
          fillColor: primaryColor.withOpacity(0.5),
        ));
      }

      // expense limit
      points.clear();
      for (var i = 1; i <= 31; i++) {
        if (temp.any((x) => x.madeOn.day == i)) {
          final sum = temp.where((x) => x.madeOn.day == i).map((x) => x.outcome.abs()).reduce((x, y) => x + y);
          points.add(RptPointData(index: i - 1, value: sum));
          _max = max(_max, sum);
        }
      }
      if (points.isNotEmpty) {
        data.add(RptLineChartData(
          List<RptPointData>.from(points),
          lineColor: Colors.green,
          lineMode: RptLineMode.dash,
        ));
      }

      // yLabels
      double y = 0;
      double step = _max < 30000 ? 5000 : (_max < 100000) ? 15000 : _max ~/ 100000;
      while (y - step < _max) {
        yLabels.add(currency(y));
        y += step;
      }
      maxExpense = y - step;

      setState(() {
        isLoading = false;
      });
    });
  }

  List<RptLineChartData> data = [];
  DateTime filterDate = DateTime.parse('2019-07-29');
  double maxExpense = 0;
  List<String> yLabels = [];
}
