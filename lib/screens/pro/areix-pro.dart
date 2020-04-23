import 'package:areix/components/outline-round-button.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AreixProPage extends StatelessWidget {
  const AreixProPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Areix Pro',
      expandBottom: true,
      child: Column(children: [
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Analysis on products impact on you cashflow and wealth.', textAlign: TextAlign.center),
          ),
        ),
        Column(mainAxisSize: MainAxisSize.min, children: [
          OutlineRoundButton(
            title: 'Credit card',
            width: 240,
            onPressed: () => navigate(context, '/pro/credit-card'),
          ),
          OutlineRoundButton(
            title: 'Deposit',
            margin: const EdgeInsets.symmetric(vertical: 16),
            width: 240,
            onPressed: () => navigate(context, '/pro/products', params: 'Deposit'),
          ),
          OutlineRoundButton(
            title: 'Saving insurance',
            width: 240,
            onPressed: () => navigate(context, '/pro/products', params: 'Saving Insurance'),
          ),
        ]),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ]),
    );
  }
}
