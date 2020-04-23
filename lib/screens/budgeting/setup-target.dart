import 'dart:math';

import 'package:areix/components/outline-round-button.dart';
import 'package:areix/models/category.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:areix/screens/common.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class SetupTargetPage extends StatefulWidget {
  SetupTargetPage({Key key}) : super(key: key);

  _SetupTargetPageState createState() => _SetupTargetPageState();
}

class _SetupTargetPageState extends State<SetupTargetPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final styleController = TextEditingController();
  final purposeController = TextEditingController();
  final remarksController = TextEditingController();

  final amountFocus = FocusNode();
  final remarksFocus = FocusNode();

  DateTime _date = DateTime.now();
  bool _enableNext = false;

  @override
  void initState() {
    super.initState();

    amountController.text = 0.0.toStringAsFixed(2);
    amountController.addListener(canMoveNext);
    styleController.addListener(canMoveNext);
    purposeController.addListener(canMoveNext);
    remarksController.addListener(canMoveNext);
    dateController.text = DateFormat('yyyy MMM d').format(_date);
    styleController.text = 'Default';
  }

  @override
  void dispose() {
    amountController?.dispose();
    dateController?.dispose();
    styleController?.dispose();
    purposeController?.dispose();
    remarksController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Set up target',
      child: Form(
        key: _formKey,
        child: ListView(children: _formFields()),
      ),
    );
  }

  List<Widget> _formFields() {
    final _edit = Icon(Icons.edit, color: primaryColor, size: 20);

    return [
      // Amount
      SizedBox(height: 36),
      _row(
        label: 'Amount :',
        field: TextFormField(
          controller: amountController,
          focusNode: amountFocus,
          decoration: InputDecoration(border: InputBorder.none, suffixIcon: _edit),
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
      // Due date
      _row(
        label: 'Due date :',
        field: _select(
          controller: dateController,
          onTap: _onDateAction,
        ),
      ),
      // style
      _row(
        label: 'Saving style :',
        field: _select(
          controller: styleController,
          onTap: _onStyleAction,
        ),
      ),
      // purpose
      _row(
        label: 'Purpose :',
        field: _select(
          controller: purposeController,
          onTap: _onPurposeAction,
        ),
      ),
      // remarks
      _row(
        label: 'Remarks :',
        field: TextFormField(
          controller: remarksController,
          focusNode: remarksFocus,
          decoration: InputDecoration(border: InputBorder.none, suffixIcon: _edit),
          textAlign: TextAlign.end,
          keyboardType: TextInputType.text,
          style: const TextStyle(color: primaryColor),
          onEditingComplete: () => remarksFocus.unfocus(),
        ),
      ),
      // separator
      SizedBox(height: 48),
      // buttons
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(children: [
          Expanded(
            child: OutlineRoundButton(
              title: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            child: OutlineRoundButton(
              title: 'Next',
              enabled: _enableNext,
              fill: true,
              onPressed: () => navigate(context, '/budgeting/setup-target/preview'),
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
            width: 120,
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

  void _onDateAction() {
    final _r = TextStyle(color: Colors.black, fontWeight: FontWeight.w400);
    DateTime _current = _date;

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
                      _date = _current;
                      dateController.text = DateFormat('yyyy MMM d').format(_date);
                    });
                  },
                ),
              ]),
            ),
            // picker
            Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: CupertinoDatePicker(
                initialDateTime: _current,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (date) {
                  _current = date;
                },
              ),
            )
          ],
        );
      },
    );
  }

  void _onStyleAction() {
    final _styles = ['Default', 'Progressive', 'Regressive'];
    final int _index = max(0, _styles.indexOf(styleController.text));
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: _index);

    final _r = TextStyle(color: Colors.black, fontWeight: FontWeight.w400);
    String _style = _styles[_index];

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
                      styleController.text = _style;
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
                children: _styles.map((item) => Text(item)).toList(),
                onSelectedItemChanged: (i) => _style = _styles[i],
              ),
            ),
          ],
        );
      },
    );
  }

  void _onPurposeAction() {
    final _purposes = RptCategoryType.values.map((x) => RptCategory.of(x).name).toList();
    final int _index = max(0, _purposes.indexOf(purposeController.text));
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: _index);

    final _r = TextStyle(color: Colors.black, fontWeight: FontWeight.w400);
    String _purpose = _purposes[_index];

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
                      purposeController.text = _purpose;
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
                children: _purposes.map((item) => Text(item)).toList(),
                onSelectedItemChanged: (i) => _purpose = _purposes[i],
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
      _enableNext = amount > 0 && styleController.text.isNotEmpty && purposeController.text.isNotEmpty && remarksController.text.isNotEmpty;
    });
  }
}
