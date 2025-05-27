import 'package:flutter/material.dart';
import 'package:flutter_ws/database/video_progress_entity.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:flutter_ws/util/device_information.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/widgets/downloadSection/util.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class WatchHistory extends StatefulWidget {
  final Logger logger = Logger('WatchHistory');

  WatchHistory({Key? key}) : super(key: key);

  @override
  WatchHistoryState createState() {
    return WatchHistoryState();
  }
}

class WatchHistoryState extends State<WatchHistory> {
  Set<VideoProgressEntity>? history;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var orientation = MediaQuery.of(context).orientation;

    loadWatchHistory();

    if (history == null) {
      return SizedBox(
        width: size.width,
        height: size.width / 16 * 9,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            strokeWidth: 2.0,
            backgroundColor: Colors.white,
          ),
        ),
      );
    }

    List<Widget> watchHistoryWidgets;
    if (DeviceInformation.isTablet(context)) {
      watchHistoryWidgets = getHistoryGridList(
          size.width, (orientation == Orientation.portrait) ? 2 : 3);
    } else {
      watchHistoryWidgets = getHistoryGridList(
          size.width, orientation == Orientation.portrait ? 1 : 2);
    }

    var sliverAppBar = SliverAppBar(
      title: Text('Watch History', style: sectionHeadingTextStyle),
      backgroundColor: const Color(0xffffbf00),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 30.0, color: Colors.white),
        onPressed: () {
          //return channels when user pressed back
          return Navigator.pop(context);
        },
      ),
    );

    // add App bar on top
    watchHistoryWidgets.insert(0, sliverAppBar);

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: CustomScrollView(slivers: watchHistoryWidgets),
      ),
    );
  }

  String getWatchHistoryHeading(
      int daysPassedSinceVideoWatched, DateTime videoWatchDate) {
    // add time as item before that in the list
    if (daysPassedSinceVideoWatched == 0) {
      //today
      return "Heute";
    } else if (daysPassedSinceVideoWatched == 1) {
      // yesterday
      return "Gestern";
    } else if (daysPassedSinceVideoWatched < 8) {
      // use weekdays
      String weekday = getWeekday(videoWatchDate.weekday);
      return weekday;
    } else {
      String watchDay;
      String watchMonth;
      if (videoWatchDate.day < 10) {
        watchDay = "0${videoWatchDate.day}";
      } else {
        watchDay = videoWatchDate.day.toString();
      }

      if (videoWatchDate.month < 10) {
        watchMonth = "0${videoWatchDate.month}";
      } else {
        watchMonth = videoWatchDate.month.toString();
      }
      if (daysPassedSinceVideoWatched < 365) {
        return "$watchDay.$watchMonth";
      } else {
        //add year
        return "$watchDay.$watchMonth.${videoWatchDate.year}";
      }
    }
  }

  Future loadWatchHistory() async {
    //check for playback progress
    AppState appState = context.watch<AppState>();
    if (history == null || history!.isEmpty) {
      return appState.databaseManager.getAllLastViewedVideos().then((all) {
        if (all != null && all.isNotEmpty) {
          history = all;
          setState(() {});
        }
        return;
      });
    }
  }

  String getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return "Montag";
      case 2:
        return "Dienstag";
      case 3:
        return "Mittwoch";
      case 4:
        return "Donnerstag";
      case 5:
        return "Freitag";
      case 6:
        return "Samstag";
      case 7:
        return "Sonntag";
    }
    throw ArgumentError("Illegal argument, weekday must be between 0 and 7");
  }

  List<Widget> getHistoryGridList(double width, int crossAxisCount) {
    Map<int, MapEntry<VideoProgressEntity, List<Widget>>> watchHistoryItems =
        {};
    for (int i = 0; i < history!.length; i++) {
      VideoProgressEntity progress = history!.elementAt(i);

      int daysPassedSinceVideoWatched;
      try {
        daysPassedSinceVideoWatched =
            getDaysSinceVideoWatched(progress.timestampLastViewed!);
      } on Exception {
        continue;
      }

      Widget historyItem = Util.getWatchHistoryItem(progress, width);

      if (watchHistoryItems[daysPassedSinceVideoWatched] == null) {
        List<Widget> itemList = [];
        itemList.add(historyItem);

        watchHistoryItems[daysPassedSinceVideoWatched] =
            MapEntry(progress, itemList);
      } else {
        watchHistoryItems[daysPassedSinceVideoWatched]!.value.add(historyItem);
      }
    }

    // now for each day group create a grid
    List<Widget> resultList = [];

    for (var entry in watchHistoryItems.entries) {
      String heading = getWatchHistoryHeading(
          entry.key,
          DateTime.fromMillisecondsSinceEpoch(
              entry.value.key.timestampLastViewed!));

      resultList.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 5),
            child: Text(
              heading,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      );
      resultList.add(
        SliverPadding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          sliver: SliverGrid.count(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 16 / 9,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            children: entry.value.value,
          ),
        ),
      );
    }

    return resultList;
  }

  int getDaysSinceVideoWatched(int? timestampLastViewed) {
    if (timestampLastViewed == null) {
      throw Exception();
    }
    DateTime videoWatchDate =
        DateTime.fromMillisecondsSinceEpoch(timestampLastViewed);
    Duration differenceToToday = DateTime.now().difference(videoWatchDate);
    return differenceToToday.inDays;
  }
}
