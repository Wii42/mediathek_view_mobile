import 'package:json_annotation/json_annotation.dart';

import '../util/date_time_parser.dart';

part 'video.g.dart';

@JsonSerializable()
class Video {
  String? channel;
  String? topic;
  String? title;
  String? description;
  @JsonKey(
      fromJson: DateTimeParser.fromSecondsSinceEpoch,
      toJson: DateTimeParser.toSecondsSinceEpoch)
  DateTime? timestamp;
  @JsonKey(fromJson: _DurationFromJson, toJson: _DurationToJson)
  Duration? duration;
  int? size;
  Uri? url_website;
  Uri? url_subtitle;
  Uri? url_video;
  Uri? url_video_low;
  Uri? url_video_hd;
  @JsonKey(
      fromJson: DateTimeParser.fromSecondsSinceEpochString,
      toJson: DateTimeParser.toSecondsSinceEpochString)
  DateTime? filmlisteTimestamp;
  String? id;

  Video(this.id);

  static Video fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);

  @override
  String toString() {
    return 'Video{channel: $channel, topic: $topic, title: $title, description: $description, timestamp: $timestamp, duration: $duration, size: $size, url_website: $url_website, url_subtitle: $url_subtitle, url_video: $url_video, url_video_low: $url_video_low, url_video_hd: $url_video_hd, filmlisteTimestamp: $filmlisteTimestamp, id: $id}';
  }

  static Duration? _DurationFromJson(num? timeS) =>
      timeS != null ? Duration(seconds: timeS.toInt()) : null;

  static int? _DurationToJson(Duration? duration) => duration?.inSeconds;
}
