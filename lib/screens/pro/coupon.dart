import 'package:areix/models/coupon.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/screens/pro/coupon-detail.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class CouponPage extends StatefulWidget {
  CouponPage({Key key}) : super(key: key);

  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  int _myCouponIndex = 0;
  int _nextCouponIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width - 80;
    final cardHeight = cardWidth * 500 / 840;
    final cardFraction = (cardWidth - 4) / width;

    return CommonPage(
      title: 'Coupon',
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          SizedBox(height: 32),
          // My coupons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text('My Coupons', style: const TextStyle(fontSize: 20)),
          ),
          // Carousel
          SizedBox(
            height: cardHeight + 24 + 8,
            child: _bg(
              Positioned.fill(
                bottom: 24,
                child: _myCouponCarousel(cardHeight, cardFraction),
              ),
            ),
          ),
          SizedBox(height: 32),
          // Next coupons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text('Next Coupons', style: const TextStyle(fontSize: 20)),
          ),
          // Carousel
          SizedBox(
            height: cardHeight + 8,
            child: _nextCouponCarousel(cardHeight, cardFraction),
          ),
        ]),
      ),
    );
  }

  Widget _myCouponCarousel(double height, double fraction) {
    return CarouselSlider(
      autoPlay: false,
      height: height,
      viewportFraction: fraction,
      items: _myCoupons
          .asMap()
          .map((index, item) {
            return MapEntry(index, _card(item.imageUrl, true, index == _myCouponIndex));
          })
          .values
          .toList(),
      onPageChanged: (index) {
        setState(() {
          _myCouponIndex = index;
        });
      },
    );
  }

  Widget _nextCouponCarousel(double height, double fraction) {
    return CarouselSlider(
      autoPlay: false,
      height: height,
      viewportFraction: fraction,
      enableInfiniteScroll: false,
      items: _nextCoupons
          .asMap()
          .map((index, item) {
            return MapEntry(index, _card(item, false, index == _nextCouponIndex));
          })
          .values
          .toList(),
      onPageChanged: (index) {
        setState(() {
          _nextCouponIndex = index;
        });
      },
    );
  }

  Widget _card(String item, bool isMyCoupon, bool selected) {
    final opacity = selected ? 1.0 : 0.5;
    final margin = selected
        ? const EdgeInsets.symmetric(horizontal: 4, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 4, vertical: 16);

    var children = <Widget>[
      Positioned.fill(
        child: Image.asset('assets/$item', fit: BoxFit.fill),
      ),
    ];
    if (!isMyCoupon) {
      children.add(Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.share, color: Colors.white, size: 36),
              SizedBox(height: 16),
              Text('Unlock by share Areix'),
            ],
          ),
        ),
      ));
    }

    return GestureDetector(
      onTap: () {
        if (selected) {
          if (isMyCoupon) {
            // coupon detail
            InterstitialAd(adUnitId: InterstitialAd.testAdUnitId, targetingInfo: MobileAdTargetingInfo())
              ..load()
              ..show();
            navigate(context, '/coupon/detail', params: CouponDetailArguments(_myCouponIndex, _myCoupons));
          } else {
            // share
            Share.share("Here's the Areix app link: ....");
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: margin,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: opacity,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: lightColor, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(children: children),
          ),
        ),
      ),
    );
  }

  Widget _bg(Widget child) {
    return Stack(overflow: Overflow.visible, children: [
      Positioned.fill(
        left: 16,
        right: 16,
        child: Image.asset('assets/bg_coupon.png', fit: BoxFit.fill),
      ),
      Positioned(
        left: 16,
        right: 16,
        bottom: -8,
        child: Image.asset('assets/neon.png', fit: BoxFit.contain, height: 16),
      ),
      child,
    ]);
  }

  final _myCoupons = [
    RptCoupon(
      imageUrl: "fake/c_spotify.png",
      qrCode: "fake/qr_code.png",
      expiredAt: DateTime.now(),
      description:
          "Welcome\n\nWelcome to the Android developer guides. The documents listed in the left navigation teach you how to build Android apps using APIs in the Android framework and other libraries.",
    ),
    RptCoupon(
      imageUrl: "fake/c_apple.png",
      qrCode: "fake/qr_code.png",
      expiredAt: DateTime.now(),
      description:
          "Welcome\n\nWelcome to the Android developer guides. The documents listed in the left navigation teach you how to build Android apps using APIs in the Android framework and other libraries.",
    ),
    RptCoupon(
      imageUrl: "fake/c_netflix.png",
      qrCode: "fake/qr_code.png",
      expiredAt: DateTime.now(),
      description:
          "Welcome\n\nWelcome to the Android developer guides. The documents listed in the left navigation teach you how to build Android apps using APIs in the Android framework and other libraries.",
    ),
  ];
  final _nextCoupons = [
    "fake/c_next.png",
    "fake/c_next.png",
    "fake/c_next.png",
  ];
}
