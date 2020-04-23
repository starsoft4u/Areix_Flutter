import 'package:areix/components/credit-card-form.dart';
import 'package:areix/components/outline-round-button.dart';
import 'package:areix/screens/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _cardHolderName = '';
  String _cardNumber = '';
  String _expiryDate = '';
  String _cvvCode = '';
  bool _isCVVFocused = false;
  bool _isValidate = false;

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Credit Card Details',
      child: Column(children: <Widget>[
        CreditCardWidget(
          cardHolderName: _cardHolderName,
          cardNumber: _cardNumber,
          expiryDate: _expiryDate,
          cvvCode: _cvvCode,
          showBackView: _isCVVFocused,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              CreditCardForm(
                cardNumber: _cardNumber,
                expiryDate: _expiryDate,
                cvvCode: _cvvCode,
                cardHolderName: _cardHolderName,
                onCreditCardModelChange: _onCreditCardModelChange,
              ),
              SizedBox(height: 8),
              OutlineRoundButton(
                title: 'Confirm',
                width: 120,
                fill: _isValidate ? true : false,
                onPressed: _isValidate ? () => {} : null,
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  void _onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      _cardNumber = creditCardModel.cardNumber;
      _expiryDate = creditCardModel.expiryDate;
      _cardHolderName = creditCardModel.cardHolderName;
      _cvvCode = creditCardModel.cvvCode;
      _isCVVFocused = creditCardModel.isCvvFocused;
      _isValidate =
          _cardNumber.isNotEmpty && _expiryDate.isNotEmpty && _cardHolderName.isNotEmpty && _cvvCode.isNotEmpty;
    });
  }
}
