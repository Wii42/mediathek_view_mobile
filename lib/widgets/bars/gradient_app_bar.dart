import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ws/global_state/appbar_state_container.dart';
import 'package:flutter_ws/util/device_information.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/widgets/filterMenu/filter_menu.dart';
import 'package:flutter_ws/widgets/filterMenu/search_filter.dart';
import 'package:logging/logging.dart';

class GradientAppBar extends StatelessWidget {
  final Logger logger = Logger('GradientAppBar');
  final TextEditingController? controller;
  final bool isFilterMenuOpen;
  final int currentAmountOfVideosInList;
  final int? totalAmountOfVideosForSelection;
  final FilterMenu filterMenu;
  final TickerProviderStateMixin mixin;

  GradientAppBar(
      this.mixin,
      this.controller,
      this.filterMenu,
      this.isFilterMenuOpen,
      this.currentAmountOfVideosInList,
      this.totalAmountOfVideosForSelection);

  List<SearchFilter>? get searchFilters => filterMenu.searchFilters!.values.toList();

  @override
  Widget build(BuildContext context) {
    logger.fine("Rendering App Bar");

    StateContainerAppBarState state = FilterBarSharedState.of(context);

    bool isFilterMenuOpen = getFilterMenuState(context);

    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 32.0),
      decoration: BoxDecoration(
        color: Color(0xffffbf00),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 20.0),
                    child: TextField(
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700),
                      controller: controller,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontStyle: FontStyle.italic),
                        suffixIcon: IconButton(
                            color: controller!.text.isNotEmpty
                                ? Colors.red
                                : Colors.transparent,
                            onPressed: () {
                              controller!.text = "";
                            },
                            icon: Icon(
                              Icons.clear,
                              size: 30.0,
                            )),
                        labelStyle: hintTextStyle.copyWith(color: Colors.white),
                        icon: IconButton(
                          color: isFilterMenuOpen ? Colors.red : Colors.black,
                          icon: Icon(Icons.search),
                          iconSize: 30.0,
                          onPressed: () {
                            state.updateAppBarState();
                          },
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                Text(
                  totalAmountOfVideosForSelection.toString(),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          //show filters if there are some in the list
          searchFilters != null && searchFilters!.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Filter: ', style: filterRowTextStyle),
                      !DeviceInformation.isTablet(context) &&
                              searchFilters!.length > 3
                          ? Column(
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: searchFilters!.sublist(0, 2)),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: searchFilters!.sublist(2)),
                              ],
                            )
                          : Row(children: searchFilters!),
                    ],
                  ),
                )
              : Container(),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            //vsync: mixin,
            child: isFilterMenuOpen
                ? Padding(
                    padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: filterMenu,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  bool getFilterMenuState(BuildContext context) {
    StateContainerAppBarState state = FilterBarSharedState.of(context);
    FilterMenuState? videoListState = state.filterMenuState;
    return videoListState != null && videoListState.isFilterMenuOpen;
  }
}
