import 'package:areix/components/pie-chart.dart';
import 'package:areix/models/transaction.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'common.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    final _chartSize = _screenWidth * 1.25;

    return CommonPage(
      title: 'Portal',
      isAppBarTransparent: true,
      expandBottom: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.account_circle, color: primaryColor),
          onPressed: () => navigate(context, '/profile'),
        )
      ],
      child: Stack(children: [
        Positioned(
          left: -_chartSize / 2,
          top: (_screenHeight - _chartSize) / 2,
          child: _chart(_chartSize),
        ),
        Align(
          alignment: Alignment(0.2, -0.6),
          child: _circleButton('Expense Analysis', () => navigate(context, '/analysis')),
        ),
        Align(
          alignment: Alignment(0.65, -0.35),
          child: _circleButton('Budgeting', () => navigate(context, '/budgeting')),
        ),
        Align(
          alignment: Alignment(0.8, -0),
          child: _circleButton('Account Management', () => navigate(context, '/account')),
        ),
        Align(
          alignment: Alignment(0.65, 0.35),
          child: _circleButton('Areix Pro', () => navigate(context, '/pro')),
        ),
        Align(
          alignment: Alignment(0.2, 0.6),
          child: _circleButton('Coupons', () => navigate(context, '/coupon')),
        ),
      ]),
    );
  }

  Widget _circleButton(String title, VoidCallback onPressed) {
    const double size = 90;

    return Container(
      width: size,
      height: size,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        shape: CircleBorder(),
        color: Colors.white24,
        disabledColor: Colors.white24,
        highlightColor: Colors.white30,
        splashColor: Colors.white30,
        child: Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 13)),
        onPressed: onPressed,
      ),
    );
  }

  Widget _chart(double size) {
    return FutureBuilder(
      future: _loadTransaction(),
      builder: (context, snapshot) {
        List<RptPieChartData> chartData = [RptPieChartData(value: 0, color: darkColor)];

        if (data.isNotEmpty) {
          chartData = data.map((item) {
            return RptPieChartData(
              value: item.amount,
              color: item.category.color,
              icon: item.category.rounded(),
            );
          }).toList();
        }

        return Container(
          width: size,
          height: size,
          child: RptPieChart(
            chartData,
            contentData: RptPieContentData(
              spent: spent,
              total: total,
              alignment: Alignment.centerRight,
              headStyle: const TextStyle(color: primaryColor, fontSize: 64, fontWeight: FontWeight.w500),
              bodyStyle: const TextStyle(color: primaryColor, fontSize: 19),
            ),
            radius: size * 0.35,
            labelSpace: 48,
            fillRemaining: true,
          ),
        );
      },
    );
  }

  Future _loadTransaction() async {
    final json = await Store.getStringList(KEY_TRANSACTIONS);
    final transactions = json.map((x) => transactionFromJson(x));

    data = List<Transaction>.from(transactions.where((x) => x.amount < 0))..forEach((x) => x.amount = x.amount.abs());

    spent = data.map((x) => x.amount.abs()).reduce((x, y) => x + y);
    total = transactions.where((x) => x.amount > 0).map((x) => x.amount.abs()).reduce((x, y) => x + y);
  }

  List<Transaction> data = [];
  double spent = 0, total = 0;
}
