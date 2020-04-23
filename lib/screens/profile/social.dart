import 'dart:async';
import 'dart:convert';

import 'package:areix/screens/common.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/events.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class ProfileSocialPage extends StatefulWidget {
  @override
  _ProfileSocialPageState createState() => _ProfileSocialPageState();
}

class _ProfileSocialPageState extends State<ProfileSocialPage> {
  StreamSubscription _socialDisconnect;
  StreamSubscription _socialReconnect;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    _socialReconnect = eventBus.on<OnSocialAccountReconnect>().listen((event) {
      if (event.account.social == "Facebook") {
        setState(() {
          _accounts.removeAt(0);
          _accounts.insert(0, _facebookAccount);
        });
        facebookLogin(_facebookAccount);
      }
      Store.setStringList(KEY_SOCIAL_ACCOUNTS, _accounts.map((item) => jsonEncode(item)).toList());
    });
    _socialDisconnect = eventBus.on<OnSocialAccountDisconnect>().listen((event) {
      if (event.account.social == "Facebook") {
        setState(() {
          _accounts.removeAt(0);
          _accounts.insert(0, _facebookAccount);
        });
      }
      Store.setStringList(KEY_SOCIAL_ACCOUNTS, _accounts.map((item) => jsonEncode(item)).toList());
    });
  }

  @override
  void dispose() {
    _socialReconnect.cancel();
    _socialDisconnect.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Manage social account',
      hasFloatButton: false,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 16),
        separatorBuilder: (context, index) => Divider(height: 16),
        itemBuilder: _listItem,
        itemCount: _accounts.length,
      ),
    );
  }

  Widget _listItem(BuildContext context, int index) {
    final account = _accounts[index];
    final _primaryColor = TextStyle(color: primaryColor);

    return ListTile(
      leading: account.profileImage(48),
      title: Text(account.social, style: _primaryColor),
      trailing:
          account.connected() ? Icon(Icons.chevron_right, color: primaryColor) : Text('Connect', style: _primaryColor),
      onTap: account.connected()
          ? () => navigate(context, '/profile/social/detail', params: account)
          : () {
              if (account.social == 'Facebook') {
                facebookLogin(account);
              }
            },
    );
  }

  Future facebookLogin(SocialAccount account) async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print("Facebook login success!");

        final token = result.accessToken.token;
        final graphRequest =
            await http.get('https://graph.facebook.com/v2.12/me?fields=name,email,picture&access_token=$token');
        final profile = jsonDecode(graphRequest.body);

        final newAccount = SocialAccount(
          social: "Facebook",
          profileUrl: profile["picture"]["data"]["url"] ?? 'assets/fake/product_aia.png',
          email: profile["email"],
          username: profile["name"],
        );

        setState(() {
          _accounts.remove(account);
          _accounts.insert(0, newAccount);
        });

        Store.setStringList(KEY_SOCIAL_ACCOUNTS, _accounts.map((item) => jsonEncode(item)).toList());

        navigate(context, '/profile/social/detail', params: newAccount);
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;

      case FacebookLoginStatus.error:
        break;
    }
  }

  Future _loadAccounts() async {
    final saved = await Store.getStringList(KEY_SOCIAL_ACCOUNTS);
    final accounts = saved.map((item) {
      final json = jsonDecode(item);
      return SocialAccount(
        social: json["social"],
        profileUrl: json["profileUrl"],
        email: json["email"],
        username: json["username"],
      );
    }).toList();

    if (accounts.isEmpty) {
      accounts.addAll([_facebookAccount, _twitterAccount]);
      Store.setStringList(KEY_SOCIAL_ACCOUNTS, accounts.map((item) => jsonEncode(item)).toList());
    }

    setState(() {
      _accounts.addAll(accounts);
    });
  }

  final List<SocialAccount> _accounts = [];
  final _facebookAccount = SocialAccount(social: "Facebook", profileUrl: 'assets/fake/product_aia.png');
  final _twitterAccount = SocialAccount(social: "Twitter", profileUrl: 'assets/fake/product_aia.png');
}

class SocialAccount {
  final String social;
  String profileUrl;
  String email;
  String username;

  SocialAccount({
    this.social = "",
    this.profileUrl = "",
    this.email = "",
    this.username = "",
  });

  bool connected() => this.email.isNotEmpty && this.username.isNotEmpty;

  Widget profileImage(double size) => profileUrl.startsWith("http")
      ? Image.network(profileUrl, width: size, height: size, fit: BoxFit.cover)
      : Image.asset(profileUrl, width: size, height: size, fit: BoxFit.cover);

  SocialAccount.fromJson(Map<String, dynamic> json)
      : social = json['social'],
        profileUrl = json['profileUrl'],
        email = json['email'],
        username = json['username'];

  Map<String, dynamic> toJson() => {
        "social": social,
        "profileUrl": profileUrl,
        "email": email,
        "username": username,
      };
}
