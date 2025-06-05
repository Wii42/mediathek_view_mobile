import 'package:flutter_ws/model/video.dart';

import '../util/date_time_parser.dart';

class VideoEntity {
  static const String TABLE_NAME = "videos";

  String? id;
  String? task_id;
  String? channel;
  String? topic;
  String? description;
  String? title;
  int? timestamp;
  int? timestamp_video_saved;
  String? duration;
  int? size;
  String? url_website;
  String? url_video_low;
  String? url_video_hd;
  String? filmlisteTimestamp;
  String? url_video;
  String? url_subtitle;

  //for the db entity
  String? filePath;
  String? fileName;
  String? mimeType;

  //local rating
  double? rating;

  //column names
  static const String idColumn = "id";
  static const String task_idColumn = "task_id";
  static const String channelColumn = "channel";
  static const String topicColumn = "topic";
  static const String descriptionColumn = "description";
  static const String titleColumn = "title";
  static const String timestampColumn = "timestamp";
  static const String timestamp_video_savedColumn = "timestamp_video_saved";
  static const String durationColumn = "duration";
  static const String sizeColumn = "size";
  static const String url_websiteColumn = "url_website";
  static const String url_video_lowColumn = "url_video_low";
  static const String url_video_hdColumn = "url_video_hd";
  static const String filmlisteTimestampColumn = "filmlisteTimestamp";
  static const String url_videoColumn = "url_video";
  static const String url_subtitleColumn = "url_subtitle";
  static const String ratingColumn = "rating";
  static const String filePathColumn = "filePath";
  static const String fileNameColumn = "fileName";
  static const String mimeTypeColumn = "mimeType";

  VideoEntity(
      this.id,
      this.task_id,
      this.channel,
      this.topic,
      this.description,
      this.title,
      this.timestamp,
      this.timestamp_video_saved,
      this.duration,
      this.size,
      this.url_website,
      this.url_video_low,
      this.url_video_hd,
      this.filmlisteTimestamp,
      this.url_video,
      this.url_subtitle,
      {this.filePath,
      this.fileName,
      this.mimeType,
      this.rating});

  factory VideoEntity.fromVideo(Video video) {
    return VideoEntity(
      video.id,
      "",
      //task Id is added by download manager
      video.channel,
      video.topic,
      video.description,
      video.title,
      DateTimeParser.toSecondsSinceEpoch(video.timestamp),
      0,
      video.duration.toString(),
      video.size,
      video.url_website?.toString(),
      video.url_video_low?.toString(),
      video.url_video_hd?.toString(),
      DateTimeParser.toSecondsSinceEpochString(video.filmlisteTimestamp),
      video.url_video?.toString(),
      video.url_subtitle?.toString(),
    );
  }

  VideoEntity.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        task_id = json['task_id'],
        channel = json['channel'],
        topic = json['topic'],
        description = json['description'],
        title = json['title'],
        timestamp = json['timestamp'],
        timestamp_video_saved = json['timestamp_video_saved'],
        duration = json['duration'],
        size = json['size'],
        url_website = json['url_website'],
        url_video_low = json['url_video_low'],
        url_video_hd = json['url_video_hd'],
        filmlisteTimestamp = json['filmlisteTimestamp'],
        url_video = json['url_video'],
        url_subtitle = json['url_subtitle'],
        filePath = json['filePath'],
        fileName = json['fileName'],
        rating = json['rating'],
        mimeType = json['mimeType'];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'task_id': task_id,
      'channel': channel,
      'topic': topic,
      'description': description,
      'title': title,
      'timestamp': timestamp,
      'timestamp_video_saved': timestamp_video_saved,
      'duration': duration,
      'size': size,
      'url_website': url_website,
      'url_video_low': url_video_low,
      'url_video_hd': url_video_hd,
      'filmlisteTimestamp': filmlisteTimestamp,
      'url_video': url_video,
      'url_subtitle': url_subtitle,
      'filePath': filePath,
      'fileName': fileName,
      'mimeType': mimeType,
      'rating': rating,
    };
    return map;
  }
}
