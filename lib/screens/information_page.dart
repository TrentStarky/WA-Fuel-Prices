import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wa_fuel/screens/onboarding_page.dart';

import '../style.dart';

///CLASS: InformationPage
///Displays FuelWatch info and option to complete on-boarding again
class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 40)),
                backgroundColor: MaterialStateProperty.all<Color>(ThemeColor.mainColor),
                elevation: MaterialStateProperty.all<double>(0.0),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingPage()));
              },
              child: Text('Show Instructions'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Fuel prices are powered by FuelWatch, more information can be found at: ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                          text: 'www.fuelwatch.wa.gov.au',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              if (await canLaunch('https://www.fuelwatch.wa.gov.au')) {
                                launch('https://www.fuelwatch.wa.gov.au');
                              }
                            })
                    ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Found an issue or have a suggestion? Contact us at: ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                          text: 'wafuel@starsoftware.dev',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              if (await canLaunch('mailto:wafuel@starsoftware.dev?subject=WA%20Fuel%20Contact')) {
                                launch('mailto:wafuel@starsoftware.dev?subject=WA%20Fuel%20Contact');
                              }
                            })
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text('Made with \u2764 by Trent'),
            )
          ],
        ),
      ),
    );
  }
}
