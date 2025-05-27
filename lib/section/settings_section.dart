import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:flutter_ws/main.dart';
import 'package:flutter_ws/util/countly.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsSection extends StatelessWidget {
  static final Logger logger = Logger('SettingsSection');

  static const githubUrl =
      'https://github.com/Mediathekview/MediathekViewMobile';
  static const payPal = 'https://paypal.me/danielfoehr';

  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text('About', style: aboutSectionTitle),
                    subtitle: Text(
                        'Dies ist ein Open-Source Projekt (Apache 2.0-Lizenz) basierend auf der API von MediathekViewWeb. Es werden die Mediatheken der öffentlich-rechtliche TV Sender unterstützt.'),
                  ),
                ],
              ),
            ),
            SettingsState(),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title:
                        Text('Spenden / Donate', style: aboutSectionTitle),
                    subtitle: const Text(
                        'Dir gefällt die App? Ich würde mich über eine Spende freuen.'),
                  ),
                  ButtonTheme(
                    // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      children: <Widget>[
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue)),
                          child: Text('Paypal', style: body2TextStyle),
                          onPressed: () {
                            _launchURL(payPal);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.feedback),
                    title: Text('Feedback', style: aboutSectionTitle),
                    subtitle: Text(
                        'Anregungen, Wünsche oder Bugs? Gib Feedback auf Github. Danke für deinen Beitrag!'),
                  ),
                  ButtonTheme(
                    // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      children: <Widget>[
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color?>(
                                  Colors.grey[800])),
                          child: Text('Github', style: body2TextStyle),
                          onPressed: () => _launchURL(githubUrl),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      logger.fine('Could not launch $url');
    }
  }
}

class SettingsState extends StatefulWidget {
  final Logger logger = Logger('SettingsState');

  @override
  _SettingsStateState createState() => _SettingsStateState();
}

class _SettingsStateState extends State<SettingsState> {

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appWideState, child) {
      bool hasCountlyConsent = appWideState.sharedPreferences
          .getBool(HomePageState.SHARED_PREFERENCE_KEY_COUNTLY_CONSENT)?? false;

      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.pan_tool),
              title: Text('GDPR', style: aboutSectionTitle),
              subtitle: const Text(
                  'Darf MediathekView anonymisierte Crash und Nutzungsdaten sammeln? Das hilft uns die App zu verbessern.'),
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Transform.scale(
                scale: 1.5,
                child: Switch(
                  value: hasCountlyConsent,
                  onChanged: (value) {
                    setState(() {
                      appWideState.sharedPreferences.setBool(
                          HomePageState.SHARED_PREFERENCE_KEY_COUNTLY_CONSENT,
                          value);

                      if (appWideState.sharedPreferences.containsKey(
                          HomePageState.SHARED_PREFERENCE_KEY_COUNTLY_API) &&
                          appWideState.sharedPreferences.containsKey(
                              HomePageState
                                  .SHARED_PREFERENCE_KEY_COUNTLY_APP_KEY)) {
                        String? countlyAppKey = appWideState.sharedPreferences
                            .getString(HomePageState
                            .SHARED_PREFERENCE_KEY_COUNTLY_APP_KEY);
                        String? countlyAPI =
                        appWideState.sharedPreferences.getString(
                            HomePageState.SHARED_PREFERENCE_KEY_COUNTLY_API);
                        return CountlyUtil.initializeCountly(
                            widget.logger, countlyAPI, countlyAppKey, value);
                      }
                      CountlyUtil.loadCountlyInformationFromGithub(
                          widget.logger, appWideState, value);
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      );
    });
      }

}
