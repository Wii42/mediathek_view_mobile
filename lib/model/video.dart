class Video {
  String? id;
  String? channel;
  String? topic;
  String? description;
  String? title;
  int? timestamp;
  int? duration;
  int? size;
  String? url_website;
  String? url_video_low;
  String? url_video_hd;
  String? filmlisteTimestamp;
  String? url_video;
  String? url_subtitle;

  DateTime? get timestampAsDateTime => timestamp != null
      ? DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000, isUtc: true)
      : null;

  Duration? get durationAsDuration =>
      duration != null ? Duration(seconds: duration!) : null;

  Video(this.id);

  Video.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        channel = json['channel'],
        topic = json['topic'],
        description = json['description'],
        title = json['title'],
        timestamp = json['timestamp'],
        duration = int.tryParse(json['duration'].toString()),
        size = json['size'],
        url_website = json['url_website'],
        url_video_low = json['url_video_low'],
        url_video_hd = json['url_video_hd'],
        filmlisteTimestamp = json['filmlisteTimestamp'],
        url_video = json['url_video'],
        url_subtitle = json['url_subtitle'];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'channel': channel,
      'topic': topic,
      'description': description,
      'title': title,
      'timestamp': timestamp,
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
}
