import 'package:areix/models/category.dart';
import 'package:areix/models/transaction.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../common.dart';

class StatementPage extends StatefulWidget {
  StatementPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StatementPagePageState();
}

class _StatementPagePageState extends State<StatementPage> {
  @override
  Widget build(BuildContext context) {
    RptCategory category = ModalRoute.of(context).settings.arguments;
    int index = RptCategoryType.values.indexWhere((x) => RptCategory.of(x).equal(category));
    if (index < 0) {
      index = 0;
    } else {
      index += 1;
    }

    return CommonPage(
      title: 'Statement',
      child: DefaultTabController(
        length: RptCategoryType.values.length + 1,
        initialIndex: index,
        child: Stack(children: [
          _tabBar(),
          Container(
            margin: const EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_gradient_v.png'),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
            child: FutureBuilder(
              future: _loadTransaction(),
              builder: (context, snapshot) {
                return data.isEmpty
                    ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor))
                    : _tabView();
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(top: 1),
      child: TabBar(
        isScrollable: true,
        indicator: _indicator(),
        tabs: _tabItems(),
      ),
    );
  }

  BoxDecoration _indicator() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/bg_tab.png'),
        alignment: Alignment.bottomCenter,
        fit: BoxFit.fill,
      ),
    );
  }

  List<Widget> _tabItems() {
    return <Widget>[
      Tab(icon: Container(child: Image.asset("assets/ic_apps.png", color: Color(0xFF00FFD8)))),
    ]..addAll(RptCategoryType.values.map(
        (item) => Tab(icon: Container(child: SvgPicture.asset(RptCategory.of(item).image))),
      ));
  }

  Widget _tabView() {
    var tabViews = <Widget>[_tabPage(null)]
      ..addAll(RptCategoryType.values.map((item) => _tabPage(RptCategory.of(item))).toList());
    return TabBarView(children: tabViews);
  }

  Widget _tabPage(RptCategory category) {
    var items = <TransactionItem>[];

    if (category == null) {
      data.forEach((x) => items.addAll(x.transactions));
    } else {
      final transaction = data.firstWhere((x) => x.category.equal(category), orElse: () => null);
      if (transaction != null) {
        items.addAll(transaction.transactions);
      }
    }

    items.forEach((x) => x.amount = x.amount.abs());

    return TabPage(items);
  }

  Future _loadTransaction() async {
    final json = await Store.getStringList(KEY_TRANSACTIONS);
    final transactions = json.map((x) => transactionFromJson(x));

    data
      ..clear()
      ..addAll(transactions.where((x) => x.amount < 0))
      ..forEach((x) => x.amount = x.amount.abs());

    return data;
  }

  List<Transaction> data = [];
}

class TabPage extends StatefulWidget {
  final List<TransactionItem> tableData;

  TabPage(this.tableData) {
    tableData.sort((x, y) => x.madeOn.compareTo(y.madeOn));
  }

  @override
  State<StatefulWidget> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  @override
  Widget build(BuildContext context) {
    var dates = widget.tableData.map((x) => DateTime(x.madeOn.year, x.madeOn.month)).toSet().toList()
      ..sort((x, y) => y.compareTo(x));
    var data = <TransactionItem>[];
    dates.forEach((x) {
      data
        ..add(TransactionItem(madeOn: x))
        ..addAll(widget.tableData.where((y) => y.madeOn.year == x.year && y.madeOn.month == x.month));
    });

    return ListView(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
      children: data.map((x) => _cell(x)).toList(),
    );
  }

  Widget _cell(TransactionItem item) {
    final _textStyle = TextStyle(color: Colors.white, fontSize: 17);
    final _textStyleSub = TextStyle(color: Colors.white70, fontSize: 15);

    if (item.description == null) {
      return ListTile(
        leading: Text(DateFormat('yyyy MMM').format(item.madeOn), style: _textStyle),
        enabled: false,
      );
    } else {
      return ListTile(
        title: Text(item.description, style: _textStyle),
        subtitle: Text(item.category, style: _textStyleSub),
        leading: Image.asset('assets/fake/mcdonalds.png'),
        trailing: Text('${currency(item.amount)}', style: _textStyle),
      );
    }
  }
}
