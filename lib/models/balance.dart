// To parse this JSON data, do
//
//     final balance = balanceFromJson(jsonString);

import 'dart:convert';

Balance balanceFromJson(String str) => Balance.fromJson(json.decode(str));

String balanceToJson(Balance data) => json.encode(data.toJson());

class Balance {
  double balance;
  String currencyCode;
  String id;
  String loginId;
  String name;
  String nature;

  Balance({
    this.balance,
    this.currencyCode,
    this.id,
    this.loginId,
    this.name,
    this.nature,
  });

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        balance: json["balance"].toDouble(),
        currencyCode: json["currency_code"],
        id: json["id"],
        loginId: json["login_id"],
        name: json["name"],
        nature: json["nature"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "currency_code": currencyCode,
        "id": id,
        "login_id": loginId,
        "name": name,
        "nature": nature,
      };
}
