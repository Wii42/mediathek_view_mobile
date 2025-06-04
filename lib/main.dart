import 'dart:async';

import 'package:countly_flutter/countly_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:flutter_ws/section/download_section.dart';
import 'package:flutter_ws/section/settings_section.dart';
import 'package:flutter_ws/section/video_search_list_section.dart';
import 'package:flutter_ws/util/countly.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/widgets/introSlider/intro_slider.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'global_state/filter_menu_state.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppState appState = AppState();
    await appState.ensureInitialized();
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: appState),
        ChangeNotifierProvider<VideoListState>(create: (_) => VideoListState())
      ],
      child: MyApp(),
    ));
  }, Countly.recordDartError);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'MediathekViewMobile';

    //Setup global log levels
    Logger.root.level = Level.WARNING;
    Logger.root.onRecord.listen((LogRecord rec) {
      if (kDebugMode) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      }
    });

    Uuid uuid = Uuid();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
            titleMedium: subHeaderTextStyle,
            titleLarge: headerTextStyle,
            bodyMedium: body1TextStyle,
            bodyLarge: body2TextStyle,
            headlineMedium: hintTextStyle,
            labelLarge: buttonTextStyle),
        chipTheme: ChipThemeData.fromDefaults(
            secondaryColor: Colors.black,
            labelStyle: subHeaderTextStyle,
            brightness: Brightness.dark),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Color(0xffffbf00),
          unselectedItemColor: Colors.white,
        ),
        brightness: Brightness.light,
      ),
      title: title,
      home: MyHomePage(
        key: Key(uuid.v1()),
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final PageController? pageController;
  final Logger logger = Logger('Main');

  MyHomePage({super.key, required this.title, this.pageController});

  @override
  State<MyHomePage> createState() => HomePageState();
}

class HomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Logger get logger => widget.logger;

  //global state
  AppState? appWideState;

  //Keys
  Key? videoListKey;
  Key? statusBarKey;
  Key? indexingBarKey;

  TabController? _controller;

  /// Indicating the current displayed page
  /// 0: videoList
  /// 1: LiveTV
  /// 2: downloads
  /// 3: about
  int _page = 0;

  //Tabs
  late VideoSearchListSection videoSearchListSection;
  static DownloadSection? downloadSection;
  SettingsSection? aboutSection;

  //intro slider
  late SharedPreferences prefs;
  bool isFirstStart = false;

  // Countly
  bool showCountlyGDPRDialog = false;

  Color backgroundColor = Colors.grey.shade800;

  HomePageState();

  @override
  void dispose() {
    logger.fine("Disposing Home Page");
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void initState() {
    //register Observer to react to android/ios lifecycle events
    WidgetsBinding.instance.addObserver(this);

    _controller = TabController(length: 3, vsync: this);
    _controller!.addListener(() => onUISectionChange());

    //Init tabs
    //liveTVSection = new LiveTVSection();
    aboutSection = SettingsSection();

    //keys
    Uuid uuid = Uuid();
    videoListKey = Key(uuid.v1());
    statusBarKey = Key(uuid.v1());
    indexingBarKey = Key(uuid.v1());

    checkForFirstStart();

    setupCountly();

    videoSearchListSection = createVideoSearchListSection();

    super.initState();
  }

  VideoSearchListSection createVideoSearchListSection() {
    return VideoSearchListSection(
        videoListKey: videoListKey, statusBarKey: statusBarKey);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light));
    appWideState = Provider.of<AppState>(context, listen: false);

    if (isFirstStart) {
      return IntroScreen(onDonePressed: () {
        setState(() {
          isFirstStart = false;
          prefs.setBool('firstStart', false);
        });
      });
    }

    if (showCountlyGDPRDialog) {
      logger.info("show dialog");
      return _showGDPRDialog(context);
    }

    downloadSection ??= DownloadSection(appWideState!);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          ChangeNotifierProvider<FilterMenuState>(
            create: (_) => FilterMenuState(),
            child: videoSearchListSection,
          ),
          downloadSection!,
          aboutSection ?? SettingsSection()
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.black,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.red,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(bodySmall: const TextStyle(color: Colors.yellow))),
        // sets the inactive color of the `BottomNavigationBar`
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _page,
          onTap: navigationTapped,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.live_tv,
                  color: Colors.white,
                ),
                activeIcon: Icon(
                  Icons.live_tv,
                  color: Color(0xffffbf00),
                ),
                label: "Mediathek"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.folder,
                  color: Colors.white,
                ),
                activeIcon: Icon(
                  Icons.folder,
                  color: Color(0xffffbf00),
                ),
                label: "Bibliothek"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                ),
                activeIcon: Icon(
                  Icons.settings_outlined,
                  color: Color(0xffffbf00),
                ),
                label: "Settings")
          ],
        ),
      ),
    );
  }

  // Called when the user presses on of the BottomNavigationBarItems. Does not get triggered by a users swipe.
  void navigationTapped(int page) {
    logger.info("New Navigation Tapped: ---> Page $page");
    _controller!.animateTo(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);

    setState(() {
      _page = page;
    });
  }

  /*
    Gets triggered whenever TabController changes page.
    This can be due to a user's swipe or via tab on the BottomNavigationBar
   */
  void onUISectionChange() {
    if (_page != _controller!.index) {
      logger.info("UI Section Change: ---> Page ${_controller!.index}");

      Countly.isInitialized().then((initialized) {
        if (initialized) {
          switch (_controller!.index) {
            case 0:
              Countly.instance.views.startView("Mediathek");
              break;
            case 1:
              Countly.instance.views.startView("Downloads");
              break;
            case 2:
              // do something else
              Countly.instance.views.startView("Settings");
              break;
          }
        }
      });

      setState(() {
        _page = _controller!.index;
      });
    }
  }

  //// ----------LIFECYCLE----------------

  Future<void> checkForFirstStart() async {
    prefs = await SharedPreferences.getInstance();
    var firstStart = prefs.getBool('firstStart');
    if (firstStart == null) {
      logger.info("First start");
      setState(() {
        isFirstStart = true;
      });
    }
  }

  void setupCountly() async {
    logger.info("setup countly");
    var sharedPreferences = await SharedPreferences.getInstance();
    appWideState!.setSharedPreferences(sharedPreferences);

    logger.info("setup countly -2");

    if (appWideState!.sharedPreferences
            .containsKey(CountlyUtil.SHARED_PREFERENCE_KEY_COUNTLY_API) &&
        appWideState!.sharedPreferences
            .containsKey(CountlyUtil.SHARED_PREFERENCE_KEY_COUNTLY_APP_KEY)) {
      logger.info("setup countly -4");

      if (!appWideState!.hasCountlyPermission) {
        logger.info("Countly - no consent.");
        return;
      }

      String? countlyAPI = appWideState!.sharedPreferences
          .getString(CountlyUtil.SHARED_PREFERENCE_KEY_COUNTLY_API);
      String? countlyAppKey = appWideState!.sharedPreferences
          .getString(CountlyUtil.SHARED_PREFERENCE_KEY_COUNTLY_APP_KEY);
      if (countlyAPI != null && countlyAppKey != null) {
        logger.info("Loaded Countly data from shared preferences");
        CountlyUtil.initializeCountly(logger, countlyAPI, countlyAppKey, true);
      }
      return;
    }

    logger.info("countly -3");

    // countly information not found in shared preferences
    // request permission from user
    // need to setState in order to show GDPR dialog
    setState(() {
      showCountlyGDPRDialog = true;
    });
  }

  Widget _showGDPRDialog(BuildContext context) {
    return GiffyDialog.image(
      //key: keys[1],
      Image.network(
        "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
        height: MediaQuery.of(context).size.height * 0.4,
        fit: BoxFit.contain,
      ),
      entryAnimation: EntryAnimation.topLeft,
      title: const Text(
        'Vielen Dank',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
      content: const Text(
        'Darf MediathekView anonymisierte Crash und Nutzungsdaten sammeln? Das hilft uns die App zu verbessern.',
        textAlign: TextAlign.center,
      ),
      contentTextStyle: TextStyle(),
      actions: [
        FilledButton(
          onPressed: () {
            CountlyUtil.loadCountlyInformationFromGithub(
                logger, appWideState!, false);
            setState(() {
              showCountlyGDPRDialog = false;
            });
          },
          child: const Text(
            "Nein",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            CountlyUtil.loadCountlyInformationFromGithub(
                logger, appWideState!, true);
            setState(() {
              showCountlyGDPRDialog = false;
            });
          },
          child: const Text("Ja"),
        ),
      ],
    );
  }
}
