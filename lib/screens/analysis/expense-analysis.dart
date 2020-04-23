import '../common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:areix/components/outline-round-button.dart';
import 'package:areix/utils/utils.dart';

class ExpenseAnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Expense Analysis',
      expandBottom: true,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlineRoundButton(
              title: 'Trend',
              width: 240,
              onPressed: () => navigate(context, '/analysis/trend'),
            ),
            OutlineRoundButton(
              title: 'Categorical Chart',
              margin: const EdgeInsets.symmetric(vertical: 16),
              width: 240,
              onPressed: () => navigate(context, '/analysis/categorial-chart'),
            ),
            OutlineRoundButton(
              title: 'Statement',
              width: 240,
              onPressed: () => navigate(context, '/analysis/statement'),
            ),
          ],
        ),
      ),
    );
  }
}
