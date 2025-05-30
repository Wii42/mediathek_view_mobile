import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ws/global_state/filter_menu_state.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../api/api_query.dart';
import '../model/query_result.dart';
import '../model/video.dart';
import '../util/json_parser.dart';
import '../widgets/bars/gradient_app_bar.dart';
import '../widgets/bars/status_bar.dart';
import '../widgets/filterMenu/filter_menu.dart';
import '../widgets/filterMenu/search_filter.dart';
import '../widgets/videolist/video_list_view.dart';
import '../widgets/videolist/videolist_util.dart';

class VideoSearchListSection extends StatefulWidget {
  final Key? videoListKey;
  final Key? statusBarKey;

  const VideoSearchListSection(
      {required this.videoListKey, super.key, required this.statusBarKey});

  @override
  State<VideoSearchListSection> createState() => _VideoSearchListSectionState();
}

class _VideoSearchListSectionState extends State<VideoSearchListSection>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final Logger logger = Logger('VideoSearchListSection');

  late APIQuery api;
  TextEditingController searchFieldController = TextEditingController();

  List<Video> videos = [];

  String currentUserQueryInput = "";
  int? totalQueryResults = 0;
  int lastAmountOfVideosRetrieved = -1;
  bool apiError = false;
  bool refreshOperationRunning = false;
  bool scrolledToEndOfList = false;
  bool initialQueryNeeded = true;

  Completer<Null>? refreshCompleter;

  SearchFilters get searchFilters =>
      context.read<FilterMenuState>().searchFilters;

  @override
  void initState() {
    inputListener() => handleSearchInput();
    searchFieldController.addListener(inputListener);

    api = APIQuery(onDataReceived: onSearchResponse, onError: onAPISearchError);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (initialQueryNeeded) {
      api.search(currentUserQueryInput, searchFilters);
      initialQueryNeeded = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _handleListRefresh,
        child: Container(
          color: Colors.grey[800],
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: GradientAppBar(
                  this,
                  searchFieldController,
                  FilterMenu(
                    searchFilters: searchFilters,
                    onFilterUpdated: _filterMenuUpdatedCallback,
                    onSingleFilterTapped: _singleFilterTappedCallback,
                    onChannelsSelected: () {},
                    fontColor: Colors.black87,
                  ),
                  videos.length,
                  totalQueryResults,
                ),
              ),
              VideoListView(
                key: widget.videoListKey,
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
                    key: widget.statusBarKey,
                    apiError: apiError,
                    videoListIsEmpty: videos.isEmpty,
                    lastAmountOfVideosRetrieved: lastAmountOfVideosRetrieved,
                    firstAppStartup: lastAmountOfVideosRetrieved < 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _handleListRefresh() async {
    logger.fine("Refreshing video list ...");
    refreshOperationRunning = true;
    //the completer will be completed when there are results & the flag == true
    refreshCompleter = Completer<Null>();
    _createQueryWithClearedVideoList();

    return refreshCompleter!.future;
  }

  void handleSearchInput() {
    if (currentUserQueryInput == searchFieldController.text) {
      logger.fine(
          "Current Query Input equals new query input - not querying again!");
      return;
    }

    _createQueryWithClearedVideoList();
  }

  void _createQuery() {
    currentUserQueryInput = searchFieldController.text;

    api.search(currentUserQueryInput, searchFilters);
  }

  void _createQueryWithClearedVideoList() {
    logger.fine("Clearing video list");
    videos.clear();
    api.resetSkip();

    if (mounted) setState(() {});
    _createQuery();
  }

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
      refreshCompleter?.complete();
      videos.clear();
      logger.fine("Refresh operation finished.");
      HapticFeedback.lightImpact();
    }
    logger.fine("start");
    QueryResult queryResult = JSONParser.parseQueryResult(data);
    logger.fine("finished");

    List<Video> newVideosFromQuery = queryResult.videos as List<Video>;
    totalQueryResults = queryResult.queryInfo.totalResults;
    lastAmountOfVideosRetrieved = newVideosFromQuery.length;
    logger.info("received videos: $lastAmountOfVideosRetrieved");

    int videoListLengthOld = videos.length;
    videos = VideoListUtil.sanitizeVideos(newVideosFromQuery, videos);
    int newVideosCount = videos.length - videoListLengthOld;
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
      if (searchFilters.videoLength != null) {
        videos =
            VideoListUtil.applyLengthFilter(videos, searchFilters.videoLength!);
      }
      int newVideosCount = videos.length - videoListLengthOld;

      logger.info(
          'Received $newVideosCount new video(s). Amount of videos in list ${videos.length}');

      lastAmountOfVideosRetrieved = newVideosCount;
      scrolledToEndOfList == false;
      if (mounted) setState(() {});
    }
  }

  // ----------CALLBACKS: From List View ----------------

  void onQueryEntries() {
    api.search(currentUserQueryInput, searchFilters);
  }

  // ----------CALLBACKS: FILTER MENU----------------

  void _filterMenuUpdatedCallback<T extends Object>(SearchFilter<T> newFilter) {
    bool isNotEmpty = true;
    if (newFilter is SearchFilter<String>) {
      isNotEmpty = (newFilter as SearchFilter<String>).filterValue.isNotEmpty;
    } else if (newFilter is SearchFilter<List<String>>) {
      isNotEmpty =
          (newFilter as SearchFilter<List<String>>).filterValue.isNotEmpty;
    } else if (newFilter is SearchFilter<(double, double)>) {
      isNotEmpty = (newFilter as SearchFilter<(double, double)>).filterValue !=
          const (-1.0, -1.0);
    }

    //called whenever a filter in the menu gets a value
    if (searchFilters.getById(newFilter.filterId) != null) {
      if (searchFilters.getById(newFilter.filterId)!.filterValue !=
          newFilter.filterValue) {
        logger.fine(
            "Changed filter text for filter with id ${newFilter.filterId} detected. Old Value: ${searchFilters.getById(newFilter.filterId)!.filterValue} New : ${newFilter.filterValue}");

        HapticFeedback.mediumImpact();

        searchFilters.removeById(newFilter.filterId);
        if (isNotEmpty) {
          searchFilters.putIfAbsent(newFilter.filterId, () => newFilter);
        }
        //updates state internally
        _createQueryWithClearedVideoList();
      }
    } else if (isNotEmpty) {
      logger.fine(
          "New filter with id ${newFilter.filterId} detected with value ${newFilter.filterValue}");

      HapticFeedback.mediumImpact();

      searchFilters.putIfAbsent(newFilter.filterId, () => newFilter);
      _createQueryWithClearedVideoList();
    }
  }

  void _singleFilterTappedCallback(String id) {
    //remove filter from list and refresh state to trigger build of app bar and list!
    searchFilters.removeById(id);
    HapticFeedback.mediumImpact();
    _createQueryWithClearedVideoList();
  }

  @override
  bool get wantKeepAlive => true;
}
