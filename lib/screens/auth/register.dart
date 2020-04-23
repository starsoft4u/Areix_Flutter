import 'dart:math';

import 'package:areix/components/outline-round-button.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final titleController = TextEditingController();
  final surnameController = TextEditingController();
  final firstnameController = TextEditingController();
  final passwordController = TextEditingController();
  final codeController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    titleController.dispose();
    surnameController.dispose();
    firstnameController.dispose();
    passwordController.dispose();
    codeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _edit = Icon(Icons.edit, color: primaryColor, size: 20);

    return CommonPage(
      hasFloatButton: false,
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          SizedBox(height: 36),
          Image.asset('assets/logo_x.png', width: 80, height: 80, fit: BoxFit.contain),
          SizedBox(height: 36),
          _row(
            label: 'Email :',
            field: TextFormField(
              controller: emailController,
              decoration: InputDecoration(border: InputBorder.none, suffixIcon: _edit),
              textAlign: TextAlign.end,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w300),
            ),
          ),
          _row(
            label: 'Title :',
            field: _select(
              controller: titleController,
              onTap: _onTitleAction,
            ),
          ),
          _row(
            label: 'Surname :',
            field: TextFormField(
              controller: surnameController,
              decoration: InputDecoration(border: InputBorder.none, suffixIcon: _edit),
              textAlign: TextAlign.end,
              style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w300),
            ),
          ),
          _row(
            label: 'First name :',
            field: TextFormField(
              controller: firstnameController,
              decoration: InputDecoration(border: InputBorder.none, suffixIcon: _edit),
              textAlign: TextAlign.end,
              style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w300),
            ),
          ),
          _row(
            label: 'Password :',
            field: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(border: InputBorder.none, suffixIcon: _edit),
              textAlign: TextAlign.end,
              obscureText: true,
              style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w300),
            ),
          ),
          _row(
            label: 'Promotional / Offer code :',
            field: TextFormField(
              controller: codeController,
              decoration: InputDecoration(border: InputBorder.none, suffixIcon: _edit),
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(height: 16),
          OutlineRoundButton(
            title: 'Register',
            width: 180,
            fill: true,
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/home', (x) => !x.isCurrent),
          ),
          SizedBox(height: 36),
        ]),
      ),
    );
  }

  Widget _row({String label, Widget field}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
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

  void _onTitleAction() {
    final _titles = ['Mr', 'Mrs'];
    final int _index = max(0, _titles.indexOf(titleController.text));
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: _index);

    final _r = TextStyle(color: Colors.black, fontWeight: FontWeight.w400);
    String _title = _titles[_index];

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
                      titleController.text = _title;
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
                children: _titles.map((item) => Text(item)).toList(),
                onSelectedItemChanged: (i) => _title = _titles[i],
              ),
            ),
          ],
        );
      },
    );
  }
}
