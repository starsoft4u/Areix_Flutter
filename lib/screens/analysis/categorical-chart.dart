import 'package:areix/components/gradient-button.dart';
import 'package:areix/components/pie-chart.dart';
import 'package:areix/models/transaction.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';

import '../common.dart';

class CategoricalChartPage extends StatefulWidget {
  CategoricalChartPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoricalChartPageState();
}

class _CategoricalChartPageState extends State<CategoricalChartPage> {
  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Categorical Chart',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 8),
            _buttons(),
            SizedBox(height: 16),
            _chart(context),
            SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Insight',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '-	By the date 18/08/2019, you have spent \$6,000 this month. \$9,000 left to reach the expense limit. You have spent the most on dinning, around \$2,400 in total. The second is transportation, approximately \$1800. Other expenses including entertainment and bills account for \$1,800 of the total expense.',
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buttons() {
    final _textStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w400);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(children: [
        Expanded(
          child: GradientButton(
            child: Text('Weekly', style: _textStyle),
            selected: filterBy == 7,
            onPressed: () => setState(() => filterBy = 7),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: GradientButton(
            child: Text('Monthly', style: _textStyle),
            selected: filterBy == 30,
            onPressed: () => setState(() => filterBy = 30),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: GradientButton(
            child: Text('Yearly', style: _textStyle),
            selected: filterBy == 365,
            onPressed: () => setState(() => filterBy = 365),
          ),
        ),
      ]),
    );
  }

  Widget _chart(BuildContext context) {
    return FutureBuilder(
      future: _loadTransaction(),
      builder: (context, snapshot) {
        List<RptPieChartData> chartData = [RptPieChartData(value: 0, color: darkColor)];

        if (filter.isNotEmpty) {
          chartData = filter.map((item) {
            return RptPieChartData(
              value: item.amount,
              color: item.category.color,
              icon: item.category.rounded(),
            );
          }).toList();
        }

        return Container(
          constraints: BoxConstraints.expand(height: 320),
          child: RptPieChart(
            chartData,
            contentData: RptPieContentData(
              spent: spent,
              total: total,
            ),
            isPercent: true,
            rotate: false,
            onTap: (index) {
              if (filter.isNotEmpty) {
                navigate(context, '/analysis/statement', params: filter[index].category);
              }
            },
          ),
        );
      },
    );
  }

  Future _loadTransaction() async {
    final json = await Store.getStringList(KEY_TRANSACTIONS);

    data = List<Transaction>.from(json.map((x) => transactionFromJson(x)));

    filterByDate();
  }

  Future filterByDate() async {
    final temp = List<Transaction>.from(data)
      ..forEach((x) {
        List<TransactionItem> list = [];
        if (filterBy == 7) {
          list = x.transactions
              .where((x) =>
                  x.madeOn.millisecondsSinceEpoch <= filterDate.millisecondsSinceEpoch &&
                  x.madeOn.year == filterDate.year &&
                  Jiffy(x.madeOn).week == Jiffy(filterDate).week)
              .toList();
        } else if (filterBy == 30) {
          list = x.transactions
              .where((x) =>
                  x.madeOn.millisecondsSinceEpoch <= filterDate.millisecondsSinceEpoch &&
                  x.madeOn.year == filterDate.year &&
                  x.madeOn.month == filterDate.month)
              .toList();
        } else if (filterBy == 365) {
          list = x.transactions
              .where((x) =>
                  x.madeOn.millisecondsSinceEpoch <= filterDate.millisecondsSinceEpoch &&
                  x.madeOn.year == filterDate.year)
              .toList();
        }

        double sum = list.isEmpty ? 0 : list.map((x) => x.amount).reduce((x, y) => x + y);

        x.amount = sum;
        x.transactions = list;
      });

    filter = List<Transaction>.from(temp.where((x) => x.amount < 0))..forEach((x) => x.amount = x.amount.abs());

    spent = filter.map((x) => x.amount.abs()).reduce((x, y) => x + y);
    total = temp.where((x) => x.amount > 0).map((x) => x.amount.abs()).reduce((x, y) => x + y);
  }

  int filterBy = 7;
  List<Transaction> data = [], filter = [];
  double spent = 0, total = 0;
  DateTime filterDate = DateTime.parse('2019-07-29');
}
