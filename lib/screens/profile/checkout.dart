import 'package:areix/components/outline-round-button.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/screens/profile/subscription.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isValidate = false;
  Offer _offer;
  int _selectedPaymentIndex = -1;

  @override
  Widget build(BuildContext context) {
    _offer = ModalRoute.of(context).settings.arguments;

    return CommonPage(
      title: 'Check out',
      child: Column(children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/bg_cell_clip.png'), fit: BoxFit.fill),
          ),
          child: Column(children: [
            Text(
              '${_offer.month} month${_offer.month == 1 ? '' : 's'}',
              style: const TextStyle(
                color: primaryColor,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Prestige Subscription Package',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
            ),
          ]),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(children: <Widget>[
            Expanded(child: Text('Total:')),
            Text(
              '${currency(_offer.price, fixed: 2)}',
              style: const TextStyle(color: primaryColor, fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ]),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(children: <Widget>[
            Expanded(child: Text('Referral code:')),
            Text(
              'REFER0123',
              style: const TextStyle(color: primaryColor),
            ),
          ]),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Select payment method', style: const TextStyle(fontSize: 15)),
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPaymentIndex = 0;
                  _isValidate = true;
                });
              },
              child: Opacity(
                opacity: _selectedPaymentIndex == -1 || _selectedPaymentIndex == 0 ? 1.0 : 0.5,
                child: Image.asset('assets/pay_fps.png'),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPaymentIndex = 1;
                  _isValidate = true;
                });
              },
              child: Opacity(
                opacity: _selectedPaymentIndex == -1 || _selectedPaymentIndex == 1 ? 1.0 : 0.5,
                child: Image.asset('assets/pay_visa.png'),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPaymentIndex = 2;
                  _isValidate = true;
                });
              },
              child: Opacity(
                opacity: _selectedPaymentIndex == -1 || _selectedPaymentIndex == 2 ? 1.0 : 0.5,
                child: Image.asset('assets/pay_mastercard.png'),
              ),
            ),
          ]),
        ),
        Expanded(child: Container()),
        OutlineRoundButton(
          title: 'Confirm',
          width: 120,
          fill: _isValidate ? true : false,
          onPressed: _isValidate ? () => navigate(context, '/profile/payment') : null,
        ),
        SizedBox(height: 24),
      ]),
    );
  }
}
