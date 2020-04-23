import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';

enum RptCategoryType { shopping, financial, dining, other, groceries_and_rent, transport, entertainment }

final categoryTypeValues = EnumValues({
  'shopping': RptCategoryType.shopping,
  'financial': RptCategoryType.financial,
  'dining': RptCategoryType.dining,
  'other': RptCategoryType.other,
  'groceries_and_rent': RptCategoryType.groceries_and_rent,
  'transport': RptCategoryType.transport,
  'entertainment': RptCategoryType.entertainment
});

class RptCategory {
  final RptCategoryType type;
  final String name;
  final String image;
  final Color color;

  RptCategory({
    @required this.type,
    @required this.name,
    @required this.image,
    @required this.color,
  });

  bool equal(RptCategory other) => other != null && name == other.name;

  static RptCategory of(RptCategoryType type) {
    RptCategory category;

    switch (type) {
      case RptCategoryType.shopping:
        category = RptCategory(type: type, name: "Shopping", image: "assets/ic_shopping.svg", color: Color(0xFF1F6D6B));
        break;

      case RptCategoryType.financial:
        category =
            RptCategory(type: type, name: "Financial", image: "assets/ic_financial.svg", color: Color(0xFF5F9296));
        break;

      case RptCategoryType.dining:
        category =
            RptCategory(type: type, name: "Dining & Beverage", image: "assets/ic_food.svg", color: Color(0xFFFF7031));
        break;

      case RptCategoryType.other:
        category = RptCategory(type: type, name: "Others", image: "assets/ic_others.svg", color: Color(0xFF3F5150));
        break;

      case RptCategoryType.groceries_and_rent:
        category =
            RptCategory(type: type, name: "Groceries & Rent", image: "assets/ic_home.svg", color: Color(0xFF04ADA0));
        break;

      case RptCategoryType.transport:
        category =
            RptCategory(type: type, name: "Transport", image: "assets/ic_transport.svg", color: Color(0xFF00FFD8));
        break;

      case RptCategoryType.entertainment:
        category = RptCategory(
            type: type, name: "Entertainment", image: "assets/ic_entertainment.svg", color: Color(0xFF587575));
        break;
    }

    return category;
  }

  Widget rounded({double size = 32.0}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SvgPicture.asset(image, width: 25, height: 25),
      ),
    );
  }
}
