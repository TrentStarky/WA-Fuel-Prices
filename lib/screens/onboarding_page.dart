import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wa_fuel/style.dart';

///CLASS: OnboardingPage
///Displays basic instructions for how to use the app
class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageDecoration pageDecoration;

  ///Setup page decoration
  @override
  void initState() {
    pageDecoration = PageDecoration(
      imageFlex: 2,
      imagePadding: EdgeInsets.zero,
      bodyAlignment: Alignment.center,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, con) => IntroductionScreen(
        next: Text('Next'),
        done: Text('Finish'),
        onDone: () {
          if (Platform.isIOS) {
            //need to ask for notification permissions now on iOS
            FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
            flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
                ?.requestPermissions(
                  alert: true,
                  badge: true,
                  sound: true,
                )
                ?.then((result) {
              Navigator.pop(context);
            });
          } else {
            Navigator.pop(context);
          }
        },
        dotsDecorator: DotsDecorator(activeColor: ThemeColor.mainColor),
        pages: [
          PageViewModel(
            decoration: pageDecoration,
            title: 'Search',
            body: 'Search for the best fuel prices by product, brand and region / suburb',
            image: Image.asset(
              'assets/images/Fuel App Onboarding Search.jpg',
              width: con.maxWidth * 0.7,
            ),
          ),
          PageViewModel(
            decoration: pageDecoration,
            title: 'Favourite',
            body: 'Save your common searches for ease of access',
            image: Image.asset(
              'assets/images/Fuel App Onboarding Favourite.jpg',
              width: con.maxWidth * 0.7,
            ),
          ),
          PageViewModel(
            decoration: pageDecoration,
            title: 'Notifications',
            body: 'Get daily notifications on price movements',
            image: Image.asset(
              'assets/images/Fuel App Onboarding Notification.jpg',
              width: con.maxWidth * 0.7,
            ),
          ),
        ],
      ),
    );
  }
}
