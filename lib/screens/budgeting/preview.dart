import 'package:areix/components/outline-round-button.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Set up target',
      child: Container(
        margin: const EdgeInsets.only(top: 36, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // preview text
            Text('Preview', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
            // box
            _box(),
            // button
            SizedBox(height: 36),
            _buttons(context),
          ],
        ),
      ),
    );
  }

  Widget _box() {
    final _xl = const TextStyle(color: primaryColor, fontSize: 36, fontWeight: FontWeight.w500);
    final _r = const TextStyle(fontWeight: FontWeight.w400);

    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/bg_cell_x.png'), fit: BoxFit.fill),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text('Difficulty index :', style: _r)),
            SizedBox(width: 8),
            Text('5', style: const TextStyle(color: accentColor, fontSize: 22, fontWeight: FontWeight.w400)),
          ]),
          SizedBox(height: 24),
          Text('Monthly budget change :', style: _r),
          SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('\$0', style: _xl),
                SizedBox(width: 48, child: Icon(Icons.arrow_right, size: 36, color: primaryColor)),
                Text('\$50', style: _xl),
              ],
            ),
          ),
          SizedBox(height: 24),
          Row(children: [
            Expanded(child: Text('Wealth growth in due date :', style: _r)),
            Icon(Icons.arrow_drop_up, size: 36, color: primaryColor),
            Text('18%', style: const TextStyle(color: primaryColor, fontSize: 22, fontWeight: FontWeight.w400)),
          ]),
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: OutlineRoundButton(
          title: 'Back',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      SizedBox(width: 24),
      Expanded(
        flex: 1,
        child: OutlineRoundButton(
          title: 'Confirm',
          fill: true,
          onPressed: () => popTo(context, '/budgeting'),
        ),
      ),
    ]);
  }
}
