import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wa_fuel/app/app_colors.dart';
import 'package:wa_fuel/ui/pages/information/information_viewmodel.dart';

class InformationView extends StatelessWidget {
  const InformationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InformationViewModel>.reactive(
      viewModelBuilder: () => InformationViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Information'),
          centerTitle: true,
          automaticallyImplyLeading: true,
          backgroundColor: colorPrimaryOrange,
          elevation: 0,
        ),
        backgroundColor: colorLightBackground,

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0, primary: colorPrimaryOrange),
                onPressed: model.openInstructions,
                child: Text('Show Instructions'),
              ),
            ),
            SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text:
                  'Fuel prices are powered by FuelWatch, more information can be found at: ',
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text: 'www.fuelwatch.wa.gov.au',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            if (await canLaunch(
                                'https://www.fuelwatch.wa.gov.au')) {
                              launch('https://www.fuelwatch.wa.gov.au');
                            }
                          })
                  ]),
            ),
            SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text:
                  'Found an issue or have a suggestion? Contact us at: ',
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text: 'wafuel@starsoftware.dev',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            if (await canLaunch(
                                'mailto:wafuel@starsoftware.dev?subject=WA%20Fuel%20Contact')) {
                              launch(
                                  'mailto:wafuel@starsoftware.dev?subject=WA%20Fuel%20Contact');
                            }
                          })
                  ]),
            ),
            SizedBox(height: 24),

            Center(child: Text('Made with \u2764 by Trent'))
          ],
        ),
      ),
    );
  }
}