import 'dart:math';

import 'package:areix/components/axis.dart';
import 'package:areix/models/cashflow.dart';
import 'package:areix/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import '../common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:areix/components/bar-chart.dart';
import 'package:areix/components/dashed-line.dart';
import 'package:areix/utils/utils.dart';

class TrendMorePage extends StatefulWidget {
  TrendMorePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrendMorePageState();
}

class _TrendMorePageState extends State<TrendMorePage> {
  @override
  Widget build(BuildContext context) {
    filterDate = ModalRoute.of(context).settings.arguments;

    return CommonPage(
      title: 'Trend',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _chart(context),
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
                'Lorem ipsum Lorem ipsum Lorem ipsum Lorem Lorem ipsum Lorem ipsum Lorem ipsum Lorem Lorem ipsum Lorem ipsum Lorem ipsum LoremLorem ipsum Lorem ipsum Lorem ipsum Lorem Lorem ipsum Lorem ipsum Lorem ipsum Lorem Lorem ipsum Lorem ipsum Lorem ipsum LoremLorem ipsum Lorem ipsum Lorem ipsum Lorem Lorem ipsum Lorem ipsum Lorem ipsum Lorem Lorem ipsum Lorem ipsum Lorem ipsum LoremLorem ipsum Lorem ipsum Lorem ipsum Lorem Lorem ipsum Lorem ipsum Lorem ipsum Lorem Lorem ipsum Lorem ipsum Lorem ipsum LoremLorem ipsum Lorem ipsum Lorem ipsum Lorem Lorem ipsum Lorem ipsum Lorem ipsum Lorem Lorem ipsum Lorem ipsum Lorem ipsum Lorem',
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _description() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      child: Row(children: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          width: 36,
          height: 5,
          child: DashedLine(dashHeight: 3),
        ),
        Text('Expense limit (by week)'),
      ]),
    );
  }

  Widget _chart(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (data.isEmpty) {
          return Container(
            constraints: BoxConstraints.expand(height: 300),
            child: Center(
              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor)),
            ),
          );
        }

        return Container(
          constraints: BoxConstraints.expand(height: 300),
          child: RptBarChart(
            data,
            axisX: RptAxis(
              max: 6,
              labels: xLabels,
              labelTextStyle: const TextStyle(fontSize: 17),
            ),
            axisY: RptAxis(
              max: maxExpense,
              title: '\$',
              labels: yLabels.reversed.toList(),
            ),
            onTap: (index) {
              navigate(context, '/analysis/categorial-chart', params: Jiffy(filterDate).subtract(months: (5 - index)));
            },
          ),
        );
      },
    );
  }

  Future _loadData() async {
    // Load data
    final json = await Store.getStringList(KEY_CASHFLOW);
    final cashflows = List<CashFlow>.from(json.map((x) => cashFlowFromJson(x)));

    double _max = 0;

    final colors = [
      Color(0xFF03FDDA),
      Color(0xFF04ACA0),
      Color(0xFF1E6D6A),
      Color(0xFF5F9297),
      Color(0xFF577575),
      Color(0xFF415151),
    ];

    data.clear();
    xLabels.clear();
    yLabels.clear();
    maxExpense = 0;

    for (var i = 5; i >= 0; i--) {
      DateTime date = Jiffy(filterDate).subtract(months: i);

      // xLabels
      final month = DateFormat('MMM').format(date);
      if (date.month == 1 || date.month == 12) {
        xLabels.add(Column(children: [
          Text(month),
          Text(date.year.toString(), style: const TextStyle(fontSize: 13)),
        ]));
      } else {
        xLabels.add(month);
      }

      // data
      final filter = cashflows.where((x) => x.madeOn.year == date.year && x.madeOn.month == date.month);

      double incomeSum = filter.isEmpty ? 0 : filter.map((x) => x.income.abs()).reduce((x, y) => x + y);
      double outcomeSum = filter.isEmpty ? 0 : filter.map((x) => x.outcome.abs()).reduce((x, y) => x + y);

      data.add(RptBarChartData(value: incomeSum, limit: outcomeSum, color: colors[i]));

      _max = max(_max, incomeSum);
      _max = max(_max, outcomeSum);
    }

    // yLabels
    double y = 0;
    double step = _max < 30000 ? 5000 : (_max < 100000) ? 15000 : _max ~/ 100000;
    while (y - step < _max) {
      yLabels.add(currency(y));
      y += step;
    }
    maxExpense = y - step;
  }

  List<RptBarChartData> data = [];
  DateTime filterDate = DateTime.parse('2019-07-29');
  double maxExpense = 0;
  List<dynamic> xLabels = [];
  List<String> yLabels = [];
}
