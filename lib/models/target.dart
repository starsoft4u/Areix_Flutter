import 'dart:math';

import 'package:areix/models/category.dart';
import 'package:flutter/foundation.dart';

class RptTarget {
  final RptCategory category;
  final double amount;
  final DateTime date;
  final String saving;
  final String remarks;
  final bool success;

  RptTarget({
    @required this.category,
    @required this.amount,
    @required this.date,
    this.saving = 'Default',
    @required this.remarks,
    this.success = true,
  });

  int get difficulty => min<int>(5, amount.toInt() ~/ 1000.0);
}
