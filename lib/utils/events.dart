import 'package:areix/screens/profile/social.dart';
import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class OnSocialAccountDisconnect {
  SocialAccount account;

  OnSocialAccountDisconnect(this.account);
}

class OnSocialAccountReconnect {
  SocialAccount account;

  OnSocialAccountReconnect(this.account);
}
