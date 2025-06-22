import 'package:flutter_ws/drift_database/app_database.dart'
    show VideoEntity, VideoProgressEntity;
import 'package:json_annotation/json_annotation.dart';

import '../util/date_time_parser.dart';
import '../util/duration_parser.dart';

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
  @JsonKey(
      fromJson: DurationParser.fromSeconds, toJson: DurationParser.toSeconds)
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

  VideoEntity toVideoEntity({required String taskId}) {
    return VideoEntity(
      id: id!,
      channel: channel ?? "",
      topic: topic ?? "",
      description: description,
      title: title ?? "",
      timestamp: timestamp,
      duration: duration,
      size: size,
      urlWebsite: url_website,
      urlVideoLow: url_video_low,
      urlVideoHd: url_video_hd,
      filmlisteTimestamp: filmlisteTimestamp,
      urlVideo: url_video,
      urlSubtitle: url_subtitle,
      taskId: taskId,
    );
  }

  static Video fromVideoEntity(VideoEntity entity) {
    return Video(entity.id)
      ..channel = entity.channel
      ..topic = entity.topic
      ..description = entity.description
      ..title = entity.title
      ..timestamp = entity.timestamp
      ..duration = entity.duration
      ..size = entity.size
      ..url_website = entity.urlWebsite
      ..url_video_low = entity.urlVideoLow
      ..url_video_hd = entity.urlVideoHd
      ..filmlisteTimestamp = entity.filmlisteTimestamp
      ..url_video = entity.urlVideo
      ..url_subtitle = entity.urlSubtitle;
  }

  VideoProgressEntity toVideoProgressEntity() {
    return VideoProgressEntity(
      id: id!,
      progress: null, // Progress is not part of Video, so we set it to 0
      channel: channel ?? "",
      topic: topic ?? "",
      description: description,
      title: title ?? "",
      timestamp: timestamp,
      duration: duration,
      size: size,
      urlWebsite: url_website,
      urlVideoLow: url_video_low,
      urlVideoHd: url_video_hd,
      filmlisteTimestamp: filmlisteTimestamp,
      urlVideo: url_video,
      urlSubtitle: url_subtitle,
    );
  }

  static Video fromVideoProgressEntity(VideoProgressEntity entity) {
    return Video(entity.id)
      ..channel = entity.channel
      ..topic = entity.topic
      ..description = entity.description
      ..title = entity.title
      ..timestamp = entity.timestamp
      ..duration = entity.duration
      ..size = entity.size
      ..url_website = entity.urlWebsite
      ..url_video_low = entity.urlVideoLow
      ..url_video_hd = entity.urlVideoHd
      ..filmlisteTimestamp = entity.filmlisteTimestamp
      ..url_video = entity.urlVideo
      ..url_subtitle = entity.urlSubtitle;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      channel,
      topic,
      title,
      description,
      timestamp,
      duration,
      size,
      url_website,
      url_subtitle,
      url_video,
      url_video_low,
      url_video_hd,
      filmlisteTimestamp,
      id
    ]);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Video &&
            channel == other.channel &&
            topic == other.topic &&
            title == other.title &&
            description == other.description &&
            timestamp == other.timestamp &&
            duration == other.duration &&
            size == other.size &&
            url_website == other.url_website &&
            url_subtitle == other.url_subtitle &&
            url_video == other.url_video &&
            url_video_low == other.url_video_low &&
            url_video_hd == other.url_video_hd &&
            filmlisteTimestamp == other.filmlisteTimestamp &&
            id == other.id);
  }
}
