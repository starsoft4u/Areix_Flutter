import 'package:areix/components/circle-button.dart';
import 'package:areix/components/gradient-button.dart';
import 'package:areix/components/outline-round-button.dart';
import 'package:areix/models/category.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';

class RemainingPage extends StatefulWidget {
  const RemainingPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RemainingPageState();
}

class _RemainingPageState extends State<RemainingPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    final Animation curve = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _animation = Tween(begin: 0.0, end: 1.0).animate(curve);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _btnStyle = TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400);

    return CommonPage(
      title: 'Remaining budget',
      child: SingleChildScrollView(
        child: Column(children: [
          // year select
          SizedBox(height: 16),
          Row(children: [
            IconButton(
              icon: Icon(Icons.arrow_left, size: 32),
              color: primaryColor,
              onPressed: () {},
            ),
            Text('2019 May', style: const TextStyle(color: primaryColor, fontSize: 22, fontWeight: FontWeight.w500)),
            IconButton(
              icon: Icon(Icons.arrow_right, size: 32),
              color: primaryColor,
              onPressed: () {},
            ),
            // setup target
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: OutlineRoundButton(
                  title: 'Set up target',
                  onPressed: () => navigate(context, '/budgeting/setup-target'),
                ),
              ),
            ),
            SizedBox(width: 16),
          ]),
          // W/M/Y
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Row(children: [
              Expanded(
                flex: 1,
                child: GradientButton(child: Text('Weekly', style: _btnStyle)),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: GradientButton(child: Text('Monthly', style: _btnStyle)),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: GradientButton(child: Text('Yearly', style: _btnStyle)),
              ),
            ]),
          ),
          // categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: LayoutBuilder(builder: (context, constraint) {
              return Wrap(
                alignment: WrapAlignment.center,
                children: _data.map((item) {
                  bool isDark = item.category.equal(RptCategory.of(RptCategoryType.dining));
                  Color color = isDark ? Color(0xFFF7601C) : primaryColor;
                  return ScaleTransition(
                    scale: _animation,
                    child: Container(
                      alignment: Alignment.center,
                      width: constraint.maxWidth / 2 - 16,
                      child: Column(children: [
                        Text(item.category.name),
                        SizedBox(height: 2),
                        CircleButton(
                          title: currency(item.value),
                          titleStyle: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w400),
                          size: 96,
                          dark: isDark,
                        ),
                        SizedBox(height: 16),
                      ]),
                    ),
                  );
                }).toList(),
              );
            }),
          ),
        ]),
      ),
    );
  }

  final _data = [
    RptCategoryData(category: RptCategory.of(RptCategoryType.entertainment), value: 856),
    RptCategoryData(category: RptCategory.of(RptCategoryType.shopping), value: 1001),
    RptCategoryData(category: RptCategory.of(RptCategoryType.dining), value: 2674),
    RptCategoryData(category: RptCategory.of(RptCategoryType.financial), value: 1439),
    RptCategoryData(category: RptCategory.of(RptCategoryType.transport), value: 600),
    RptCategoryData(category: RptCategory.of(RptCategoryType.groceries_and_rent), value: 1790),
    RptCategoryData(category: RptCategory.of(RptCategoryType.other), value: 640),
  ];
}

class RptCategoryData {
  final RptCategory category;
  final double value;

  RptCategoryData({
    @required this.category,
    @required this.value,
  });
}
