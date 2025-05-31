class VideoProgressEntity {
  static const String TABLE_NAME = "video_progress";

  String? id;
  int? progress;
  String? channel;
  String? topic;
  String? description;
  String? title;
  int? timestamp;
  int? timestampLastViewed;
  int? duration;
  int? size;
  String? url_website;
  String? url_video_low;
  String? url_video_hd;
  String? filmlisteTimestamp;
  String? url_video;
  String? url_subtitle;

  Duration? get durationAsDuration =>
      duration != null ? Duration(seconds: duration!) : null;

  Duration? get progressAsDuration =>
      progress != null ? Duration(seconds: progress!) : null;

  //column names
  static const String idColumn = "id";
  static const String progressColumn = "progress";
  static const String channelColumn = "channel";
  static const String topicColumn = "topic";
  static const String descriptionColumn = "description";
  static const String titleColumn = "title";
  static const String timestampColumn = "timestamp";
  static const String timestampLastViewedColumn = "timestampLastViewed";
  static const String durationColumn = "duration";
  static const String sizeColumn = "size";
  static const String url_websiteColumn = "url_website";
  static const String url_video_lowColumn = "url_video_low";
  static const String url_video_hdColumn = "url_video_hd";
  static const String filmlisteTimestampColumn = "filmlisteTimestamp";
  static const String url_videoColumn = "url_video";
  static const String url_subtitleColumn = "url_subtitle";

  VideoProgressEntity(this.id, this.progress,
      {this.channel,
      this.topic,
      this.description,
      this.title,
      this.timestamp,
      this.timestampLastViewed,
      this.duration,
      this.size,
      this.url_website,
      this.url_video_low,
      this.url_video_hd,
      this.filmlisteTimestamp,
      this.url_video,
      this.url_subtitle});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'progress': progress,
      'channel': channel,
      'topic': topic,
      'description': description,
      'title': title,
      'timestamp': timestamp,
      'timestampLastViewed': timestampLastViewed,
      'duration': duration,
      'size': size,
      'url_website': url_website,
      'url_video_low': url_video_low,
      'url_video_hd': url_video_hd,
      'filmlisteTimestamp': filmlisteTimestamp,
      'url_video': url_video,
      'url_subtitle': url_subtitle,
    };
    return map;
  }

  VideoProgressEntity.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        progress = json['progress'],
        channel = json['channel'],
        topic = json['topic'],
        description = json['description'],
        title = json['title'],
        timestamp = json['timestamp'],
        timestampLastViewed = json['timestampLastViewed'],
        duration = json['duration'],
        size = json['size'],
        url_website = json['url_website'],
        url_video_low = json['url_video_low'],
        url_video_hd = json['url_video_hd'],
        filmlisteTimestamp = json['filmlisteTimestamp'],
        url_video = json['url_video'],
        url_subtitle = json['url_subtitle'];
}
