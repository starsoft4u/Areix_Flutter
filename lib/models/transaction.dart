// To parse this JSON data, do
//
//     final transaction = transactionFromJson(jsonString);

import 'dart:convert';

import 'package:areix/models/category.dart';
import 'package:intl/intl.dart';

Transaction transactionFromJson(String str) => Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

class Transaction {
  RptCategory category;
  double amount;
  List<TransactionItem> transactions;

  Transaction({
    this.category,
    this.amount,
    this.transactions,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        category: RptCategory.of(categoryTypeValues.map[json["category"]]),
        amount: json["amount"].toDouble(),
        transactions: List<TransactionItem>.from(json["transactions"].map((x) => TransactionItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": categoryTypeValues.reverse[category.type],
        "amount": amount,
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
      };
}

class TransactionItem {
  String description;
  double amount;
  DateTime madeOn;
  String category;

  TransactionItem({
    this.description,
    this.amount,
    this.madeOn,
    this.category,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) => TransactionItem(
        description: json["description"],
        amount: json["amount"].toDouble(),
        madeOn: DateTime.parse(json["made_on"]),
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "amount": amount,
        "made_on": DateFormat('yyyy-MM-dd').format(madeOn),
        "category": category,
      };
}
