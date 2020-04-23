import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void goToPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (BuildContext context) => page),
  );
}

void navigate(BuildContext context, String route, {dynamic params}) {
  Navigator.of(context).pushNamed(route, arguments: params);
}

void popTo(BuildContext context, String route) {
  Navigator.of(context).popUntil((r) {
    return r.isFirst || r.settings.name == route;
  });
}

void popToRoot(BuildContext context) {
  Navigator.of(context).popUntil((route) {
    return route.isFirst;
  });
}

class Store {
  static void setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future setStringList(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  static Future<List<String>> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

String currency(dynamic number, {int fixed = 2, bool optimized = false}) {
  final formatter = optimized
      ? NumberFormat.compactCurrency(symbol: "\$", decimalDigits: 1)
      : NumberFormat.currency(symbol: "\$", decimalDigits: fixed);
  return formatter.format(number);
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
