import 'dart:convert';

import 'package:countly_flutter/countly_flutter.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:flutter_ws/main.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class CountlyUtil {
  static bool countlySessionStarted = false;

  static Future<void> loadCountlyInformationFromGithub(
      Logger logger, AppState appWideState, bool consentGiven) async {
    var response = await http.get(Uri.parse(HomePageState.COUNTLY_GITHUB));
    if (response.statusCode != 200) {
      logger.warning("failed to setup countly");
      return;
    }

    var responseList = LineSplitter().convert(utf8.decode(response.bodyBytes));
    // in this simple format it is assumed that the countly API is on line 1,
    // the APP_KEY on line 2 and the tampering salt und line 3
    String countlyAPI = responseList.elementAt(0);
    String countlyAppKey = responseList.elementAt(1);

    logger.info("Loaded Countly data from Github");

    appWideState.hasCountlyPermission = consentGiven;
    appWideState.sharedPreferences
        .setString(HomePageState.SHARED_PREFERENCE_KEY_COUNTLY_API, countlyAPI);
    appWideState.sharedPreferences.setString(
        HomePageState.SHARED_PREFERENCE_KEY_COUNTLY_APP_KEY, countlyAppKey);

    initializeCountly(logger, countlyAPI, countlyAppKey, consentGiven);
  }

  static void initializeCountly(Logger logger, String countlyAPI,
      String countlyAppKey, bool consentGiven) async {
    bool isInitialized = await Countly.isInitialized();
    CountlyConfig countlyConfig = CountlyConfig(countlyAPI, countlyAppKey);
    countlyConfig.setLoggingEnabled(true);
    countlyConfig.enableCrashReporting();
    countlyConfig.setRequiresConsent(true);

    if (isInitialized && consentGiven && countlySessionStarted) {
      logger.info("Countly already running");
      return;
    } else if (isInitialized && consentGiven) {
      startCountly(logger);
      return;
    } else if (isInitialized && !consentGiven) {
      countlyRejected(logger);
      return;
    }

    // Countly.enableParameterTamperingProtection(countlyTamperingProtection);
    // Features which is required before init should be call here
    Countly.initWithConfig(countlyConfig).then((value) {
      if (!consentGiven) {
        countlyRejected(logger);
        return;
      }
      startCountly(logger);
    });
  }

  static void startCountly(Logger logger) {
    //Features dependent on init should be set here, for e.g Push notifications and consent.
    Countly.giveAllConsent();
    Countly.start();
    countlySessionStarted = true;
    logger.info("COUNTLY STARTED");
  }

  static void countlyRejected(Logger logger) {
    Countly.giveConsent(["events"]);
    Countly.instance.events
        .recordEvent("REPORTING_TURNED_OFF", null, 1)
        .then((value) {
      Countly.removeAllConsent();
      Countly.clearAllTraces();
      Countly.stop();
      logger.info("Countly removed consent");
      countlySessionStarted = false;
    });
  }
}
