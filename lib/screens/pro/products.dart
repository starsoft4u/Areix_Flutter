import 'package:areix/screens/common.dart';
import 'package:areix/screens/pro/product-detail.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _title = '';

  @override
  Widget build(BuildContext context) {
    _title = ModalRoute.of(context).settings.arguments;
    final nextPage = _title == "Deposit" ? '/pro/deposit' : '/pro/saving-insurance';

    return CommonPage(
      title: _title,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit, color: primaryColor),
          onPressed: () => navigate(context, nextPage),
        )
      ],
      child: ListView.builder(
        itemBuilder: _listItem,
        itemCount: _data.isNotEmpty ? _data.length + 2 : 0,
      ),
    );
  }

  Widget _listItem(BuildContext context, int index) {
    if (index == 0 || index > _data.length) {
      return SizedBox(height: 24);
    }

    final item = _data[index - 1];

    final _s = TextStyle(fontSize: 13);
    final _sc = TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w400);

    return GestureDetector(
      onTap: () => navigate(context, '/pro/products/detail', params: ProductDetailArguments(_title, item)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/bg_cell.png'), fit: BoxFit.fill),
        ),
        child: Column(children: [
          Row(children: [
            Image.asset(item.imageUrl, width: 32, height: 32, fit: BoxFit.contain),
            SizedBox(width: 8),
            Text(item.name, style: const TextStyle(fontSize: 19)),
            SizedBox(width: 24),
            Expanded(
              child: Text(item.plan, style: const TextStyle(fontWeight: FontWeight.w400)),
            ),
          ]),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Text('Guaranteed return', style: _s),
                Text('${item.guaranteed.toStringAsFixed(1)}%', style: _sc),
              ]),
              Column(children: [
                Text('Dividend rate', style: _s),
                Text('${item.dividen.toStringAsFixed(1)}%', style: _sc),
              ]),
              Column(children: [
                Text('XXXXXX dividend rate', style: _s),
                Text('${item.xDividen.toStringAsFixed(1)}%', style: _sc),
              ]),
            ],
          ),
        ]),
      ),
    );
  }

  final List<Product> _data = [
    Product(
        imageUrl: 'assets/fake/product_aia.png',
        name: 'AIA',
        plan: '5 year Plan A',
        guaranteed: 1.5,
        dividen: 1.5,
        xDividen: 1.5),
    Product(
        imageUrl: 'assets/fake/product_aia.png',
        name: 'AIA',
        plan: '7 year Plan A',
        guaranteed: 3.5,
        dividen: 2,
        xDividen: 1.5),
    Product(
        imageUrl: 'assets/fake/product_ftlife.png',
        name: 'FTLife',
        plan: '3 year Plan A',
        guaranteed: 3.5,
        dividen: 2,
        xDividen: 1.5),
    Product(
        imageUrl: 'assets/fake/product_ftlife.png',
        name: 'FTLife',
        plan: '5 year Plan A',
        guaranteed: 3.5,
        dividen: 2,
        xDividen: 1.5),
    Product(
        imageUrl: 'assets/fake/product_ftlife.png',
        name: 'FTLife',
        plan: '10 year Plan A',
        guaranteed: 3.5,
        dividen: 2,
        xDividen: 1.5),
    Product(
        imageUrl: 'assets/fake/product_prudential.png',
        name: 'Prudential',
        plan: '5 year Plan A',
        guaranteed: 1.5,
        dividen: 1.5,
        xDividen: 1.5),
    Product(
        imageUrl: 'assets/fake/product_prudential.png',
        name: 'Prudential',
        plan: '3 year Plan A',
        guaranteed: 3.5,
        dividen: 2.5,
        xDividen: 1.5),
  ];
}

class Product {
  final String imageUrl;
  final String name;
  final String plan;
  final double guaranteed;
  final double dividen;
  final double xDividen;

  Product({
    this.imageUrl,
    this.name,
    this.plan,
    this.guaranteed = 0.0,
    this.dividen = 0.0,
    this.xDividen = 0.0,
  });
}
