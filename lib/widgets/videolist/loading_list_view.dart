import 'package:flutter/material.dart';

class LoadingListPage extends StatelessWidget {
  const LoadingListPage({super.key});

  int determineNumberOfNeededTilesToFillScreen(
      BuildContext context, double listRowHeight) {
    double height = MediaQuery.of(context).size.height;
    // not filling whole available space
    return (height / listRowHeight).floor() - 1;
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingCard = getLoadingCard();
    int num = determineNumberOfNeededTilesToFillScreen(context, 130);
    List<int?> children = List.filled(num, 0);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
            .map(
              (_) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      loadingCard,
                    ],
                  ),
            )
            .toList(),
      ),
    );
  }

  //Basically a visual replication of a list card from list_card.dart to show while the data for the video list is loading
  Widget getLoadingCard() {
    final cardContent = getCardContent();
    final card = getListCard(cardContent);
    Widget dummyChannelThumbnail = getDummyChannelThumbnail();

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      child: Stack(
        children: <Widget>[card, dummyChannelThumbnail],
      ),
    );
  }

  Container getCardContent() {
    return Container(
      margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 4.0),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 40.0, right: 9.0),
              child: Container(
                color: Colors.grey,
                constraints: BoxConstraints.expand(width: 50, height: 10),
              ),
            ),
          ),
          Container(height: 20.0),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 40.0, right: 40.0),
              child: Container(
                color: Colors.grey,
                constraints: BoxConstraints.expand(height: 11),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 40.0, right: 12.0),
              height: 10),
          Flexible(
              child: Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                  height: 2.0,
                  color: Colors.grey)),
          Container(height: 4.0),
          Container(
            constraints: BoxConstraints.loose(Size.fromHeight(20.0)),
            padding: EdgeInsets.only(left: 40.0, right: 5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: _getMetadataRow(
                  width: 20,
                  icon: Icon(
                    Icons.spa,
                    color: Colors.grey,
                  ),
                )),
                Expanded(
                    child: _getMetadataRow(
                  width: 40,
                  icon: Icon(
                    Icons.access_time,
                    color: Colors.grey,
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMetadataRow({double? width, required Icon icon}) {
    return Row(children: <Widget>[
      icon,
      Container(width: 8.0),
      Container(width: width, height: 6, color: Colors.grey[300]),
    ]);
  }

  Container getListCard(Container cardContent) {
    return Container(
      margin: EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
      ),
      child: cardContent,
    );
  }

  Container getDummyChannelThumbnail() {
    return Container(
      margin: EdgeInsets.only(left: 2.0, top: 5.0),
      alignment: FractionalOffset.topLeft,
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
    );
  }
}
