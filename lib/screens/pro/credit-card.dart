import 'package:areix/screens/common.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CreditCardPage extends StatefulWidget {
  CreditCardPage({Key key}) : super(key: key);

  _CreditCardPageState createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  String _filterString = 'All cards';

  @override
  Widget build(BuildContext context) {
    _filterKey = ['All cards'];
    _filterKey.addAll(Set.of(_data.map((x) => x.name)).toList());

    if (_filterString == _filterKey.first) {
      _filtered = _data;
    } else {
      _filtered = _data.where((x) => x.name == _filterString).toList();
    }

    return CommonPage(
      title: 'Credit Card',
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(12),
            child: _filter(),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: _listItem,
              itemCount: _filtered.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filter() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: DropdownButton<String>(
              items: _filterKey.map((x) => DropdownMenuItem<String>(value: x, child: Text(x))).toList(),
              onChanged: (x) => setState(() => _filterString = x),
            ),
          ),
        ),
        IgnorePointer(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/ic_filter.svg'),
                SizedBox(width: 4),
                Text(_filterString),
                Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _listItem(BuildContext context, int index) {
    final CardModel item = _filtered[index];

    return GestureDetector(
      onTap: () => navigate(context, '/pro/credit-card/detail', params: item),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/bg_cell.png'), fit: BoxFit.fill),
        ),
        child: Row(children: [
          Image.asset(item.imageUrl, width: 124, height: 78, fit: BoxFit.contain),
          SizedBox(width: 8),
          Expanded(
            child: Text(item.name, style: const TextStyle(fontSize: 19)),
          ),
          SizedBox(width: 8),
          Text(item.value, style: const TextStyle(color: primaryColor, fontSize: 22, fontWeight: FontWeight.w400)),
        ]),
      ),
    );
  }

  List<String> _filterKey = [];
  List<CardModel> _filtered = [];
  final List<CardModel> _data = [
  CardModel(name: 'Cash rebate', value: '4%'),
    CardModel(name: 'Cash dollar', value: '\$220'),
    CardModel(name: 'Asia miles', value: '1000'),
    CardModel(name: 'Reward', value: 'Switch'),
    CardModel(name: 'Asia miles', value: '1500'),
    CardModel(name: 'Cash rebate', value: '1.5%'),
    CardModel(name: 'Reward', value: 'Switch')
  ];
}

class CardModel {
  final String imageUrl;
  final String name;
  final String value;

  CardModel({
    this.imageUrl = 'assets/card.png',
    @required this.name,
    @required this.value,
  });
}
