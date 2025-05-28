import 'dart:async';

import 'package:countly_flutter/countly_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ws/api/api_query.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:flutter_ws/model/indexing_info.dart';
import 'package:flutter_ws/model/query_result.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/section/download_section.dart';
import 'package:flutter_ws/section/settings_section.dart';
import 'package:flutter_ws/util/countly.dart';
import 'package:flutter_ws/util/json_parser.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/widgets/bars/gradient_app_bar.dart';
import 'package:flutter_ws/widgets/bars/status_bar.dart';
import 'package:flutter_ws/widgets/filterMenu/filter_menu.dart';
import 'package:flutter_ws/widgets/filterMenu/search_filter.dart';
import 'package:flutter_ws/widgets/introSlider/intro_slider.dart';
import 'package:flutter_ws/widgets/videolist/video_list_view.dart';
import 'package:flutter_ws/widgets/videolist/videolist_util.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'global_state/appbar_state_container.dart';

void main() async {
  Logger.root.level = Level.ALL;
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppState appState = AppState();
    await appState.ensureInitialized();
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<AppState>.value(value: appState),
      ChangeNotifierProvider<VideoListState>(create: (_) => VideoListState())
    ], child: MyApp(),));
  }, Countly.recordDartError);
}

class MyApp extends StatelessWidget {
  final TextEditingController textEditingController = TextEditingController();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    const title = 'MediathekViewMobile';

    //Setup global log levels
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
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
        textEditingController: textEditingController,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final TextEditingController? textEditingController;
  final PageController? pageController;
  final Logger logger = Logger('Main');

  MyHomePage(
      {super.key,
      required this.title,
      this.pageController,
      this.textEditingController});

  @override
  State<MyHomePage> createState() => HomePageState();
}

class HomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  List<Video>? videos;
  Logger get logger => widget.logger;

  //global state
  AppState? appWideState;

  //AppBar
  IconButton? buttonOpenFilterMenu;
  String? currentUserQueryInput;

  //Filter Menu
  Map<String, SearchFilter>? searchFilters;
  bool? filterMenuOpen;
  bool? filterMenuChannelFilterIsOpen;

  // API
  static late APIQuery api;
  IndexingInfo? indexingInfo;
  late bool refreshOperationRunning;
  bool? apiError;
  late Completer<Null> refreshCompleter;

  //Keys
  Key? videoListKey;
  Key? statusBarKey;
  Key? indexingBarKey;

  //mock
  static Timer? mockTimer;

  //Statusbar
  StatusBar? statusBar;

  TabController? _controller;

  /// Indicating the current displayed page
  /// 0: videoList
  /// 1: LiveTV
  /// 2: downloads
  /// 3: about
  int _page = 0;

  //search
  TextEditingController? get searchFieldController => widget.textEditingController;
  bool? scrolledToEndOfList;
  int? lastAmountOfVideosRetrieved;
  int? totalQueryResults = 0;

  //Tabs
  Widget? videoSearchList;
  static DownloadSection? downloadSection;
  SettingsSection? aboutSection;

  //intro slider
  late SharedPreferences prefs;
  bool isFirstStart = false;

  // Countly
  bool showCountlyGDPRDialog = false;
  static const COUNTLY_GITHUB =
      "https://raw.githubusercontent.com/mediathekview/MediathekViewMobile/master/resources/countly/config/endpoint.txt";
  static const SHARED_PREFERENCE_KEY_COUNTLY_CONSENT = "countly_consent";
  static const SHARED_PREFERENCE_KEY_COUNTLY_API = "countly_api";
  static const SHARED_PREFERENCE_KEY_COUNTLY_APP_KEY = "countly_app_key";

  HomePageState();

  @override
  void dispose() {
    logger.fine("Disposing Home Page");
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void initState() {
    videos = [];
    searchFilters = {};
    filterMenuOpen = false;
    filterMenuChannelFilterIsOpen = false;
    apiError = false;
    indexingInfo = null;
    lastAmountOfVideosRetrieved = -1;
    refreshOperationRunning = false;
    scrolledToEndOfList = false;
    currentUserQueryInput = "";
    inputListener() => handleSearchInput();
    searchFieldController!.addListener(inputListener);

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

    api = APIQuery(onDataReceived: onSearchResponse, onError: onAPISearchError);
    api.search(currentUserQueryInput, searchFilters!);

    checkForFirstStart();

    setupCountly();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.grey[800],
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          getVideoSearchListWidget(),
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
            textTheme: Theme.of(context).textTheme.copyWith(
                bodySmall: const TextStyle(
                    color: Colors
                        .yellow))), // sets the inactive color of the `BottomNavigationBar`
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

  Widget getVideoSearchListWidget() {
    logger.fine("Rendering Video Search list");

    Widget videoSearchList = SafeArea(
      child: RefreshIndicator(
        onRefresh: _handleListRefresh,
        child: Container(
          color: Colors.grey[800],
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: FilterBarSharedState(
                  child: GradientAppBar(
                      this,
                      searchFieldController,
                      FilterMenu(
                        searchFilters: searchFilters,
                        onFilterUpdated: _filterMenuUpdatedCallback,
                        onSingleFilterTapped: _singleFilterTappedCallback,
                        onChannelsSelected: () {},
                      ),
                      false,
                      videos!.length,
                      totalQueryResults),
                ),
              ),
              VideoListView(
                key: videoListKey,
                videos: videos,
                amountOfVideosFetched: lastAmountOfVideosRetrieved,
                queryEntries: onQueryEntries,
                currentQuerySkip: api.getCurrentSkip(),
                totalResultSize: totalQueryResults,
                mixin: this,
                refreshList: [],
              ),
              SliverToBoxAdapter(
                child: StatusBar(
                    key: statusBarKey,
                    apiError: apiError,
                    videoListIsEmpty: videos!.isEmpty,
                    lastAmountOfVideosRetrieved: lastAmountOfVideosRetrieved,
                    firstAppStartup: lastAmountOfVideosRetrieved! < 0),
              ),
            ],
          ),
        ),
      ),
    );
    return videoSearchList;
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

  Future<Null> _handleListRefresh() async {
    logger.fine("Refreshing video list ...");
    refreshOperationRunning = true;
    //the completer will be completed when there are results & the flag == true
    refreshCompleter = Completer<Null>();
    _createQueryWithClearedVideoList();

    return refreshCompleter.future;
  }

  // ----------CALLBACKS: WebsocketController----------------

  void onAPISearchError(Error error) {
    logger.info("Received an error from thr API.$error");

    // TODO show status bar with error

    // http 503 -> indexing
    // http 500 -> internal error
    // http 400 -> invalid query
  }

  void onSearchResponse(String data) {
    if (refreshOperationRunning) {
      refreshOperationRunning = false;
      refreshCompleter.complete();
      videos!.clear();
      logger.fine("Refresh operation finished.");
      HapticFeedback.lightImpact();
    }
    print("start");
    QueryResult queryResult = JSONParser.parseQueryResult(data);
    print("finished");

    List<Video> newVideosFromQuery = queryResult.videos as List<Video>;
    totalQueryResults = queryResult.queryInfo.totalResults;
    lastAmountOfVideosRetrieved = newVideosFromQuery.length;
    logger.info("received videos: $lastAmountOfVideosRetrieved");

    int videoListLengthOld = videos!.length;
    videos = VideoListUtil.sanitizeVideos(newVideosFromQuery, videos!);
    int newVideosCount = videos!.length - videoListLengthOld;
    logger.info("received new videos: $newVideosCount");

    if (newVideosCount == 0 && scrolledToEndOfList == false) {
      logger.info("Scrolled to end of list & mounted: $mounted");
      scrolledToEndOfList = true;
      if (mounted) {
        setState(() {});
      }
      return;
    } else if (newVideosCount != 0) {
      // client side result filtering
      if (searchFilters!["Länge"] != null) {
        videos =
            VideoListUtil.applyLengthFilter(videos!, searchFilters!["Länge"]!);
      }
      int newVideosCount = videos!.length - videoListLengthOld;

      logger.info(
          'Received $newVideosCount new video(s). Amount of videos in list ${videos!.length}');

      lastAmountOfVideosRetrieved = newVideosCount;
      scrolledToEndOfList == false;
      if (mounted) setState(() {});
    }
  }

  // ----------CALLBACKS: From List View ----------------

  void onQueryEntries() {
    api.search(currentUserQueryInput, searchFilters!);
  }

  // ---------- SEARCH Input ----------------

  void handleSearchInput() {
    if (currentUserQueryInput == searchFieldController!.text) {
      logger.fine(
          "Current Query Input equals new query input - not querying again!");
      return;
    }

    _createQueryWithClearedVideoList();
  }

  void _createQuery() {
    currentUserQueryInput = searchFieldController!.text;

    api.search(currentUserQueryInput, searchFilters!);
  }

  void _createQueryWithClearedVideoList() {
    logger.fine("Clearing video list");
    videos!.clear();
    api.resetSkip();

    if (mounted) setState(() {});
    _createQuery();
  }

  // ----------CALLBACKS: FILTER MENU----------------

  void _filterMenuUpdatedCallback(SearchFilter newFilter) {
    //called whenever a filter in the menu gets a value
    if (searchFilters![newFilter.filterId] != null) {
      if (searchFilters![newFilter.filterId]!.filterValue !=
          newFilter.filterValue) {
        logger.fine(
            "Changed filter text for filter with id ${newFilter.filterId} detected. Old Value: ${searchFilters![newFilter.filterId]!.filterValue} New : ${newFilter.filterValue}");

        HapticFeedback.mediumImpact();

        searchFilters!.remove(newFilter.filterId);
        if (newFilter.filterValue.isNotEmpty) {
          searchFilters!.putIfAbsent(newFilter.filterId, () => newFilter);
        }
        //updates state internally
        _createQueryWithClearedVideoList();
      }
    } else if (newFilter.filterValue.isNotEmpty) {
      logger.fine(
          "New filter with id ${newFilter.filterId} detected with value ${newFilter.filterValue}");

      HapticFeedback.mediumImpact();

      searchFilters!.putIfAbsent(newFilter.filterId, () => newFilter);
      _createQueryWithClearedVideoList();
    }
  }

  void _singleFilterTappedCallback(String id) {
    //remove filter from list and refresh state to trigger build of app bar and list!
    searchFilters!.remove(id);
    HapticFeedback.mediumImpact();
    _createQueryWithClearedVideoList();
  }

  // ----------LIFECYCLE----------------

  Future<void> checkForFirstStart() async {
    prefs = await SharedPreferences.getInstance();
    var firstStart = prefs.getBool('firstStart');
    if (firstStart == null) {
      print("First start");
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
            .containsKey(SHARED_PREFERENCE_KEY_COUNTLY_API) &&
        appWideState!.sharedPreferences
            .containsKey(SHARED_PREFERENCE_KEY_COUNTLY_APP_KEY)) {
      logger.info("setup countly -4");

      bool countlyConsent = appWideState!.sharedPreferences
          .getBool(SHARED_PREFERENCE_KEY_COUNTLY_CONSENT)!;

      if (!countlyConsent) {
        logger.info("Countly - no consent.");
        return;
      }

      String? countlyAPI = appWideState!.sharedPreferences
          .getString(SHARED_PREFERENCE_KEY_COUNTLY_API);
      String? countlyAppKey = appWideState!.sharedPreferences
          .getString(SHARED_PREFERENCE_KEY_COUNTLY_APP_KEY);
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
