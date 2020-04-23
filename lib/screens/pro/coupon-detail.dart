import 'package:areix/models/coupon.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/utils/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CouponDetailPage extends StatefulWidget {
  CouponDetailPage({Key key}) : super(key: key);

  _CouponDetailPageState createState() => _CouponDetailPageState();
}

class _CouponDetailPageState extends State<CouponDetailPage> {
  final _ratio = 850 / (850 + 500);

  bool _enableLeft = false;
  bool _enableRight = false;

  int _selectedIndex = -1;
  List<RptCoupon> _coupons = [];

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex < 0) {
      final CouponDetailArguments arg = ModalRoute.of(context).settings.arguments;
      _selectedIndex = arg.selectedIndex;
      _coupons = arg.list;
      _enableLeft = _selectedIndex > 0;
      _enableRight = _selectedIndex < _coupons.length - 1;
    }

    final _slider = _carousel();

    return CommonPage(
      title: 'Coupon',
      isAppBarTransparent: true,
      padding: const EdgeInsets.only(top: 86),
      child: Stack(overflow: Overflow.visible, children: [
        // Background
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
        // Carousel
        Positioned.fill(child: _slider),
        // Left arrow
        Align(
          alignment: Alignment.centerLeft,
          child: CupertinoButton(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/ic_left.png',
              width: 32,
              height: 64,
              fit: BoxFit.fill,
              color: _enableLeft ? Colors.white : Colors.white.withOpacity(0.5),
            ),
            onPressed: _enableLeft
                ? () {
                    _slider.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                    _selectedIndex -= 1;
                    setState(() {
                      _enableLeft = _selectedIndex > 0;
                      _enableRight = _selectedIndex < _coupons.length - 1;
                    });
                  }
                : null,
          ),
        ),
        // Right arrow
        Align(
          alignment: Alignment.centerRight,
          child: CupertinoButton(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/ic_right.png',
              width: 32,
              height: 64,
              fit: BoxFit.fill,
              color: _enableRight ? Colors.white : Colors.white.withOpacity(0.5),
            ),
            onPressed: _enableRight
                ? () {
                    _slider.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                    _selectedIndex += 1;
                    setState(() {
                      _enableLeft = _selectedIndex > 0;
                      _enableRight = _selectedIndex < _coupons.length - 1;
                    });
                  }
                : null,
          ),
        ),
        // Top bar
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: Container(
            height: 2,
            color: lightColor.withOpacity(0.5),
          ),
        )
      ]),
    );
  }

  CarouselSlider _carousel() {
    return CarouselSlider(
      autoPlay: false,
      aspectRatio: MediaQuery.of(context).size.aspectRatio,
      viewportFraction: 1.0,
      enableInfiniteScroll: false,
      initialPage: _selectedIndex,
      items: _coupons.map(_card).toList(),
    );
  }

  Widget _card(RptCoupon coupon) {
    return LayoutBuilder(builder: (context, constraint) {
      final h = constraint.maxHeight - 96;
      final w = h * _ratio;

      return Center(
        child: SizedBox(
          width: w,
          height: h,
          child: FlipCard(
            front: _front(coupon, w),
            back: _back(coupon),
          ),
        ),
      );
    });
  }

  Widget _front(RptCoupon coupon, double width) {
    return Stack(children: <Widget>[
      Positioned.fill(
        child: Image.asset('assets/bg_card_light.png', fit: BoxFit.fill),
      ),
      Positioned(
        top: 1,
        left: 1,
        right: 1,
        bottom: 1,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          // Card image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              constraints: BoxConstraints.expand(height: width * _ratio),
              child: Image.asset('assets/${coupon.imageUrl}', fit: BoxFit.fill),
            ),
          ),
          // qrCode
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(36),
              child: Image.asset('assets/${coupon.qrCode}', fit: BoxFit.contain),
            ),
          ),
          // Expire date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: RichText(
              text: TextSpan(
                text: 'Expiry date: ',
                style: const TextStyle(color: Color(0xFF011D24), fontSize: 13),
                children: [
                  TextSpan(
                    text: DateFormat('yyyy MMM d').format(coupon.expiredAt),
                    style: const TextStyle(color: accentColor, fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _back(RptCoupon coupon) {
    return Stack(children: <Widget>[
      Positioned.fill(
        child: Image.asset('assets/bg_card_dark.png', fit: BoxFit.fill),
      ),
      Positioned.fill(
        top: 32,
        bottom: 36,
        left: 24,
        right: 24,
        child: SingleChildScrollView(
          child: Text(
            coupon.description,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    ]);
  }
}

class CouponDetailArguments {
  final int selectedIndex;
  final List<RptCoupon> list;

  CouponDetailArguments(this.selectedIndex, this.list);
}
