import 'package:areix/models/balance.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';

import '../common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:areix/components/gradient-cell.dart';
import 'package:areix/components/simple-bar-chart.dart';

class AccountDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final String params = ModalRoute.of(context).settings.arguments;

    return CommonPage(
      title: params,
      child: FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor)),
            );
          }
          return ListView.builder(
            itemBuilder: _listItem,
            itemCount: data.length + 1,
          );
        },
      ),
    );
  }

  Widget _listItem(BuildContext context, int index) {
    if (index == 0) {
      return SizedBox(height: 24);
    }

    final item = data[index - 1];

    return GradientCell(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      key: ValueKey<int>(index),
      title: item.title,
      amount: item.amount,
      offset: item.offset,
      hasOffset: true,
      data: item.children,
    );
  }

  Future _loadData() async {
    final json = await Store.getStringList(KEY_BALANCE);
    final balances = List<Balance>.from(json.map((x) => balanceFromJson(x)));

    List<String> names = balances.asMap().map((index, x) => MapEntry(index, x.name)).values.toList();

    final items = names.map((name) {
      final filter = balances.where((x) => x.name == name);
      double amount = filter.map((x) => x.balance).reduce((x, y) => x + y);

      List<ChartData> children = [];

      children.addAll(filter.map((x) => ChartData(label: x.nature, value: x.balance)));

      return TableData(title: name, offset: 0, amount: amount, children: children);
    });

    data
      ..clear()
      ..addAll(items);

    isLoading = false;
  }

  List<TableData> data = [];
}

class TableData {
  final String title;
  final double offset;
  final double amount;
  final List<ChartData> children;

  TableData({
    this.title,
    this.offset,
    this.amount,
    this.children,
  });
}
