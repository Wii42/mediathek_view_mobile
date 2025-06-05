// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VideosTableTable extends VideosTable
    with TableInfo<$VideosTableTable, VideoEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VideosTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _channelMeta =
      const VerificationMeta('channel');
  @override
  late final GeneratedColumn<String> channel = GeneratedColumn<String>(
      'channel', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
      'topic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _timestampVideoSavedMeta =
      const VerificationMeta('timestampVideoSaved');
  @override
  late final GeneratedColumn<DateTime> timestampVideoSaved =
      GeneratedColumn<DateTime>('timestamp_video_saved', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Duration?, int> duration =
      GeneratedColumn<int>('duration', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<Duration?>($VideosTableTable.$converterduration);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
      'size', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Uri?, String> urlWebsite =
      GeneratedColumn<String>('url_website', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Uri?>($VideosTableTable.$converterurlWebsite);
  @override
  late final GeneratedColumnWithTypeConverter<Uri?, String> urlVideoLow =
      GeneratedColumn<String>('url_video_low', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Uri?>($VideosTableTable.$converterurlVideoLow);
  @override
  late final GeneratedColumnWithTypeConverter<Uri?, String> urlVideoHd =
      GeneratedColumn<String>('url_video_hd', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Uri?>($VideosTableTable.$converterurlVideoHd);
  static const VerificationMeta _filmlisteTimestampMeta =
      const VerificationMeta('filmlisteTimestamp');
  @override
  late final GeneratedColumn<DateTime> filmlisteTimestamp =
      GeneratedColumn<DateTime>('filmliste_timestamp', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Uri?, String> urlVideo =
      GeneratedColumn<String>('url_video', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Uri?>($VideosTableTable.$converterurlVideo);
  @override
  late final GeneratedColumnWithTypeConverter<Uri?, String> urlSubtitle =
      GeneratedColumn<String>('url_subtitle', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Uri?>($VideosTableTable.$converterurlSubtitle);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
      'rating', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        taskId,
        channel,
        topic,
        description,
        title,
        timestamp,
        timestampVideoSaved,
        duration,
        size,
        urlWebsite,
        urlVideoLow,
        urlVideoHd,
        filmlisteTimestamp,
        urlVideo,
        urlSubtitle,
        filePath,
        fileName,
        mimeType,
        rating
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'videos_table';
  @override
  VerificationContext validateIntegrity(Insertable<VideoEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('channel')) {
      context.handle(_channelMeta,
          channel.isAcceptableOrUnknown(data['channel']!, _channelMeta));
    } else if (isInserting) {
      context.missing(_channelMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
          _topicMeta, topic.isAcceptableOrUnknown(data['topic']!, _topicMeta));
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('timestamp_video_saved')) {
      context.handle(
          _timestampVideoSavedMeta,
          timestampVideoSaved.isAcceptableOrUnknown(
              data['timestamp_video_saved']!, _timestampVideoSavedMeta));
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    }
    if (data.containsKey('filmliste_timestamp')) {
      context.handle(
          _filmlisteTimestampMeta,
          filmlisteTimestamp.isAcceptableOrUnknown(
              data['filmliste_timestamp']!, _filmlisteTimestampMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VideoEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VideoEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      channel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel'])!,
      topic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp']),
      timestampVideoSaved: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}timestamp_video_saved']),
      duration: $VideosTableTable.$converterduration.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])),
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size']),
      urlWebsite: $VideosTableTable.$converterurlWebsite.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}url_website'])),
      urlVideoLow: $VideosTableTable.$converterurlVideoLow.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}url_video_low'])),
      urlVideoHd: $VideosTableTable.$converterurlVideoHd.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}url_video_hd'])),
      filmlisteTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}filmliste_timestamp']),
      urlVideo: $VideosTableTable.$converterurlVideo.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url_video'])),
      urlSubtitle: $VideosTableTable.$converterurlSubtitle.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}url_subtitle'])),
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path']),
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name']),
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type']),
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rating']),
    );
  }

  @override
  $VideosTableTable createAlias(String alias) {
    return $VideosTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Duration?, int?> $converterduration =
      const DurationConverter();
  static TypeConverter<Uri?, String?> $converterurlWebsite =
      const UriConverter();
  static TypeConverter<Uri?, String?> $converterurlVideoLow =
      const UriConverter();
  static TypeConverter<Uri?, String?> $converterurlVideoHd =
      const UriConverter();
  static TypeConverter<Uri?, String?> $converterurlVideo = const UriConverter();
  static TypeConverter<Uri?, String?> $converterurlSubtitle =
      const UriConverter();
}

class VideoEntity extends DataClass implements Insertable<VideoEntity> {
  final String id;
  final String taskId;
  final String channel;
  final String topic;
  final String? description;
  final String title;
  final DateTime? timestamp;
  final DateTime? timestampVideoSaved;
  final Duration? duration;
  final int? size;
  final Uri? urlWebsite;
  final Uri? urlVideoLow;
  final Uri? urlVideoHd;
  final DateTime? filmlisteTimestamp;
  final Uri? urlVideo;
  final Uri? urlSubtitle;
  final String? filePath;
  final String? fileName;
  final String? mimeType;
  final double? rating;
  const VideoEntity(
      {required this.id,
      required this.taskId,
      required this.channel,
      required this.topic,
      this.description,
      required this.title,
      this.timestamp,
      this.timestampVideoSaved,
      this.duration,
      this.size,
      this.urlWebsite,
      this.urlVideoLow,
      this.urlVideoHd,
      this.filmlisteTimestamp,
      this.urlVideo,
      this.urlSubtitle,
      this.filePath,
      this.fileName,
      this.mimeType,
      this.rating});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['channel'] = Variable<String>(channel);
    map['topic'] = Variable<String>(topic);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || timestamp != null) {
      map['timestamp'] = Variable<DateTime>(timestamp);
    }
    if (!nullToAbsent || timestampVideoSaved != null) {
      map['timestamp_video_saved'] = Variable<DateTime>(timestampVideoSaved);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] =
          Variable<int>($VideosTableTable.$converterduration.toSql(duration));
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    if (!nullToAbsent || urlWebsite != null) {
      map['url_website'] = Variable<String>(
          $VideosTableTable.$converterurlWebsite.toSql(urlWebsite));
    }
    if (!nullToAbsent || urlVideoLow != null) {
      map['url_video_low'] = Variable<String>(
          $VideosTableTable.$converterurlVideoLow.toSql(urlVideoLow));
    }
    if (!nullToAbsent || urlVideoHd != null) {
      map['url_video_hd'] = Variable<String>(
          $VideosTableTable.$converterurlVideoHd.toSql(urlVideoHd));
    }
    if (!nullToAbsent || filmlisteTimestamp != null) {
      map['filmliste_timestamp'] = Variable<DateTime>(filmlisteTimestamp);
    }
    if (!nullToAbsent || urlVideo != null) {
      map['url_video'] = Variable<String>(
          $VideosTableTable.$converterurlVideo.toSql(urlVideo));
    }
    if (!nullToAbsent || urlSubtitle != null) {
      map['url_subtitle'] = Variable<String>(
          $VideosTableTable.$converterurlSubtitle.toSql(urlSubtitle));
    }
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || fileName != null) {
      map['file_name'] = Variable<String>(fileName);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    return map;
  }

  VideosTableCompanion toCompanion(bool nullToAbsent) {
    return VideosTableCompanion(
      id: Value(id),
      taskId: Value(taskId),
      channel: Value(channel),
      topic: Value(topic),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      title: Value(title),
      timestamp: timestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(timestamp),
      timestampVideoSaved: timestampVideoSaved == null && nullToAbsent
          ? const Value.absent()
          : Value(timestampVideoSaved),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      urlWebsite: urlWebsite == null && nullToAbsent
          ? const Value.absent()
          : Value(urlWebsite),
      urlVideoLow: urlVideoLow == null && nullToAbsent
          ? const Value.absent()
          : Value(urlVideoLow),
      urlVideoHd: urlVideoHd == null && nullToAbsent
          ? const Value.absent()
          : Value(urlVideoHd),
      filmlisteTimestamp: filmlisteTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(filmlisteTimestamp),
      urlVideo: urlVideo == null && nullToAbsent
          ? const Value.absent()
          : Value(urlVideo),
      urlSubtitle: urlSubtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(urlSubtitle),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      fileName: fileName == null && nullToAbsent
          ? const Value.absent()
          : Value(fileName),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      rating:
          rating == null && nullToAbsent ? const Value.absent() : Value(rating),
    );
  }

  factory VideoEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VideoEntity(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      channel: serializer.fromJson<String>(json['channel']),
      topic: serializer.fromJson<String>(json['topic']),
      description: serializer.fromJson<String?>(json['description']),
      title: serializer.fromJson<String>(json['title']),
      timestamp: serializer.fromJson<DateTime?>(json['timestamp']),
      timestampVideoSaved:
          serializer.fromJson<DateTime?>(json['timestampVideoSaved']),
      duration: serializer.fromJson<Duration?>(json['duration']),
      size: serializer.fromJson<int?>(json['size']),
      urlWebsite: serializer.fromJson<Uri?>(json['urlWebsite']),
      urlVideoLow: serializer.fromJson<Uri?>(json['urlVideoLow']),
      urlVideoHd: serializer.fromJson<Uri?>(json['urlVideoHd']),
      filmlisteTimestamp:
          serializer.fromJson<DateTime?>(json['filmlisteTimestamp']),
      urlVideo: serializer.fromJson<Uri?>(json['urlVideo']),
      urlSubtitle: serializer.fromJson<Uri?>(json['urlSubtitle']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      fileName: serializer.fromJson<String?>(json['fileName']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      rating: serializer.fromJson<double?>(json['rating']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'channel': serializer.toJson<String>(channel),
      'topic': serializer.toJson<String>(topic),
      'description': serializer.toJson<String?>(description),
      'title': serializer.toJson<String>(title),
      'timestamp': serializer.toJson<DateTime?>(timestamp),
      'timestampVideoSaved': serializer.toJson<DateTime?>(timestampVideoSaved),
      'duration': serializer.toJson<Duration?>(duration),
      'size': serializer.toJson<int?>(size),
      'urlWebsite': serializer.toJson<Uri?>(urlWebsite),
      'urlVideoLow': serializer.toJson<Uri?>(urlVideoLow),
      'urlVideoHd': serializer.toJson<Uri?>(urlVideoHd),
      'filmlisteTimestamp': serializer.toJson<DateTime?>(filmlisteTimestamp),
      'urlVideo': serializer.toJson<Uri?>(urlVideo),
      'urlSubtitle': serializer.toJson<Uri?>(urlSubtitle),
      'filePath': serializer.toJson<String?>(filePath),
      'fileName': serializer.toJson<String?>(fileName),
      'mimeType': serializer.toJson<String?>(mimeType),
      'rating': serializer.toJson<double?>(rating),
    };
  }

  VideoEntity copyWith(
          {String? id,
          String? taskId,
          String? channel,
          String? topic,
          Value<String?> description = const Value.absent(),
          String? title,
          Value<DateTime?> timestamp = const Value.absent(),
          Value<DateTime?> timestampVideoSaved = const Value.absent(),
          Value<Duration?> duration = const Value.absent(),
          Value<int?> size = const Value.absent(),
          Value<Uri?> urlWebsite = const Value.absent(),
          Value<Uri?> urlVideoLow = const Value.absent(),
          Value<Uri?> urlVideoHd = const Value.absent(),
          Value<DateTime?> filmlisteTimestamp = const Value.absent(),
          Value<Uri?> urlVideo = const Value.absent(),
          Value<Uri?> urlSubtitle = const Value.absent(),
          Value<String?> filePath = const Value.absent(),
          Value<String?> fileName = const Value.absent(),
          Value<String?> mimeType = const Value.absent(),
          Value<double?> rating = const Value.absent()}) =>
      VideoEntity(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        channel: channel ?? this.channel,
        topic: topic ?? this.topic,
        description: description.present ? description.value : this.description,
        title: title ?? this.title,
        timestamp: timestamp.present ? timestamp.value : this.timestamp,
        timestampVideoSaved: timestampVideoSaved.present
            ? timestampVideoSaved.value
            : this.timestampVideoSaved,
        duration: duration.present ? duration.value : this.duration,
        size: size.present ? size.value : this.size,
        urlWebsite: urlWebsite.present ? urlWebsite.value : this.urlWebsite,
        urlVideoLow: urlVideoLow.present ? urlVideoLow.value : this.urlVideoLow,
        urlVideoHd: urlVideoHd.present ? urlVideoHd.value : this.urlVideoHd,
        filmlisteTimestamp: filmlisteTimestamp.present
            ? filmlisteTimestamp.value
            : this.filmlisteTimestamp,
        urlVideo: urlVideo.present ? urlVideo.value : this.urlVideo,
        urlSubtitle: urlSubtitle.present ? urlSubtitle.value : this.urlSubtitle,
        filePath: filePath.present ? filePath.value : this.filePath,
        fileName: fileName.present ? fileName.value : this.fileName,
        mimeType: mimeType.present ? mimeType.value : this.mimeType,
        rating: rating.present ? rating.value : this.rating,
      );
  VideoEntity copyWithCompanion(VideosTableCompanion data) {
    return VideoEntity(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      channel: data.channel.present ? data.channel.value : this.channel,
      topic: data.topic.present ? data.topic.value : this.topic,
      description:
          data.description.present ? data.description.value : this.description,
      title: data.title.present ? data.title.value : this.title,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      timestampVideoSaved: data.timestampVideoSaved.present
          ? data.timestampVideoSaved.value
          : this.timestampVideoSaved,
      duration: data.duration.present ? data.duration.value : this.duration,
      size: data.size.present ? data.size.value : this.size,
      urlWebsite:
          data.urlWebsite.present ? data.urlWebsite.value : this.urlWebsite,
      urlVideoLow:
          data.urlVideoLow.present ? data.urlVideoLow.value : this.urlVideoLow,
      urlVideoHd:
          data.urlVideoHd.present ? data.urlVideoHd.value : this.urlVideoHd,
      filmlisteTimestamp: data.filmlisteTimestamp.present
          ? data.filmlisteTimestamp.value
          : this.filmlisteTimestamp,
      urlVideo: data.urlVideo.present ? data.urlVideo.value : this.urlVideo,
      urlSubtitle:
          data.urlSubtitle.present ? data.urlSubtitle.value : this.urlSubtitle,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      rating: data.rating.present ? data.rating.value : this.rating,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VideoEntity(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('channel: $channel, ')
          ..write('topic: $topic, ')
          ..write('description: $description, ')
          ..write('title: $title, ')
          ..write('timestamp: $timestamp, ')
          ..write('timestampVideoSaved: $timestampVideoSaved, ')
          ..write('duration: $duration, ')
          ..write('size: $size, ')
          ..write('urlWebsite: $urlWebsite, ')
          ..write('urlVideoLow: $urlVideoLow, ')
          ..write('urlVideoHd: $urlVideoHd, ')
          ..write('filmlisteTimestamp: $filmlisteTimestamp, ')
          ..write('urlVideo: $urlVideo, ')
          ..write('urlSubtitle: $urlSubtitle, ')
          ..write('filePath: $filePath, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('rating: $rating')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      taskId,
      channel,
      topic,
      description,
      title,
      timestamp,
      timestampVideoSaved,
      duration,
      size,
      urlWebsite,
      urlVideoLow,
      urlVideoHd,
      filmlisteTimestamp,
      urlVideo,
      urlSubtitle,
      filePath,
      fileName,
      mimeType,
      rating);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoEntity &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.channel == this.channel &&
          other.topic == this.topic &&
          other.description == this.description &&
          other.title == this.title &&
          other.timestamp == this.timestamp &&
          other.timestampVideoSaved == this.timestampVideoSaved &&
          other.duration == this.duration &&
          other.size == this.size &&
          other.urlWebsite == this.urlWebsite &&
          other.urlVideoLow == this.urlVideoLow &&
          other.urlVideoHd == this.urlVideoHd &&
          other.filmlisteTimestamp == this.filmlisteTimestamp &&
          other.urlVideo == this.urlVideo &&
          other.urlSubtitle == this.urlSubtitle &&
          other.filePath == this.filePath &&
          other.fileName == this.fileName &&
          other.mimeType == this.mimeType &&
          other.rating == this.rating);
}

class VideosTableCompanion extends UpdateCompanion<VideoEntity> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> channel;
  final Value<String> topic;
  final Value<String?> description;
  final Value<String> title;
  final Value<DateTime?> timestamp;
  final Value<DateTime?> timestampVideoSaved;
  final Value<Duration?> duration;
  final Value<int?> size;
  final Value<Uri?> urlWebsite;
  final Value<Uri?> urlVideoLow;
  final Value<Uri?> urlVideoHd;
  final Value<DateTime?> filmlisteTimestamp;
  final Value<Uri?> urlVideo;
  final Value<Uri?> urlSubtitle;
  final Value<String?> filePath;
  final Value<String?> fileName;
  final Value<String?> mimeType;
  final Value<double?> rating;
  final Value<int> rowid;
  const VideosTableCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.channel = const Value.absent(),
    this.topic = const Value.absent(),
    this.description = const Value.absent(),
    this.title = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.timestampVideoSaved = const Value.absent(),
    this.duration = const Value.absent(),
    this.size = const Value.absent(),
    this.urlWebsite = const Value.absent(),
    this.urlVideoLow = const Value.absent(),
    this.urlVideoHd = const Value.absent(),
    this.filmlisteTimestamp = const Value.absent(),
    this.urlVideo = const Value.absent(),
    this.urlSubtitle = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.rating = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VideosTableCompanion.insert({
    required String id,
    required String taskId,
    required String channel,
    required String topic,
    this.description = const Value.absent(),
    required String title,
    this.timestamp = const Value.absent(),
    this.timestampVideoSaved = const Value.absent(),
    this.duration = const Value.absent(),
    this.size = const Value.absent(),
    this.urlWebsite = const Value.absent(),
    this.urlVideoLow = const Value.absent(),
    this.urlVideoHd = const Value.absent(),
    this.filmlisteTimestamp = const Value.absent(),
    this.urlVideo = const Value.absent(),
    this.urlSubtitle = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.rating = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        channel = Value(channel),
        topic = Value(topic),
        title = Value(title);
  static Insertable<VideoEntity> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? channel,
    Expression<String>? topic,
    Expression<String>? description,
    Expression<String>? title,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? timestampVideoSaved,
    Expression<int>? duration,
    Expression<int>? size,
    Expression<String>? urlWebsite,
    Expression<String>? urlVideoLow,
    Expression<String>? urlVideoHd,
    Expression<DateTime>? filmlisteTimestamp,
    Expression<String>? urlVideo,
    Expression<String>? urlSubtitle,
    Expression<String>? filePath,
    Expression<String>? fileName,
    Expression<String>? mimeType,
    Expression<double>? rating,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (channel != null) 'channel': channel,
      if (topic != null) 'topic': topic,
      if (description != null) 'description': description,
      if (title != null) 'title': title,
      if (timestamp != null) 'timestamp': timestamp,
      if (timestampVideoSaved != null)
        'timestamp_video_saved': timestampVideoSaved,
      if (duration != null) 'duration': duration,
      if (size != null) 'size': size,
      if (urlWebsite != null) 'url_website': urlWebsite,
      if (urlVideoLow != null) 'url_video_low': urlVideoLow,
      if (urlVideoHd != null) 'url_video_hd': urlVideoHd,
      if (filmlisteTimestamp != null) 'filmliste_timestamp': filmlisteTimestamp,
      if (urlVideo != null) 'url_video': urlVideo,
      if (urlSubtitle != null) 'url_subtitle': urlSubtitle,
      if (filePath != null) 'file_path': filePath,
      if (fileName != null) 'file_name': fileName,
      if (mimeType != null) 'mime_type': mimeType,
      if (rating != null) 'rating': rating,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VideosTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<String>? channel,
      Value<String>? topic,
      Value<String?>? description,
      Value<String>? title,
      Value<DateTime?>? timestamp,
      Value<DateTime?>? timestampVideoSaved,
      Value<Duration?>? duration,
      Value<int?>? size,
      Value<Uri?>? urlWebsite,
      Value<Uri?>? urlVideoLow,
      Value<Uri?>? urlVideoHd,
      Value<DateTime?>? filmlisteTimestamp,
      Value<Uri?>? urlVideo,
      Value<Uri?>? urlSubtitle,
      Value<String?>? filePath,
      Value<String?>? fileName,
      Value<String?>? mimeType,
      Value<double?>? rating,
      Value<int>? rowid}) {
    return VideosTableCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      channel: channel ?? this.channel,
      topic: topic ?? this.topic,
      description: description ?? this.description,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      timestampVideoSaved: timestampVideoSaved ?? this.timestampVideoSaved,
      duration: duration ?? this.duration,
      size: size ?? this.size,
      urlWebsite: urlWebsite ?? this.urlWebsite,
      urlVideoLow: urlVideoLow ?? this.urlVideoLow,
      urlVideoHd: urlVideoHd ?? this.urlVideoHd,
      filmlisteTimestamp: filmlisteTimestamp ?? this.filmlisteTimestamp,
      urlVideo: urlVideo ?? this.urlVideo,
      urlSubtitle: urlSubtitle ?? this.urlSubtitle,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      rating: rating ?? this.rating,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(channel.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (timestampVideoSaved.present) {
      map['timestamp_video_saved'] =
          Variable<DateTime>(timestampVideoSaved.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(
          $VideosTableTable.$converterduration.toSql(duration.value));
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (urlWebsite.present) {
      map['url_website'] = Variable<String>(
          $VideosTableTable.$converterurlWebsite.toSql(urlWebsite.value));
    }
    if (urlVideoLow.present) {
      map['url_video_low'] = Variable<String>(
          $VideosTableTable.$converterurlVideoLow.toSql(urlVideoLow.value));
    }
    if (urlVideoHd.present) {
      map['url_video_hd'] = Variable<String>(
          $VideosTableTable.$converterurlVideoHd.toSql(urlVideoHd.value));
    }
    if (filmlisteTimestamp.present) {
      map['filmliste_timestamp'] = Variable<DateTime>(filmlisteTimestamp.value);
    }
    if (urlVideo.present) {
      map['url_video'] = Variable<String>(
          $VideosTableTable.$converterurlVideo.toSql(urlVideo.value));
    }
    if (urlSubtitle.present) {
      map['url_subtitle'] = Variable<String>(
          $VideosTableTable.$converterurlSubtitle.toSql(urlSubtitle.value));
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VideosTableCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('channel: $channel, ')
          ..write('topic: $topic, ')
          ..write('description: $description, ')
          ..write('title: $title, ')
          ..write('timestamp: $timestamp, ')
          ..write('timestampVideoSaved: $timestampVideoSaved, ')
          ..write('duration: $duration, ')
          ..write('size: $size, ')
          ..write('urlWebsite: $urlWebsite, ')
          ..write('urlVideoLow: $urlVideoLow, ')
          ..write('urlVideoHd: $urlVideoHd, ')
          ..write('filmlisteTimestamp: $filmlisteTimestamp, ')
          ..write('urlVideo: $urlVideo, ')
          ..write('urlSubtitle: $urlSubtitle, ')
          ..write('filePath: $filePath, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('rating: $rating, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VideosTableTable videosTable = $VideosTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [videosTable];
}

typedef $$VideosTableTableCreateCompanionBuilder = VideosTableCompanion
    Function({
  required String id,
  required String taskId,
  required String channel,
  required String topic,
  Value<String?> description,
  required String title,
  Value<DateTime?> timestamp,
  Value<DateTime?> timestampVideoSaved,
  Value<Duration?> duration,
  Value<int?> size,
  Value<Uri?> urlWebsite,
  Value<Uri?> urlVideoLow,
  Value<Uri?> urlVideoHd,
  Value<DateTime?> filmlisteTimestamp,
  Value<Uri?> urlVideo,
  Value<Uri?> urlSubtitle,
  Value<String?> filePath,
  Value<String?> fileName,
  Value<String?> mimeType,
  Value<double?> rating,
  Value<int> rowid,
});
typedef $$VideosTableTableUpdateCompanionBuilder = VideosTableCompanion
    Function({
  Value<String> id,
  Value<String> taskId,
  Value<String> channel,
  Value<String> topic,
  Value<String?> description,
  Value<String> title,
  Value<DateTime?> timestamp,
  Value<DateTime?> timestampVideoSaved,
  Value<Duration?> duration,
  Value<int?> size,
  Value<Uri?> urlWebsite,
  Value<Uri?> urlVideoLow,
  Value<Uri?> urlVideoHd,
  Value<DateTime?> filmlisteTimestamp,
  Value<Uri?> urlVideo,
  Value<Uri?> urlSubtitle,
  Value<String?> filePath,
  Value<String?> fileName,
  Value<String?> mimeType,
  Value<double?> rating,
  Value<int> rowid,
});

class $$VideosTableTableFilterComposer
    extends Composer<_$AppDatabase, $VideosTableTable> {
  $$VideosTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get channel => $composableBuilder(
      column: $table.channel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topic => $composableBuilder(
      column: $table.topic, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestampVideoSaved => $composableBuilder(
      column: $table.timestampVideoSaved,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Duration?, Duration, int> get duration =>
      $composableBuilder(
          column: $table.duration,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Uri?, Uri, String> get urlWebsite =>
      $composableBuilder(
          column: $table.urlWebsite,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Uri?, Uri, String> get urlVideoLow =>
      $composableBuilder(
          column: $table.urlVideoLow,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Uri?, Uri, String> get urlVideoHd =>
      $composableBuilder(
          column: $table.urlVideoHd,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get filmlisteTimestamp => $composableBuilder(
      column: $table.filmlisteTimestamp,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Uri?, Uri, String> get urlVideo =>
      $composableBuilder(
          column: $table.urlVideo,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Uri?, Uri, String> get urlSubtitle =>
      $composableBuilder(
          column: $table.urlSubtitle,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));
}

class $$VideosTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VideosTableTable> {
  $$VideosTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get channel => $composableBuilder(
      column: $table.channel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topic => $composableBuilder(
      column: $table.topic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestampVideoSaved => $composableBuilder(
      column: $table.timestampVideoSaved,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get urlWebsite => $composableBuilder(
      column: $table.urlWebsite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get urlVideoLow => $composableBuilder(
      column: $table.urlVideoLow, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get urlVideoHd => $composableBuilder(
      column: $table.urlVideoHd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get filmlisteTimestamp => $composableBuilder(
      column: $table.filmlisteTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get urlVideo => $composableBuilder(
      column: $table.urlVideo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get urlSubtitle => $composableBuilder(
      column: $table.urlSubtitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));
}

class $$VideosTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VideosTableTable> {
  $$VideosTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<DateTime> get timestampVideoSaved => $composableBuilder(
      column: $table.timestampVideoSaved, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Duration?, int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Uri?, String> get urlWebsite =>
      $composableBuilder(
          column: $table.urlWebsite, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Uri?, String> get urlVideoLow =>
      $composableBuilder(
          column: $table.urlVideoLow, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Uri?, String> get urlVideoHd =>
      $composableBuilder(
          column: $table.urlVideoHd, builder: (column) => column);

  GeneratedColumn<DateTime> get filmlisteTimestamp => $composableBuilder(
      column: $table.filmlisteTimestamp, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Uri?, String> get urlVideo =>
      $composableBuilder(column: $table.urlVideo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Uri?, String> get urlSubtitle =>
      $composableBuilder(
          column: $table.urlSubtitle, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);
}

class $$VideosTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VideosTableTable,
    VideoEntity,
    $$VideosTableTableFilterComposer,
    $$VideosTableTableOrderingComposer,
    $$VideosTableTableAnnotationComposer,
    $$VideosTableTableCreateCompanionBuilder,
    $$VideosTableTableUpdateCompanionBuilder,
    (
      VideoEntity,
      BaseReferences<_$AppDatabase, $VideosTableTable, VideoEntity>
    ),
    VideoEntity,
    PrefetchHooks Function()> {
  $$VideosTableTableTableManager(_$AppDatabase db, $VideosTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VideosTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VideosTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VideosTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<String> channel = const Value.absent(),
            Value<String> topic = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime?> timestamp = const Value.absent(),
            Value<DateTime?> timestampVideoSaved = const Value.absent(),
            Value<Duration?> duration = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<Uri?> urlWebsite = const Value.absent(),
            Value<Uri?> urlVideoLow = const Value.absent(),
            Value<Uri?> urlVideoHd = const Value.absent(),
            Value<DateTime?> filmlisteTimestamp = const Value.absent(),
            Value<Uri?> urlVideo = const Value.absent(),
            Value<Uri?> urlSubtitle = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<String?> fileName = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<double?> rating = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VideosTableCompanion(
            id: id,
            taskId: taskId,
            channel: channel,
            topic: topic,
            description: description,
            title: title,
            timestamp: timestamp,
            timestampVideoSaved: timestampVideoSaved,
            duration: duration,
            size: size,
            urlWebsite: urlWebsite,
            urlVideoLow: urlVideoLow,
            urlVideoHd: urlVideoHd,
            filmlisteTimestamp: filmlisteTimestamp,
            urlVideo: urlVideo,
            urlSubtitle: urlSubtitle,
            filePath: filePath,
            fileName: fileName,
            mimeType: mimeType,
            rating: rating,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            required String channel,
            required String topic,
            Value<String?> description = const Value.absent(),
            required String title,
            Value<DateTime?> timestamp = const Value.absent(),
            Value<DateTime?> timestampVideoSaved = const Value.absent(),
            Value<Duration?> duration = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<Uri?> urlWebsite = const Value.absent(),
            Value<Uri?> urlVideoLow = const Value.absent(),
            Value<Uri?> urlVideoHd = const Value.absent(),
            Value<DateTime?> filmlisteTimestamp = const Value.absent(),
            Value<Uri?> urlVideo = const Value.absent(),
            Value<Uri?> urlSubtitle = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<String?> fileName = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<double?> rating = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VideosTableCompanion.insert(
            id: id,
            taskId: taskId,
            channel: channel,
            topic: topic,
            description: description,
            title: title,
            timestamp: timestamp,
            timestampVideoSaved: timestampVideoSaved,
            duration: duration,
            size: size,
            urlWebsite: urlWebsite,
            urlVideoLow: urlVideoLow,
            urlVideoHd: urlVideoHd,
            filmlisteTimestamp: filmlisteTimestamp,
            urlVideo: urlVideo,
            urlSubtitle: urlSubtitle,
            filePath: filePath,
            fileName: fileName,
            mimeType: mimeType,
            rating: rating,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VideosTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VideosTableTable,
    VideoEntity,
    $$VideosTableTableFilterComposer,
    $$VideosTableTableOrderingComposer,
    $$VideosTableTableAnnotationComposer,
    $$VideosTableTableCreateCompanionBuilder,
    $$VideosTableTableUpdateCompanionBuilder,
    (
      VideoEntity,
      BaseReferences<_$AppDatabase, $VideosTableTable, VideoEntity>
    ),
    VideoEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VideosTableTableTableManager get videosTable =>
      $$VideosTableTableTableManager(_db, _db.videosTable);
}
