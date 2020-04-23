import 'package:areix/components/outline-round-button.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/screens/profile/social.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/events.dart';
import 'package:flutter/material.dart';

class ProfileSocialDetailPage extends StatefulWidget {
  @override
  _ProfileSocialDetailPageState createState() => _ProfileSocialDetailPageState();
}

class _ProfileSocialDetailPageState extends State<ProfileSocialDetailPage> {
  @override
  Widget build(BuildContext context) {
    SocialAccount account = ModalRoute.of(context).settings.arguments;
    return CommonPage(
      title: account.social,
      hasFloatButton: false,
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          // Social image
          SizedBox(height: 24),
          Center(
            child: account.profileImage(100),
          ),
          SizedBox(height: 36),

          // Username
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('Name :', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                Expanded(child: Container()),
                Text(
                  account.username,
                  style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),

          // Email
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('Email :', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                Expanded(child: Container()),
                Text(
                  account.email,
                  style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),

          // Buttons
          SizedBox(height: 48),
          OutlineRoundButton(
            title: 'Reconnect',
            fill: true,
            width: 200,
            onPressed: () {
              eventBus.fire(OnSocialAccountReconnect(account));
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: 16),
          OutlineRoundButton(
            title: 'Disconnect',
            width: 200,
            onPressed: () {
              eventBus.fire(OnSocialAccountDisconnect(account));
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: 16),
        ]),
      ),
    );
  }
}
