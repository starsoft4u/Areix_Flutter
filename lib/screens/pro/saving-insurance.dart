import 'package:areix/components/outline-round-button.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavingInsurancePage extends StatefulWidget {
  SavingInsurancePage({Key key}) : super(key: key);

  _SavingInsurancePageState createState() => _SavingInsurancePageState();
}

class _SavingInsurancePageState extends State<SavingInsurancePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final amountController = TextEditingController();
  final currencyController = TextEditingController();
  final periodController = TextEditingController();

  final amountFocus = FocusNode();
  bool _enableNext = false;

  @override
  void initState() {
    super.initState();

    amountController.text = 0.0.toStringAsFixed(2);
    currencyController.text = _currencies[1];
    periodController.text = _periods[2];

    amountController.addListener(canMoveNext);
  }

  @override
  void dispose() {
    amountController?.dispose();
    currencyController?.dispose();
    periodController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Saving Insurance',
      child: Form(
        key: _formKey,
        child: ListView(children: _formFields()),
      ),
    );
  }

  List<Widget> _formFields() {
    return [
      // Amount
      SizedBox(height: 36),
      _row(
        label: 'Amount to grow :',
        field: TextFormField(
          controller: amountController,
          focusNode: amountFocus,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: Icon(Icons.edit, color: primaryColor, size: 20),
          ),
          textAlign: TextAlign.end,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w300),
          onEditingComplete: () {
            double amount = double.tryParse(amountController.text) ?? 0;
            amountController.text = amount.toStringAsFixed(2);
            amountFocus.unfocus();
          },
        ),
      ),
      // Currency
      _row(
        label: 'Currency :',
        field: _select(controller: currencyController, onTap: _onCurrencyAction),
      ),
      // Period
      _row(
        label: 'Period :',
        field: _select(controller: periodController, onTap: _onPeriodAction),
      ),
      // separator
      SizedBox(height: 48),
      // buttons
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(children: [
          Expanded(
            flex: 1,
            child: OutlineRoundButton(
              title: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            flex: 1,
            child: OutlineRoundButton(
              title: 'Next',
              enabled: _enableNext,
              fill: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ]),
      ),
      SizedBox(height: 36),
    ];
  }

  Widget _row({String label, Widget field}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            width: 135,
            child: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
          ),
          SizedBox(width: 16),
          Expanded(child: field),
        ],
      ),
    );
  }

  Widget _select({TextEditingController controller, VoidCallback onTap}) {
    final _down = Icon(Icons.keyboard_arrow_down, color: primaryColor, size: 20);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: IgnorePointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(border: InputBorder.none, suffixIcon: _down),
            textAlign: TextAlign.end,
            style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w300),
            enabled: false,
          ),
        ),
      ),
    );
  }

  void _onCurrencyAction() {
    int _index = _currencies.indexOf(currencyController.text);
    if (_index < 0) {
      _index = 1;
    }
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: _index);

    final _r = TextStyle(color: Colors.black, fontWeight: FontWeight.w400);
    String _currency = _currencies[_index];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // buttons
            Container(
              color: Colors.grey[200],
              child: Row(children: [
                MaterialButton(
                  padding: const EdgeInsets.all(8),
                  child: Text('Cancel', style: _r),
                  hoverColor: Colors.grey,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(child: Container()),
                MaterialButton(
                  padding: const EdgeInsets.all(8),
                  child: Text('Select', style: _r),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      currencyController.text = _currency;
                    });
                  },
                ),
              ]),
            ),
            // picker
            Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: CupertinoPicker(
                scrollController: scrollController,
                itemExtent: 36,
                children: _currencies.map((item) => Text(item)).toList(),
                onSelectedItemChanged: (i) => _currency = _currencies[i],
              ),
            ),
          ],
        );
      },
    );
  }

  void _onPeriodAction() {
    int _index = _periods.indexOf(periodController.text);
    if (_index < 0) {
      _index = 2;
    }
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: _index);

    final _r = TextStyle(color: Colors.black, fontWeight: FontWeight.w400);
    String _period = _periods[_index];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // buttons
            Container(
              color: Colors.grey[200],
              child: Row(children: [
                MaterialButton(
                  padding: const EdgeInsets.all(8),
                  child: Text('Cancel', style: _r),
                  hoverColor: Colors.grey,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(child: Container()),
                MaterialButton(
                  padding: const EdgeInsets.all(8),
                  child: Text('Select', style: _r),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      periodController.text = _period;
                    });
                  },
                ),
              ]),
            ),
            // picker
            Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: CupertinoPicker(
                scrollController: scrollController,
                itemExtent: 36,
                children: _periods.map((item) => Text(item)).toList(),
                onSelectedItemChanged: (i) => _period = _periods[i],
              ),
            ),
          ],
        );
      },
    );
  }

  void canMoveNext() {
    setState(() {
      double amount = double.tryParse(amountController.text) ?? 0.0;
      _enableNext = amount > 0;
    });
  }

  List<String> _currencies = ['USD', 'HKD', 'GBP', 'CNY', 'RUB'];
  List<String> _periods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
}
