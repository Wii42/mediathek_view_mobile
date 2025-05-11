import 'package:flutter/material.dart';

class FilterMenuState {
  bool isFilterMenuOpen;
  FilterMenuState(this.isFilterMenuOpen);
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerAppBarState data;

  const _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) {
    return true;
  }
}

class FilterBarSharedState extends StatefulWidget {
  final Widget child;
  final FilterMenuState videoListState;

  const FilterBarSharedState({Key key,
    @required this.child,
    this.videoListState,
  }) : super(key: key);

  static StateContainerAppBarState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>())
        .data;
  }

  @override
  StateContainerAppBarState createState() => StateContainerAppBarState();
}

class StateContainerAppBarState extends State<FilterBarSharedState> {
  FilterMenuState filterMenuState;

  void updateAppBarState() {
    if (filterMenuState == null) {
      setState(() {
        filterMenuState = FilterMenuState(true);
      });
    } else {
      setState(() {
        filterMenuState.isFilterMenuOpen = !filterMenuState.isFilterMenuOpen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}
