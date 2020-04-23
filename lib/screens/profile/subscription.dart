import 'package:areix/components/outline-round-button.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final codeController = TextEditingController();
  int _selectedPlanIndex = -1;
  bool _isValidate = false;

  @override
  void initState() {
    super.initState();
    codeController.addListener(_validate);
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Subscription & referral',
      hasFloatButton: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: <Widget>[
          Text('Choose your plan.'),
          SizedBox(height: 24),
          Row(children: <Widget>[
            Expanded(
              child: Column(children: <Widget>[
                Text(
                  'Individual',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 64,
                  height: 64,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, darkColor.withAlpha(0x00)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    width: 24,
                    height: 24,
                  ),
                ),
              ]),
            ),
            SizedBox(width: 24),
            Expanded(
              child: Column(children: <Widget>[
                Text(
                  'Group',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                Image.asset('assets/logo.png', width: 64, height: 64, fit: BoxFit.contain),
              ]),
            ),
          ]),
          SizedBox(height: 24),
          Row(children: <Widget>[
            Expanded(child: _option(0)),
            SizedBox(width: 8),
            Expanded(child: _option(1)),
          ]),
          SizedBox(height: 8),
          Row(children: <Widget>[
            Expanded(child: _option(2)),
            SizedBox(width: 8),
            Expanded(child: _option(3)),
          ]),
          SizedBox(height: 8),
          Row(children: <Widget>[
            Expanded(child: _option(4)),
            SizedBox(width: 8),
            Expanded(child: _option(5)),
          ]),
          SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Referral',
                style: const TextStyle(color: primaryColor, fontSize: 19, fontWeight: FontWeight.w400)),
          ),
          SizedBox(height: 8),
          Text(
            'Refer and get 3 months fee waiver for each sucessful referral of purchase.',
            style: const TextStyle(fontSize: 15),
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Referral code :', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: codeController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.edit, color: primaryColor, size: 20),
                  ),
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          OutlineRoundButton(
            title: 'Check out',
            width: 120,
            fill: _isValidate ? true : false,
            onPressed:
                _isValidate ? () => navigate(context, '/profile/checkout', params: _offers[_selectedPlanIndex]) : null,
          )
        ]),
      ),
    );
  }

  Widget _option(int index) {
    String monthStr = _offers[index].month == 1 ? " / mo" : " / ${_offers[index].month}mo";
    final month = TextSpan(text: monthStr, style: const TextStyle(color: primaryColor, fontSize: 15));
    final colors = _offers[index].bestOffer
        ? [darkColor.withAlpha(0x88), primaryColor.withAlpha(0x88)]
        : [darkColor.withAlpha(0x88), lightColor.withAlpha(0x88)];

    List<Widget> children = [
      Container(
        height: 36,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: RichText(
            text: TextSpan(
              text: currency(_offers[index].price),
              style: TextStyle(
                color: _offers[index].bestOffer ? primaryColor : Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w400,
              ),
              children: [month],
            ),
          ),
        ),
      )
    ];

    if (_offers[index].bestOffer) {
      children.insert(
        0,
        Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
          ),
          child: Center(
            child: Text(
              'Best offer',
              style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanIndex = index;
          _validate();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: index == _selectedPlanIndex ? Colors.white : Colors.transparent, width: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(children: children),
      ),
    );
  }

  void _validate() {
    setState(() {
//      _isValidate = codeController.text.isNotEmpty && _selectedPlanIndex >= 0;
      _isValidate = _selectedPlanIndex >= 0;
    });
  }

  List<Offer> _offers = [
    Offer(price: 38, month: 1),
    Offer(price: 100, month: 1),
    Offer(price: 50, month: 3),
    Offer(price: 150, month: 3),
    Offer(price: 120, month: 12, bestOffer: true),
    Offer(price: 380, month: 12, bestOffer: true),
  ];
}

class Offer {
  final int price;
  final int month;
  final bool bestOffer;

  Offer({
    this.price,
    this.month,
    this.bestOffer = false,
  });
}
