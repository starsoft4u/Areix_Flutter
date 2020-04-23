import 'package:areix/screens/account/account-detail.dart';
import 'package:areix/screens/account/account.dart';
import 'package:areix/screens/analysis/categorical-chart.dart';
import 'package:areix/screens/analysis/expense-analysis.dart';
import 'package:areix/screens/analysis/statement.dart';
import 'package:areix/screens/analysis/trend-more.dart';
import 'package:areix/screens/analysis/trend.dart';
import 'package:areix/screens/auth/login.dart';
import 'package:areix/screens/auth/register.dart';
import 'package:areix/screens/budgeting/budgeting.dart';
import 'package:areix/screens/budgeting/preview.dart';
import 'package:areix/screens/budgeting/remaining.dart';
import 'package:areix/screens/budgeting/setup-target.dart';
import 'package:areix/screens/budgeting/tracker.dart';
import 'package:areix/screens/dashboard.dart';
import 'package:areix/screens/home.dart';
import 'package:areix/screens/pro/areix-pro.dart';
import 'package:areix/screens/pro/card-detail.dart';
import 'package:areix/screens/pro/coupon-detail.dart';
import 'package:areix/screens/pro/coupon.dart';
import 'package:areix/screens/pro/credit-card.dart';
import 'package:areix/screens/pro/deposit.dart';
import 'package:areix/screens/pro/product-detail.dart';
import 'package:areix/screens/pro/products.dart';
import 'package:areix/screens/pro/result.dart';
import 'package:areix/screens/pro/saving-insurance.dart';
import 'package:areix/screens/profile/checkout.dart';
import 'package:areix/screens/profile/payment.dart';
import 'package:areix/screens/profile/profile.dart';
import 'package:areix/screens/profile/social-detail.dart';
import 'package:areix/screens/profile/social.dart';
import 'package:areix/screens/profile/subscription.dart';
import 'package:areix/utils/constants.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
//  debugPrintGestureArenaDiagnostics = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseAdMob.instance.initialize(appId: ADMOB_APP_ID);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/dashboard': (context) => DashboardPage(),
        '/analysis': (context) => ExpenseAnalysisPage(),
        '/analysis/trend': (context) => TrendPage(),
        '/analysis/trend/more': (context) => TrendMorePage(),
        '/analysis/categorial-chart': (context) => CategoricalChartPage(),
        '/analysis/statement': (context) => StatementPage(),
        '/account': (context) => AccountPage(),
        '/account/detail': (context) => AccountDetailPage(),
        '/budgeting': (context) => BudgetingPage(),
        '/budgeting/setup-target': (context) => SetupTargetPage(),
        '/budgeting/setup-target/preview': (context) => PreviewPage(),
        '/budgeting/remaining': (context) => RemainingPage(),
        '/budgeting/tracker': (context) => TrackerPage(),
        '/pro': (context) => AreixProPage(),
        '/pro/credit-card': (context) => CreditCardPage(),
        '/pro/credit-card/detail': (context) => CardDetailPage(),
        '/pro/saving-insurance': (context) => SavingInsurancePage(),
        '/pro/products': (context) => ProductsPage(),
        '/pro/products/detail': (context) => ProductDetailPage(),
        '/pro/deposit': (context) => DepositPage(),
        '/pro/result': (context) => ResultPage(),
        '/coupon': (context) => CouponPage(),
        '/coupon/detail': (context) => CouponDetailPage(),
        '/profile': (context) => ProfilePage(),
        '/profile/social': (context) => ProfileSocialPage(),
        '/profile/social/detail': (context) => ProfileSocialDetailPage(),
        '/profile/subscription': (context) => SubscriptionPage(),
        '/profile/checkout': (context) => CheckoutPage(),
        '/profile/payment': (context) => PaymentPage(),
      },
      title: 'Areix',
      theme: ThemeData(
        fontFamily: 'Roboto',
        backgroundColor: darkColor,
        textTheme: TextTheme(
          body1: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300),
          button: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
