import 'package:flutter/foundation.dart';

class RptCoupon {
  final String imageUrl;
  final String qrCode;
  final DateTime expiredAt;
  final String description;

  RptCoupon({
    @required this.imageUrl,
    @required this.qrCode,
    @required this.expiredAt,
    @required this.description,
  });
}
