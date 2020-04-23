import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:areix/components/outline-round-button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _edit = Icon(Icons.edit, color: primaryColor, size: 20);

    return CommonPage(
      hasFloatButton: false,
      isAppBarTransparent: true,
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 300,
            height: MediaQuery.of(context).size.height - 24,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/logo_x.png', width: 120, height: 120, fit: BoxFit.contain),
                ),
              ),
              SizedBox(height: 24),
              _row(
                label: 'Email :',
                field: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(border: InputBorder.none, suffixIcon: _edit),
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w300),
                ),
              ),
              _row(
                label: 'Password :',
                field: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(border: InputBorder.none, suffixIcon: _edit),
                  textAlign: TextAlign.end,
                  obscureText: true,
                  style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(height: 16),
              OutlineRoundButton(
                width: double.infinity,
                height: 40,
                title: 'Login',
                fill: true,
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/home', (x) => !x.isCurrent),
              ),
              SizedBox(height: 16),
              OutlineRoundButton(
                width: double.infinity,
                height: 40,
                title: 'Sign Up',
                onPressed: () => navigate(context, '/register'),
              ),
              SizedBox(height: 16),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(child: Container(height: 1, color: primaryColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('OR', style: const TextStyle(fontSize: 15)),
                ),
                Expanded(child: Container(height: 1, color: primaryColor)),
              ]),
              SizedBox(height: 24),
              Text('Sign in with Social Networks'),
              SizedBox(height: 24),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(children: [
                    Expanded(
                      child: OutlineRoundButton(
                        fill: true,
                        color: Color(0xFF48629C),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(FontAwesomeIcons.facebookF, color: Colors.white, size: 20),
                          SizedBox(width: 4),
                          Text('Facebook', style: const TextStyle(fontSize: 15, color: Colors.white)),
                        ]),
                        onPressed: facebookLogin,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: OutlineRoundButton(
                        fill: true,
                        color: Color(0xFFDB4B38),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(FontAwesomeIcons.google, color: Colors.white, size: 20),
                          SizedBox(width: 4),
                          Text('Google', style: const TextStyle(fontSize: 15, color: Colors.white)),
                        ]),
                        onPressed: googleLogin,
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _row({String label, Widget field}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
          ),
          SizedBox(width: 16),
          Expanded(child: field),
        ],
      ),
    );
  }

  Future facebookLogin() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphRequest =
            await http.get('https://graph.facebook.com/v2.12/me?fields=name,email,picture&access_token=$token');
        final profile = jsonDecode(graphRequest.body);

        final email = profile["email"];
        final name = profile["name"];
        final photoUrl = profile["picture"]["data"]["url"];

        print("Facebook login success! email = $email, name = $name, photoUrl = $photoUrl");

        Navigator.of(context).pushNamedAndRemoveUntil('/home', (x) => !x.isCurrent);
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;

      case FacebookLoginStatus.error:
        break;
    }
  }

  Future googleLogin() async {
    final googleSignIn = GoogleSignIn(scopes: ['email']);

    googleSignIn.onCurrentUserChanged.listen((account) {
      final email = account.email;
      final name = account.displayName;
      final photoUrl = account.photoUrl;

      print("Google login success! email = $email, name = $name, photoUrl = $photoUrl");

      Navigator.of(context).pushNamedAndRemoveUntil('/home', (x) => !x.isCurrent);
    });

    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
}
