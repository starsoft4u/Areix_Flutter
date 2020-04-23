import 'package:areix/components/gradient-cell.dart';
import 'package:areix/components/outline-round-button.dart';
import 'package:areix/models/balance.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  double deposit = 0;

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Account Management',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _button(),
            SizedBox(height: 8),
            Text(' Assets', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
            _assets(),
            SizedBox(height: 16),
            Text('Liabilities', style: const TextStyle(color: accentColor, fontSize: 22, fontWeight: FontWeight.w400)),
            _liabilities(),
          ]),
        ),
      ),
    );
  }

  Widget _button() {
    return Container(
      alignment: Alignment.centerRight,
      child: OutlineRoundButton(
        title: 'Add account',
        onPressed: () {},
      ),
    );
  }

  Widget _assets() {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        assets.first.value = deposit;
        return LayoutBuilder(builder: (context, constraint) {
          return Wrap(
            direction: Axis.horizontal,
            spacing: 8,
            children: assets
                .map((x) => GradientCell(
                      margin: const EdgeInsets.only(top: 8),
                      width: constraint.maxWidth / 2 - 4,
                      title: x.name,
                      amount: x.value,
                      hasOffset: true,
                      offset: x.offset,
                      onPressed: () => navigate(context, '/account/detail', params: x.name),
                    ))
                .toList(),
          );
        });
      },
    );
  }

  Widget _liabilities() {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Wrap(
          direction: Axis.horizontal,
          spacing: 8,
          children: liabilities
              .map((x) => GradientCell(
                    margin: const EdgeInsets.only(top: 8),
                    width: constraint.maxWidth / 2 - 4,
                    title: x.name,
                    amount: x.value,
                    isDark: true,
                    onPressed: () => navigate(context, '/account/detail', params: x.name),
                  ))
              .toList(),
        );
      },
    );
  }

  Future _loadData() async {
    final json = await Store.getStringList(KEY_BALANCE);
    final balances = List<Balance>.from(json.map((x) => balanceFromJson(x)));

    deposit = balances.map((x) => x.balance).reduce((x, y) => x + y);
  }

  List<BalanceItem> assets = [
    BalanceItem('Deposit', 0, offset: 8),
    BalanceItem('Stock', 18668, offset: 8),
    BalanceItem('MPF', 6886, offset: -0.7),
  ];
  List<BalanceItem> liabilities = [
    BalanceItem('Loan', 48000),
    BalanceItem('Mortage', 0),
    BalanceItem('Credit Card Debt', 13858),
  ];
}

class BalanceItem {
  String name;
  double value;
  double offset;

  BalanceItem(this.name, this.value, {this.offset});
}
