import 'package:flutter_ws/model/search_object.dart';

class SearchQueryParser {
  SearchObject getSearchObjectFromInput(String input) {
    var channels = [];
    var topics = [];
    var titles = [];
    var descriptions = [];
    var generics = [];

//    Parse to Object here! -> then construc/t the query Object with this

    return SearchObject(channels, topics, titles, descriptions, generics);
  }
}
