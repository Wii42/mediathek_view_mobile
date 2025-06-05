// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      json['id'] as String?,
    )
      ..channel = json['channel'] as String?
      ..topic = json['topic'] as String?
      ..title = json['title'] as String?
      ..description = json['description'] as String?
      ..timestamp =
          DateTimeParser.fromSecondsSinceEpoch(json['timestamp'] as num?)
      ..duration = DurationParser.fromSeconds(json['duration'] as num?)
      ..size = (json['size'] as num?)?.toInt()
      ..url_website = json['url_website'] == null
          ? null
          : Uri.parse(json['url_website'] as String)
      ..url_subtitle = json['url_subtitle'] == null
          ? null
          : Uri.parse(json['url_subtitle'] as String)
      ..url_video = json['url_video'] == null
          ? null
          : Uri.parse(json['url_video'] as String)
      ..url_video_low = json['url_video_low'] == null
          ? null
          : Uri.parse(json['url_video_low'] as String)
      ..url_video_hd = json['url_video_hd'] == null
          ? null
          : Uri.parse(json['url_video_hd'] as String)
      ..filmlisteTimestamp = DateTimeParser.fromSecondsSinceEpochString(
          json['filmlisteTimestamp'] as String?);

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'channel': instance.channel,
      'topic': instance.topic,
      'title': instance.title,
      'description': instance.description,
      'timestamp': DateTimeParser.toSecondsSinceEpoch(instance.timestamp),
      'duration': DurationParser.toSeconds(instance.duration),
      'size': instance.size,
      'url_website': instance.url_website?.toString(),
      'url_subtitle': instance.url_subtitle?.toString(),
      'url_video': instance.url_video?.toString(),
      'url_video_low': instance.url_video_low?.toString(),
      'url_video_hd': instance.url_video_hd?.toString(),
      'filmlisteTimestamp':
          DateTimeParser.toSecondsSinceEpochString(instance.filmlisteTimestamp),
      'id': instance.id,
    };
