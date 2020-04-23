import 'package:areix/components/outline-round-button.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/screens/pro/products.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({Key key}) : super(key: key);

  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String title;
  Product product;

  @override
  Widget build(BuildContext context) {
    ProductDetailArguments arg = ModalRoute.of(context).settings.arguments;
    title = arg.title;
    product = arg.product;

    final _s = TextStyle(fontSize: 13);
    final _sn = TextStyle(color: primaryColor, fontSize: 24, fontWeight: FontWeight.w400);

    return CommonPage(
      title: title,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _product(),
          // Additional income
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text('Additional income :', style: const TextStyle(fontWeight: FontWeight.w400)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Guaranteed', style: _s),
                    Row(children: [
                      Icon(Icons.arrow_drop_up, color: primaryColor, size: 36),
                      Text('\$10,000', style: _sn)
                    ]),
                    SizedBox(height: 8),
                    Text('Divident', style: _s),
                    Row(children: [
                      Icon(Icons.arrow_drop_up, color: primaryColor, size: 36),
                      Text('\$10,000', style: _sn)
                    ]),
                  ],
                ),
              ],
            ),
          ),
          // Growth rate
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(children: [
              Expanded(
                child: Text('Growth rate :', style: const TextStyle(fontWeight: FontWeight.w400)),
              ),
              Row(children: [Icon(Icons.arrow_drop_up, color: primaryColor, size: 36), Text('5.25%', style: _sn)]),
            ]),
          ),
          // Time to complete
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text('Time to complete saving goal :', style: const TextStyle(fontWeight: FontWeight.w400)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(children: [
                      Text('10%', style: _sn),
                      Text(' faster'),
                    ]),
                    Row(children: [
                      Text('10.5%', style: _sn),
                      SizedBox(width: 4),
                      Text(' days faster'),
                    ]),
                  ],
                ),
              ],
            ),
          ),
          // Button
          Center(
            child: OutlineRoundButton(
              title: 'Next',
              width: 140,
              fill: true,
              onPressed: () => navigate(context, '/pro/result', params: title),
            ),
          ),
        ],
      ),
    );
  }

  Widget _product() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/bg_cell_clip.png'), fit: BoxFit.fill),
      ),
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(product.imageUrl, width: 32, height: 32, fit: BoxFit.contain),
            SizedBox(width: 8),
            Text(product.name, style: const TextStyle(fontSize: 22)),
          ],
        ),
        SizedBox(height: 8),
        Text(product.plan, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400))
      ]),
    );
  }
}

class ProductDetailArguments {
  final String title;
  final Product product;

  ProductDetailArguments(this.title, this.product);
}
