import 'package:areix/components/outline-round-button.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/screens/pro/credit-card.dart';
import 'package:areix/utils/constants.dart';
import 'package:flutter/material.dart';

class CardDetailPage extends StatefulWidget {
  const CardDetailPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  CardModel card;

  @override
  Widget build(BuildContext context) {
    card = ModalRoute.of(context).settings.arguments;

    return CommonPage(
      title: 'Credit Card',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _card(),
          // monthly expensive
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(children: [
              Expanded(
                child: Text('Monthly expensive :', style: const TextStyle(fontWeight: FontWeight.w400)),
              ),
              Icon(Icons.arrow_drop_down, color: accentColor, size: 36),
              Text('2.75%', style: const TextStyle(color: accentColor, fontSize: 22, fontWeight: FontWeight.w400)),
            ]),
          ),
          // cash rebate
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(children: [
              Expanded(
                child: Text('Cash rebate :', style: const TextStyle(fontWeight: FontWeight.w400)),
              ),
              Icon(Icons.arrow_drop_up, color: primaryColor, size: 36),
              Text('4%', style: const TextStyle(color: primaryColor, fontSize: 22, fontWeight: FontWeight.w400)),
            ]),
          ),
          // Sepcial offer
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Speical offer :', style: const TextStyle(fontWeight: FontWeight.w400)),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('New Customer could choose to get a Switch'),
            ),
          ),
          // button
          SizedBox(height: 24),
          Center(
            child: OutlineRoundButton(
              title: 'More',
              width: 140,
              fill: true,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _card() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/bg_cell_clip.png'), fit: BoxFit.fill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(card.imageUrl, width: 124, height: 78, fit: BoxFit.contain),
          SizedBox(width: 8),
          Text(card.name, style: const TextStyle(fontSize: 19)),
          SizedBox(width: 8),
          Text(card.value, style: const TextStyle(color: primaryColor, fontSize: 22, fontWeight: FontWeight.w400)),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
