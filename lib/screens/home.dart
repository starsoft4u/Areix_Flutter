import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:areix/components/outline-round-button.dart';
import 'package:areix/models/balance.dart';
import 'package:areix/models/transaction.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'common.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  final textEditingController = new TextEditingController();
  final focusNode = new FocusNode();

  /*
  ** 1:   transaction
  ** 10:  cashflow
  ** 100: balance
  */
  int loadingState = 101;

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      isAppBarTransparent: true,
      hasFloatButton: false,
      actions: [
        IconButton(
          icon: Image.asset('assets/ic_menu.png', color: Colors.white70),
          onPressed: () {
            InterstitialAd(adUnitId: InterstitialAd.testAdUnitId, targetingInfo: MobileAdTargetingInfo())
              ..load()
              ..show();
            navigate(context, '/dashboard');
          },
        )
      ],
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      showIndicator: loadingState > 0,
      child: Column(children: [
        _logo(),
        _greetingLabel(),
        Expanded(child: _chatbot()),
        OutlineRoundButton(
          title: 'Expense Overview',
          width: 240,
          onPressed: () {},
        ),
        OutlineRoundButton(
          title: 'Expense Limit',
          width: 240,
          onPressed: () {},
        ),
        OutlineRoundButton(
          title: 'My Coupons',
          width: 240,
          onPressed: () {},
        ),
        _textBox(),
      ]),
    );
  }

  Widget _logo() => Container(
        child: Image.asset(
          'assets/logo.png',
          width: 100,
          height: 80,
          fit: BoxFit.contain,
        ),
        margin: const EdgeInsets.only(top: 48, bottom: 16),
      );

  Widget _greetingLabel() => Center(
        child: Text(
          'Good morning, John!',
          style: const TextStyle(color: primaryColor, fontSize: 22),
        ),
      );

  Widget _chatbot() => Container();

  Widget _textBox() {
    return Container(
      width: double.infinity,
      height: 40,
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.only(left: 16),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF5E777B),
      ),
      child: Row(children: [
        Flexible(
          child: TextField(
            decoration: null,
            style: const TextStyle(color: primaryColor, fontSize: 15.0),
            controller: textEditingController,
            focusNode: focusNode,
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          color: primaryColor,
          highlightColor: Color(0xFF00DDA7),
          splashColor: Color(0xFF00DDA7),
          onPressed: () {},
        ),
      ]),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Store.getString(KEY_SYNC_DATE).then((date) {
      final formatter = DateFormat("yyyy-MM-dd");
      final now = DateTime.now();

      bool update = false;
      if (date == null) {
        update = true;
      } else {
        final syncDate = Jiffy(formatter.parse(date));
        update = !Jiffy(now).isSame(syncDate, "day");
      }

      // for test, uncomment follow line:
      // update = true;

      if (update) {
        Store.setString(KEY_SYNC_DATE, formatter.format(now));
        _loadTransaction();
        _loadBalance();
      } else {
        setState(() {
          loadingState = 0;
        });
      }
    });
  }

  // transaction
  void _loadTransaction() {
    http.post(URL_GET_TRANSACTION).then((response) {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<dynamic> transactions = json.map((x) => Transaction.fromJson(x)).toList();
        Store.setStringList(KEY_TRANSACTIONS, transactions.map((x) => transactionToJson(x)).toList());
      } else {
        print('ERR >>> Loading transactions failed with code: ${response.statusCode} and message: ${response.body}');
      }

      setState(() {
        loadingState -= 1;
      });
    });
  }

  void _loadBalance() {
    http.post(URL_GET_BALANCE).then((response) {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<dynamic> balances = json.map((x) => Balance.fromJson(x)).toList();
        Store.setStringList(KEY_BALANCE, balances.map((x) => balanceToJson(x)).toList());
      } else {
        print('ERR >>> Loading balances failed with code: ${response.statusCode} and message: ${response.body}');
      }

      setState(() {
        loadingState -= 100;
      });
    });
  }
}
