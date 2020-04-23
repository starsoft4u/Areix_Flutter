import 'dart:convert';

import 'package:intl/intl.dart';

CashFlow cashFlowFromJson(String str) => CashFlow.fromJson(json.decode(str));

String cashFlowToJson(CashFlow data) => json.encode(data.toJson());

class CashFlow {
  double income;
  double outcome;
  DateTime madeOn;

  CashFlow({
    this.income,
    this.outcome,
    this.madeOn,
  });

  factory CashFlow.fromJson(Map<String, dynamic> json) => CashFlow(
        income: double.parse(json["income"].toString()),
        outcome: double.parse(json["outcome"].toString()),
        madeOn: DateTime.parse(json["made_on"]),
      );

  Map<String, dynamic> toJson() => {
        "income": income,
        "outcome": outcome,
        "made_on": DateFormat('yyyy-MM-dd').format(madeOn),
      };
}
