import 'package:areix/components/outline-round-button.dart';
import 'package:areix/models/category.dart';
import 'package:areix/models/target.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class TrackerPage extends StatefulWidget {
  const TrackerPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  bool _categoryAscending = false;
  bool _amountAscending = false;
  bool _dateAscending = false;
  bool _categoryEnable = false;
  bool _amountEnable = false;
  bool _dateEnable = false;
  bool _isPast = false;

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Target Tracker',
      child: Column(children: [
        _top(),
        _thead(),
        _tbody(),
        OutlineRoundButton(
          title: _isPast ? 'Upcoming targets' : 'Past targets',
          onPressed: () => setState(() => _isPast = !_isPast),
        ),
      ]),
    );
  }

  Widget _top() {
    final _l = TextStyle(color: primaryColor, fontSize: 28, fontWeight: FontWeight.w500);
    final _m = TextStyle(fontSize: 19, fontWeight: FontWeight.w400);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00FFED), Color(0xFF01796B), darkColor],
          stops: [0, 0.035, 1],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Row(children: [
            Text('Realised saving :', style: _m),
            Expanded(child: Container()),
            Text(currency(10000, fixed: 2), style: _l),
          ]),
          SizedBox(height: 16),
          Row(children: [
            Text('Growth rate :', style: _m),
            Expanded(child: Container()),
            Row(children: [
              Icon(Icons.arrow_drop_up, color: primaryColor),
              Text('18%', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
            ]),
          ]),
          SizedBox(height: 16),
          Row(children: [
            Text('Frequent saving purpose :', style: _m),
            Expanded(child: Container()),
            Text('Traveling', style: const TextStyle(color: primaryColor)),
          ]),
        ],
      ),
    );
  }

  Widget _thead() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.only(left: 40),
      child: Row(
        children: [
          _th(
            title: 'Category',
            asc: _categoryAscending,
            enable: _categoryEnable,
            onTap: () {
              setState(() {
                if (!_categoryEnable) {
                  _categoryEnable = true;
                  _categoryAscending = true;
                } else if (_categoryAscending) {
                  _categoryAscending = false;
                } else {
                  _categoryEnable = false;
                }
                _amountEnable = false;
                _dateEnable = false;
              });
            },
          ),
          SizedBox(width: 4),
          _th(
            title: '\$',
            asc: _amountAscending,
            enable: _amountEnable,
            onTap: () {
              setState(() {
                if (!_amountEnable) {
                  _amountEnable = true;
                  _amountAscending = true;
                } else if (_amountAscending) {
                  _amountAscending = false;
                } else {
                  _amountEnable = false;
                }
                _categoryEnable = false;
                _dateEnable = false;
              });
            },
          ),
          SizedBox(width: 4),
          _th(
            title: 'Due date',
            asc: _dateAscending,
            enable: _dateEnable,
            onTap: () {
              setState(() {
                if (!_dateEnable) {
                  _dateEnable = true;
                  _dateAscending = true;
                } else if (_dateAscending) {
                  _dateAscending = false;
                } else {
                  _dateEnable = false;
                }
                _categoryEnable = false;
                _amountEnable = false;
              });
            },
          ),
          SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: Center(
              child: Text('Index', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _th({String title, bool asc, bool enable, VoidCallback onTap}) {
    final icon = SvgPicture.asset(
      asc ? 'assets/ic_ascending.svg' : 'assets/ic_descending.svg',
      color: enable ? primaryColor : Color(0xFF014F52),
    );

    return Expanded(
      flex: 3,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
              SizedBox(width: 4),
              icon,
            ],
          ),
        ),
      ),
    );
  }

  Widget _tbody() {
    List<RptTarget> _filtered = _isPast
        ? _data.where((item) => item.date.difference(DateTime.now()).inSeconds <= 0).toList()
        : _data.where((item) => item.date.difference(DateTime.now()).inSeconds > 0).toList();
    if (_categoryEnable) {
      _filtered.sort((a, b) {
        return _categoryAscending
            ? a.category.name.compareTo(b.category.name)
            : b.category.name.compareTo(a.category.name);
      });
    } else if (_amountEnable) {
      _filtered.sort((a, b) {
        return _amountAscending ? a.amount.compareTo(b.amount) : b.amount.compareTo(a.amount);
      });
    } else if (_dateEnable) {
      _filtered.sort((a, b) {
        return _dateAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date);
      });
    }

    return Expanded(
      child: Container(
        decoration: _isPast
            ? null
            : BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg_gradient_v.png'),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                ),
              ),
        child: ListView.builder(
          itemCount: _filtered.length,
          itemBuilder: (context, index) => _tr(context, _filtered[index]),
        ),
      ),
    );
  }

  Widget _tr(BuildContext context, RptTarget item) {
    final _white = TextStyle(fontSize: 15);
    final _primary = TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w400);
    final _accent = TextStyle(color: accentColor, fontSize: 15);

    BoxDecoration decoration;
    if (_isPast) {
      if (item.success) {
        decoration = BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00FFED), Color(0xFF01796B), darkColor],
            stops: [0, 0.015, 1],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        );
      } else {
        decoration = BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD95F1B), Color(0xFFFE6F20), Color(0xFF63351B), darkColor],
            stops: [0, 0.0075, 0.015, 1],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          color: Colors.yellow,
        );
      }
    }

    return Tooltip(
      message: item.remarks,
      child: Container(
        padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
        decoration: decoration,
        child: Row(children: [
          // icon
          item.category.rounded(size: 28),
          // category
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(item.category.name, style: _isPast && !item.success ? _accent : _white),
          ),
          // amount
          SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: Text('${currency(item.amount, fixed: 2)}', style: _isPast && !item.success ? _accent : _primary),
          ),
          // date
          SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: Text(DateFormat('yyyy MMM d').format(item.date), style: _white),
          ),
          // index
          SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(item.difficulty.toString(), style: item.difficulty > 3 ? _accent : _white),
            ),
          ),
        ]),
      ),
    );
  }

  List<RptTarget> _data = [
    RptTarget(
        category: RptCategory.of(RptCategoryType.dining),
        amount: 200,
        date: DateTime(2020, 1, 31),
        remarks: 'Remarks1 Remarks1 Remarks1 Remarks1 Remarks1',
        success: true),
    RptTarget(
        category: RptCategory.of(RptCategoryType.groceries_and_rent),
        amount: 100,
        date: DateTime(2019, 11, 15),
        remarks: 'Remarks2 Remarks2 Remarks2 Remarks2 Remarks2',
        success: true),
    RptTarget(
        category: RptCategory.of(RptCategoryType.shopping),
        amount: 500,
        date: DateTime(2021, 2, 1),
        remarks: 'Remarks3 Remarks3 Remarks3 Remarks3 Remarks3',
        success: false),
    RptTarget(
        category: RptCategory.of(RptCategoryType.shopping),
        amount: 5000,
        date: DateTime(2019, 12, 11),
        remarks: 'Remarks4 Remarks4 Remarks4 Remarks4 Remarks4',
        success: false),
    RptTarget(
        category: RptCategory.of(RptCategoryType.shopping),
        amount: 10100,
        date: DateTime(2019, 2, 1),
        remarks: 'Remarks5 Remarks5 Remarks5 Remarks5 Remarks5',
        success: true),
    RptTarget(
        category: RptCategory.of(RptCategoryType.shopping),
        amount: 200,
        date: DateTime(2019, 1, 8),
        remarks: 'Remarks6 Remarks6 Remarks6 Remarks6 Remarks6',
        success: false),
    RptTarget(
        category: RptCategory.of(RptCategoryType.shopping),
        amount: 100,
        date: DateTime(2018, 5, 8),
        remarks: 'Remarks7 Remarks7 Remarks7 Remarks7 Remarks7',
        success: true),
    RptTarget(
        category: RptCategory.of(RptCategoryType.shopping),
        amount: 500,
        date: DateTime(2019, 7, 31),
        remarks: 'Remarks8 Remarks8 Remarks8 Remarks8 Remarks8',
        success: false),
  ];
}
