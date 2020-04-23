import 'package:areix/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    @required this.onCreditCardModelChange,
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;

  void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel creditCardModel;

  final MaskedTextController _cardNumberController = MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController = MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _cvvCodeController = MaskedTextController(mask: '0000');

  FocusNode _cardNumberFocusNode = FocusNode();
  FocusNode _expiryDateFocusNode = FocusNode();
  FocusNode _cardHolderNameFocusNode = FocusNode();
  FocusNode _cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = _cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    _cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cardHolderNameController.dispose();
    _cvvCodeController.dispose();

    _cardNumberFocusNode.dispose();
    _expiryDateFocusNode.dispose();
    _cardHolderNameFocusNode.dispose();
    _cvvFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(children: <Widget>[
        _row(
          label: 'Card number',
          controller: _cardNumberController,
          focusNode: _cardNumberFocusNode,
          placeHolder: 'xxxx xxxx xxxx xxxx',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),
        _row(
          label: 'Expired Date',
          controller: _expiryDateController,
          focusNode: _expiryDateFocusNode,
          placeHolder: 'MM/YY',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),
        _row(
          label: 'Card Holder',
          controller: _cardHolderNameController,
          focusNode: _cardHolderNameFocusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        _row(
          label: 'CVV',
          focusNode: _cvvFocusNode,
          controller: _cvvCodeController,
          placeHolder: 'XXX',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onChanged: (String text) {
            setState(() {
              cvvCode = text;
            });
          },
        ),
      ]),
    );
  }

  Widget _row({
    String label,
    FocusNode focusNode,
    TextEditingController controller,
    String placeHolder,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            width: 135,
            child: Text(label, style: const TextStyle(color: primaryColor, fontSize: 17, fontWeight: FontWeight.w400)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              focusNode: focusNode,
              controller: controller,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              cursorColor: Colors.white24,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.edit, color: Colors.white24, size: 20),
                  hintText: placeHolder,
                  hintStyle: const TextStyle(color: Colors.white24)),
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onChanged: onChanged,
              onFieldSubmitted: (term) {
                focusNode.unfocus();
                if (focusNode == _cardNumberFocusNode) {
                  FocusScope.of(context).requestFocus(_expiryDateFocusNode);
                } else if (focusNode == _expiryDateFocusNode) {
                  FocusScope.of(context).requestFocus(_cardHolderNameFocusNode);
                } else if (focusNode == _cardHolderNameFocusNode) {
                  FocusScope.of(context).requestFocus(_cvvFocusNode);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
