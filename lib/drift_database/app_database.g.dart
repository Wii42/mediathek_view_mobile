// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VideosTable extends Videos with TableInfo<$VideosTable, VideoEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VideosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  @override
  late final GeneratedColumnWithTypeConverter<Duration?, int> duration =
      GeneratedColumn<int>('duration', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<Duration?>($VideosTable.$converterdurationn);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
      'size', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Uri?, String> urlWebsite =
      GeneratedColumn<String>('url_website', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Uri?>($VideosTable.$converterurlWebsiten);
  @override
  late final GeneratedColumnWithTypeConverter<Uri?, String> urlVideoLow =
      GeneratedColumn<String>('url_video_low', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Uri?>($VideosTable.$converterurlVideoLown);
  @override
  late final GeneratedColumnWithTypeConverter<Uri?, String> urlVideoHd =
      GeneratedColumn<String>('url_video_hd', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Uri?>($VideosTable.$converterurlVideoHdn);
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
          .withConverter<Uri?>($VideosTable.$converterurlVideon);
  @override
  late final GeneratedColumnWithTypeConverter<Uri?, String> urlSubtitle =
      GeneratedColumn<String>('url_subtitle', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Uri?>($VideosTable.$converterurlSubtitlen);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _timestampVideoSavedMeta =
      const VerificationMeta('timestampVideoSaved');
  @override
  late final GeneratedColumn<DateTime> timestampVideoSaved =
      GeneratedColumn<DateTime>('timestamp_video_saved', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
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
        channel,
        topic,
        description,
        title,
        timestamp,
        duration,
        size,
        urlWebsite,
        urlVideoLow,
        urlVideoHd,
        filmlisteTimestamp,
        urlVideo,
        urlSubtitle,
        taskId,
        timestampVideoSaved,
        filePath,
        fileName,
        mimeType,
        rating
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'videos';
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
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('timestamp_video_saved')) {
      context.handle(
          _timestampVideoSavedMeta,
          timestampVideoSaved.isAcceptableOrUnknown(
              data['timestamp_video_saved']!, _timestampVideoSavedMeta));
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
      duration: $VideosTable.$converterdurationn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])),
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size']),
      urlWebsite: $VideosTable.$converterurlWebsiten.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url_website'])),
      urlVideoLow: $VideosTable.$converterurlVideoLown.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url_video_low'])),
      urlVideoHd: $VideosTable.$converterurlVideoHdn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url_video_hd'])),
      filmlisteTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}filmliste_timestamp']),
      urlVideo: $VideosTable.$converterurlVideon.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url_video'])),
      urlSubtitle: $VideosTable.$converterurlSubtitlen.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url_subtitle'])),
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      timestampVideoSaved: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}timestamp_video_saved']),
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
  $VideosTable createAlias(String alias) {
    return $VideosTable(attachedDatabase, alias);
  }

  static TypeConverter<Duration, int> $converterduration =
      const DurationConverter();
  static TypeConverter<Duration?, int?> $converterdurationn =
      NullAwareTypeConverter.wrap($converterduration);
  static TypeConverter<Uri, String> $converterurlWebsite = const UriConverter();
  static TypeConverter<Uri?, String?> $converterurlWebsiten =
      NullAwareTypeConverter.wrap($converterurlWebsite);
  static TypeConverter<Uri, String> $converterurlVideoLow =
      const UriConverter();
  static TypeConverter<Uri?, String?> $converterurlVideoLown =
      NullAwareTypeConverter.wrap($converterurlVideoLow);
  static TypeConverter<Uri, String> $converterurlVideoHd = const UriConverter();
  static TypeConverter<Uri?, String?> $converterurlVideoHdn =
      NullAwareTypeConverter.wrap($converterurlVideoHd);
  static TypeConverter<Uri, String> $converterurlVideo = const UriConverter();
  static TypeConverter<Uri?, String?> $converterurlVideon =
      NullAwareTypeConverter.wrap($converterurlVideo);
  static TypeConverter<Uri, String> $converterurlSubtitle =
      const UriConverter();
  static TypeConverter<Uri?, String?> $converterurlSubtitlen =
      NullAwareTypeConverter.wrap($converterurlSubtitle);
}

class VideoEntity extends DataClass implements Insertable<VideoEntity> {
  final String id;
  final String channel;
  final String topic;
  final String? description;
  final String title;
  final DateTime? timestamp;
  final Duration? duration;
  final int? size;
  final Uri? urlWebsite;
  final Uri? urlVideoLow;
  final Uri? urlVideoHd;
  final DateTime? filmlisteTimestamp;
  final Uri? urlVideo;
  final Uri? urlSubtitle;
  final String taskId;
  final DateTime? timestampVideoSaved;
  final String? filePath;
  final String? fileName;
  final String? mimeType;
  final double? rating;
  const VideoEntity(
      {required this.id,
      required this.channel,
      required this.topic,
      this.description,
      required this.title,
      this.timestamp,
      this.duration,
      this.size,
      this.urlWebsite,
      this.urlVideoLow,
      this.urlVideoHd,
      this.filmlisteTimestamp,
      this.urlVideo,
      this.urlSubtitle,
      required this.taskId,
      this.timestampVideoSaved,
      this.filePath,
      this.fileName,
      this.mimeType,
      this.rating});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['channel'] = Variable<String>(channel);
    map['topic'] = Variable<String>(topic);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || timestamp != null) {
      map['timestamp'] = Variable<DateTime>(timestamp);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] =
          Variable<int>($VideosTable.$converterdurationn.toSql(duration));
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    if (!nullToAbsent || urlWebsite != null) {
      map['url_website'] = Variable<String>(
          $VideosTable.$converterurlWebsiten.toSql(urlWebsite));
    }
    if (!nullToAbsent || urlVideoLow != null) {
      map['url_video_low'] = Variable<String>(
          $VideosTable.$converterurlVideoLown.toSql(urlVideoLow));
    }
    if (!nullToAbsent || urlVideoHd != null) {
      map['url_video_hd'] = Variable<String>(
          $VideosTable.$converterurlVideoHdn.toSql(urlVideoHd));
    }
    if (!nullToAbsent || filmlisteTimestamp != null) {
      map['filmliste_timestamp'] = Variable<DateTime>(filmlisteTimestamp);
    }
    if (!nullToAbsent || urlVideo != null) {
      map['url_video'] =
          Variable<String>($VideosTable.$converterurlVideon.toSql(urlVideo));
    }
    if (!nullToAbsent || urlSubtitle != null) {
      map['url_subtitle'] = Variable<String>(
          $VideosTable.$converterurlSubtitlen.toSql(urlSubtitle));
    }
    map['task_id'] = Variable<String>(taskId);
    if (!nullToAbsent || timestampVideoSaved != null) {
      map['timestamp_video_saved'] = Variable<DateTime>(timestampVideoSaved);
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

  VideosCompanion toCompanion(bool nullToAbsent) {
    return VideosCompanion(
      id: Value(id),
      channel: Value(channel),
      topic: Value(topic),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      title: Value(title),
      timestamp: timestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(timestamp),
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
      taskId: Value(taskId),
      timestampVideoSaved: timestampVideoSaved == null && nullToAbsent
          ? const Value.absent()
          : Value(timestampVideoSaved),
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
      channel: serializer.fromJson<String>(json['channel']),
      topic: serializer.fromJson<String>(json['topic']),
      description: serializer.fromJson<String?>(json['description']),
      title: serializer.fromJson<String>(json['title']),
      timestamp: serializer.fromJson<DateTime?>(json['timestamp']),
      duration: serializer.fromJson<Duration?>(json['duration']),
      size: serializer.fromJson<int?>(json['size']),
      urlWebsite: serializer.fromJson<Uri?>(json['urlWebsite']),
      urlVideoLow: serializer.fromJson<Uri?>(json['urlVideoLow']),
      urlVideoHd: serializer.fromJson<Uri?>(json['urlVideoHd']),
      filmlisteTimestamp:
          serializer.fromJson<DateTime?>(json['filmlisteTimestamp']),
      urlVideo: serializer.fromJson<Uri?>(json['urlVideo']),
      urlSubtitle: serializer.fromJson<Uri?>(json['urlSubtitle']),
      taskId: serializer.fromJson<String>(json['taskId']),
      timestampVideoSaved:
          serializer.fromJson<DateTime?>(json['timestampVideoSaved']),
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
      'channel': serializer.toJson<String>(channel),
      'topic': serializer.toJson<String>(topic),
      'description': serializer.toJson<String?>(description),
      'title': serializer.toJson<String>(title),
      'timestamp': serializer.toJson<DateTime?>(timestamp),
      'duration': serializer.toJson<Duration?>(duration),
      'size': serializer.toJson<int?>(size),
      'urlWebsite': serializer.toJson<Uri?>(urlWebsite),
      'urlVideoLow': serializer.toJson<Uri?>(urlVideoLow),
      'urlVideoHd': serializer.toJson<Uri?>(urlVideoHd),
      'filmlisteTimestamp': serializer.toJson<DateTime?>(filmlisteTimestamp),
      'urlVideo': serializer.toJson<Uri?>(urlVideo),
      'urlSubtitle': serializer.toJson<Uri?>(urlSubtitle),
      'taskId': serializer.toJson<String>(taskId),
      'timestampVideoSaved': serializer.toJson<DateTime?>(timestampVideoSaved),
      'filePath': serializer.toJson<String?>(filePath),
      'fileName': serializer.toJson<String?>(fileName),
      'mimeType': serializer.toJson<String?>(mimeType),
      'rating': serializer.toJson<double?>(rating),
    };
  }

  VideoEntity copyWith(
          {String? id,
          String? channel,
          String? topic,
          Value<String?> description = const Value.absent(),
          String? title,
          Value<DateTime?> timestamp = const Value.absent(),
          Value<Duration?> duration = const Value.absent(),
          Value<int?> size = const Value.absent(),
          Value<Uri?> urlWebsite = const Value.absent(),
          Value<Uri?> urlVideoLow = const Value.absent(),
          Value<Uri?> urlVideoHd = const Value.absent(),
          Value<DateTime?> filmlisteTimestamp = const Value.absent(),
          Value<Uri?> urlVideo = const Value.absent(),
          Value<Uri?> urlSubtitle = const Value.absent(),
          String? taskId,
          Value<DateTime?> timestampVideoSaved = const Value.absent(),
          Value<String?> filePath = const Value.absent(),
          Value<String?> fileName = const Value.absent(),
          Value<String?> mimeType = const Value.absent(),
          Value<double?> rating = const Value.absent()}) =>
      VideoEntity(
        id: id ?? this.id,
        channel: channel ?? this.channel,
        topic: topic ?? this.topic,
        description: description.present ? description.value : this.description,
        title: title ?? this.title,
        timestamp: timestamp.present ? timestamp.value : this.timestamp,
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
        taskId: taskId ?? this.taskId,
        timestampVideoSaved: timestampVideoSaved.present
            ? timestampVideoSaved.value
            : this.timestampVideoSaved,
        filePath: filePath.present ? filePath.value : this.filePath,
        fileName: fileName.present ? fileName.value : this.fileName,
        mimeType: mimeType.present ? mimeType.value : this.mimeType,
        rating: rating.present ? rating.value : this.rating,
      );
  VideoEntity copyWithCompanion(VideosCompanion data) {
    return VideoEntity(
      id: data.id.present ? data.id.value : this.id,
      channel: data.channel.present ? data.channel.value : this.channel,
      topic: data.topic.present ? data.topic.value : this.topic,
      description:
          data.description.present ? data.description.value : this.description,
      title: data.title.present ? data.title.value : this.title,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
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
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      timestampVideoSaved: data.timestampVideoSaved.present
          ? data.timestampVideoSaved.value
          : this.timestampVideoSaved,
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
          ..write('channel: $channel, ')
          ..write('topic: $topic, ')
          ..write('description: $description, ')
          ..write('title: $title, ')
          ..write('timestamp: $timestamp, ')
          ..write('duration: $duration, ')
          ..write('size: $size, ')
          ..write('urlWebsite: $urlWebsite, ')
          ..write('urlVideoLow: $urlVideoLow, ')
          ..write('urlVideoHd: $urlVideoHd, ')
          ..write('filmlisteTimestamp: $filmlisteTimestamp, ')
          ..write('urlVideo: $urlVideo, ')
          ..write('urlSubtitle: $urlSubtitle, ')
          ..write('taskId: $taskId, ')
          ..write('timestampVideoSaved: $timestampVideoSaved, ')
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
      channel,
      topic,
      description,
      title,
      timestamp,
      duration,
      size,
      urlWebsite,
      urlVideoLow,
      urlVideoHd,
      filmlisteTimestamp,
      urlVideo,
      urlSubtitle,
      taskId,
      timestampVideoSaved,
      filePath,
      fileName,
      mimeType,
      rating);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoEntity &&
          other.id == this.id &&
          other.channel == this.channel &&
          other.topic == this.topic &&
          other.description == this.description &&
          other.title == this.title &&
          other.timestamp == this.timestamp &&
          other.duration == this.duration &&
          other.size == this.size &&
          other.urlWebsite == this.urlWebsite &&
          other.urlVideoLow == this.urlVideoLow &&
          other.urlVideoHd == this.urlVideoHd &&
          other.filmlisteTimestamp == this.filmlisteTimestamp &&
          other.urlVideo == this.urlVideo &&
          other.urlSubtitle == this.urlSubtitle &&
          other.taskId == this.taskId &&
          other.timestampVideoSaved == this.timestampVideoSaved &&
          other.filePath == this.filePath &&
          other.fileName == this.fileName &&
          other.mimeType == this.mimeType &&
          other.rating == this.rating);
}

class VideosCompanion extends UpdateCompanion<VideoEntity> {
  final Value<String> id;
  final Value<String> channel;
  final Value<String> topic;
  final Value<String?> description;
  final Value<String> title;
  final Value<DateTime?> timestamp;
  final Value<Duration?> duration;
  final Value<int?> size;
  final Value<Uri?> urlWebsite;
  final Value<Uri?> urlVideoLow;
  final Value<Uri?> urlVideoHd;
  final Value<DateTime?> filmlisteTimestamp;
  final Value<Uri?> urlVideo;
  final Value<Uri?> urlSubtitle;
  final Value<String> taskId;
  final Value<DateTime?> timestampVideoSaved;
  final Value<String?> filePath;
  final Value<String?> fileName;
  final Value<String?> mimeType;
  final Value<double?> rating;
  final Value<int> rowid;
  const VideosCompanion({
    this.id = const Value.absent(),
    this.channel = const Value.absent(),
    this.topic = const Value.absent(),
    this.description = const Value.absent(),
    this.title = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.duration = const Value.absent(),
    this.size = const Value.absent(),
    this.urlWebsite = const Value.absent(),
    this.urlVideoLow = const Value.absent(),
    this.urlVideoHd = const Value.absent(),
    this.filmlisteTimestamp = const Value.absent(),
    this.urlVideo = const Value.absent(),
    this.urlSubtitle = const Value.absent(),
    this.taskId = const Value.absent(),
    this.timestampVideoSaved = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.rating = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VideosCompanion.insert({
    required String id,
    required String channel,
    required String topic,
    this.description = const Value.absent(),
    required String title,
    this.timestamp = const Value.absent(),
    this.duration = const Value.absent(),
    this.size = const Value.absent(),
    this.urlWebsite = const Value.absent(),
    this.urlVideoLow = const Value.absent(),
    this.urlVideoHd = const Value.absent(),
    this.filmlisteTimestamp = const Value.absent(),
    this.urlVideo = const Value.absent(),
    this.urlSubtitle = const Value.absent(),
    required String taskId,
    this.timestampVideoSaved = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.rating = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        channel = Value(channel),
        topic = Value(topic),
        title = Value(title),
        taskId = Value(taskId);
  static Insertable<VideoEntity> custom({
    Expression<String>? id,
    Expression<String>? channel,
    Expression<String>? topic,
    Expression<String>? description,
    Expression<String>? title,
    Expression<DateTime>? timestamp,
    Expression<int>? duration,
    Expression<int>? size,
    Expression<String>? urlWebsite,
    Expression<String>? urlVideoLow,
    Expression<String>? urlVideoHd,
    Expression<DateTime>? filmlisteTimestamp,
    Expression<String>? urlVideo,
    Expression<String>? urlSubtitle,
    Expression<String>? taskId,
    Expression<DateTime>? timestampVideoSaved,
    Expression<String>? filePath,
    Expression<String>? fileName,
    Expression<String>? mimeType,
    Expression<double>? rating,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channel != null) 'channel': channel,
      if (topic != null) 'topic': topic,
      if (description != null) 'description': description,
      if (title != null) 'title': title,
      if (timestamp != null) 'timestamp': timestamp,
      if (duration != null) 'duration': duration,
      if (size != null) 'size': size,
      if (urlWebsite != null) 'url_website': urlWebsite,
      if (urlVideoLow != null) 'url_video_low': urlVideoLow,
      if (urlVideoHd != null) 'url_video_hd': urlVideoHd,
      if (filmlisteTimestamp != null) 'filmliste_timestamp': filmlisteTimestamp,
      if (urlVideo != null) 'url_video': urlVideo,
      if (urlSubtitle != null) 'url_subtitle': urlSubtitle,
      if (taskId != null) 'task_id': taskId,
      if (timestampVideoSaved != null)
        'timestamp_video_saved': timestampVideoSaved,
      if (filePath != null) 'file_path': filePath,
      if (fileName != null) 'file_name': fileName,
      if (mimeType != null) 'mime_type': mimeType,
      if (rating != null) 'rating': rating,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VideosCompanion copyWith(
      {Value<String>? id,
      Value<String>? channel,
      Value<String>? topic,
      Value<String?>? description,
      Value<String>? title,
      Value<DateTime?>? timestamp,
      Value<Duration?>? duration,
      Value<int?>? size,
      Value<Uri?>? urlWebsite,
      Value<Uri?>? urlVideoLow,
      Value<Uri?>? urlVideoHd,
      Value<DateTime?>? filmlisteTimestamp,
      Value<Uri?>? urlVideo,
      Value<Uri?>? urlSubtitle,
      Value<String>? taskId,
      Value<DateTime?>? timestampVideoSaved,
      Value<String?>? filePath,
      Value<String?>? fileName,
      Value<String?>? mimeType,
      Value<double?>? rating,
      Value<int>? rowid}) {
    return VideosCompanion(
      id: id ?? this.id,
      channel: channel ?? this.channel,
      topic: topic ?? this.topic,
      description: description ?? this.description,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      duration: duration ?? this.duration,
      size: size ?? this.size,
      urlWebsite: urlWebsite ?? this.urlWebsite,
      urlVideoLow: urlVideoLow ?? this.urlVideoLow,
      urlVideoHd: urlVideoHd ?? this.urlVideoHd,
      filmlisteTimestamp: filmlisteTimestamp ?? this.filmlisteTimestamp,
      urlVideo: urlVideo ?? this.urlVideo,
      urlSubtitle: urlSubtitle ?? this.urlSubtitle,
      taskId: taskId ?? this.taskId,
      timestampVideoSaved: timestampVideoSaved ?? this.timestampVideoSaved,
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
    if (duration.present) {
      map['duration'] =
          Variable<int>($VideosTable.$converterdurationn.toSql(duration.value));
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (urlWebsite.present) {
      map['url_website'] = Variable<String>(
          $VideosTable.$converterurlWebsiten.toSql(urlWebsite.value));
    }
    if (urlVideoLow.present) {
      map['url_video_low'] = Variable<String>(
          $VideosTable.$converterurlVideoLown.toSql(urlVideoLow.value));
    }
    if (urlVideoHd.present) {
      map['url_video_hd'] = Variable<String>(
          $VideosTable.$converterurlVideoHdn.toSql(urlVideoHd.value));
    }
    if (filmlisteTimestamp.present) {
      map['filmliste_timestamp'] = Variable<DateTime>(filmlisteTimestamp.value);
    }
    if (urlVideo.present) {
      map['url_video'] = Variable<String>(
          $VideosTable.$converterurlVideon.toSql(urlVideo.value));
    }
    if (urlSubtitle.present) {
      map['url_subtitle'] = Variable<String>(
          $VideosTable.$converterurlSubtitlen.toSql(urlSubtitle.value));
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (timestampVideoSaved.present) {
      map['timestamp_video_saved'] =
          Variable<DateTime>(timestampVideoSaved.value);
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
    return (StringBuffer('VideosCompanion(')
          ..write('id: $id, ')
          ..write('channel: $channel, ')
          ..write('topic: $topic, ')
          ..write('description: $description, ')
          ..write('title: $title, ')
          ..write('timestamp: $timestamp, ')
          ..write('duration: $duration, ')
          ..write('size: $size, ')
          ..write('urlWebsite: $urlWebsite, ')
          ..write('urlVideoLow: $urlVideoLow, ')
          ..write('urlVideoHd: $urlVideoHd, ')
          ..write('filmlisteTimestamp: $filmlisteTimestamp, ')
          ..write('urlVideo: $urlVideo, ')
          ..write('urlSubtitle: $urlSubtitle, ')
          ..write('taskId: $taskId, ')
          ..write('timestampVideoSaved: $timestampVideoSaved, ')
          ..write('filePath: $filePath, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('rating: $rating, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VideoProgressTable extends VideoProgress
    with TableInfo<$VideoProgressTable, VideoProgressEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VideoProgressTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<Duration?, int> progress =
      GeneratedColumn<int>('progress', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<Duration?>($VideoProgressTable.$converterprogressn);
  static const VerificationMeta _timestampLastViewedMeta =
      const VerificationMeta('timestampLastViewed');
  @override
  late final GeneratedColumn<DateTime> timestampLastViewed =
      GeneratedColumn<DateTime>('timestamp_last_viewed', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [progress, timestampLastViewed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'video_progress';
  @override
  VerificationContext validateIntegrity(
      Insertable<VideoProgressEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('timestamp_last_viewed')) {
      context.handle(
          _timestampLastViewedMeta,
          timestampLastViewed.isAcceptableOrUnknown(
              data['timestamp_last_viewed']!, _timestampLastViewedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  VideoProgressEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VideoProgressEntity(
      progress: $VideoProgressTable.$converterprogressn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])),
      timestampLastViewed: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}timestamp_last_viewed']),
    );
  }

  @override
  $VideoProgressTable createAlias(String alias) {
    return $VideoProgressTable(attachedDatabase, alias);
  }

  static TypeConverter<Duration, int> $converterprogress =
      const DurationConverter();
  static TypeConverter<Duration?, int?> $converterprogressn =
      NullAwareTypeConverter.wrap($converterprogress);
}

class VideoProgressEntity extends DataClass
    implements Insertable<VideoProgressEntity> {
  final Duration? progress;
  final DateTime? timestampLastViewed;
  const VideoProgressEntity({this.progress, this.timestampLastViewed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || progress != null) {
      map['progress'] = Variable<int>(
          $VideoProgressTable.$converterprogressn.toSql(progress));
    }
    if (!nullToAbsent || timestampLastViewed != null) {
      map['timestamp_last_viewed'] = Variable<DateTime>(timestampLastViewed);
    }
    return map;
  }

  VideoProgressCompanion toCompanion(bool nullToAbsent) {
    return VideoProgressCompanion(
      progress: progress == null && nullToAbsent
          ? const Value.absent()
          : Value(progress),
      timestampLastViewed: timestampLastViewed == null && nullToAbsent
          ? const Value.absent()
          : Value(timestampLastViewed),
    );
  }

  factory VideoProgressEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VideoProgressEntity(
      progress: serializer.fromJson<Duration?>(json['progress']),
      timestampLastViewed:
          serializer.fromJson<DateTime?>(json['timestampLastViewed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'progress': serializer.toJson<Duration?>(progress),
      'timestampLastViewed': serializer.toJson<DateTime?>(timestampLastViewed),
    };
  }

  VideoProgressEntity copyWith(
          {Value<Duration?> progress = const Value.absent(),
          Value<DateTime?> timestampLastViewed = const Value.absent()}) =>
      VideoProgressEntity(
        progress: progress.present ? progress.value : this.progress,
        timestampLastViewed: timestampLastViewed.present
            ? timestampLastViewed.value
            : this.timestampLastViewed,
      );
  VideoProgressEntity copyWithCompanion(VideoProgressCompanion data) {
    return VideoProgressEntity(
      progress: data.progress.present ? data.progress.value : this.progress,
      timestampLastViewed: data.timestampLastViewed.present
          ? data.timestampLastViewed.value
          : this.timestampLastViewed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VideoProgressEntity(')
          ..write('progress: $progress, ')
          ..write('timestampLastViewed: $timestampLastViewed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(progress, timestampLastViewed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoProgressEntity &&
          other.progress == this.progress &&
          other.timestampLastViewed == this.timestampLastViewed);
}

class VideoProgressCompanion extends UpdateCompanion<VideoProgressEntity> {
  final Value<Duration?> progress;
  final Value<DateTime?> timestampLastViewed;
  final Value<int> rowid;
  const VideoProgressCompanion({
    this.progress = const Value.absent(),
    this.timestampLastViewed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VideoProgressCompanion.insert({
    this.progress = const Value.absent(),
    this.timestampLastViewed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<VideoProgressEntity> custom({
    Expression<int>? progress,
    Expression<DateTime>? timestampLastViewed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (progress != null) 'progress': progress,
      if (timestampLastViewed != null)
        'timestamp_last_viewed': timestampLastViewed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VideoProgressCompanion copyWith(
      {Value<Duration?>? progress,
      Value<DateTime?>? timestampLastViewed,
      Value<int>? rowid}) {
    return VideoProgressCompanion(
      progress: progress ?? this.progress,
      timestampLastViewed: timestampLastViewed ?? this.timestampLastViewed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (progress.present) {
      map['progress'] = Variable<int>(
          $VideoProgressTable.$converterprogressn.toSql(progress.value));
    }
    if (timestampLastViewed.present) {
      map['timestamp_last_viewed'] =
          Variable<DateTime>(timestampLastViewed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VideoProgressCompanion(')
          ..write('progress: $progress, ')
          ..write('timestampLastViewed: $timestampLastViewed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelFavoritesTable extends ChannelFavorites
    with TableInfo<$ChannelFavoritesTable, ChannelFavorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelFavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _channelNameMeta =
      const VerificationMeta('channelName');
  @override
  late final GeneratedColumn<String> channelName = GeneratedColumn<String>(
      'channel_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _groupNameMeta =
      const VerificationMeta('groupName');
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
      'group_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _logoMeta = const VerificationMeta('logo');
  @override
  late final GeneratedColumn<String> logo = GeneratedColumn<String>(
      'logo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Uri, String> url =
      GeneratedColumn<String>('url', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Uri>($ChannelFavoritesTable.$converterurl);
  @override
  List<GeneratedColumn> get $columns => [channelName, groupName, logo, url];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_favorites';
  @override
  VerificationContext validateIntegrity(Insertable<ChannelFavorite> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('channel_name')) {
      context.handle(
          _channelNameMeta,
          channelName.isAcceptableOrUnknown(
              data['channel_name']!, _channelNameMeta));
    } else if (isInserting) {
      context.missing(_channelNameMeta);
    }
    if (data.containsKey('group_name')) {
      context.handle(_groupNameMeta,
          groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta));
    } else if (isInserting) {
      context.missing(_groupNameMeta);
    }
    if (data.containsKey('logo')) {
      context.handle(
          _logoMeta, logo.isAcceptableOrUnknown(data['logo']!, _logoMeta));
    } else if (isInserting) {
      context.missing(_logoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {channelName};
  @override
  ChannelFavorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelFavorite(
      channelName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel_name'])!,
      groupName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_name'])!,
      logo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo'])!,
      url: $ChannelFavoritesTable.$converterurl.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!),
    );
  }

  @override
  $ChannelFavoritesTable createAlias(String alias) {
    return $ChannelFavoritesTable(attachedDatabase, alias);
  }

  static TypeConverter<Uri, String> $converterurl = const UriConverter();
}

class ChannelFavorite extends DataClass implements Insertable<ChannelFavorite> {
  final String channelName;
  final String groupName;
  final String logo;
  final Uri url;
  const ChannelFavorite(
      {required this.channelName,
      required this.groupName,
      required this.logo,
      required this.url});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['channel_name'] = Variable<String>(channelName);
    map['group_name'] = Variable<String>(groupName);
    map['logo'] = Variable<String>(logo);
    {
      map['url'] =
          Variable<String>($ChannelFavoritesTable.$converterurl.toSql(url));
    }
    return map;
  }

  ChannelFavoritesCompanion toCompanion(bool nullToAbsent) {
    return ChannelFavoritesCompanion(
      channelName: Value(channelName),
      groupName: Value(groupName),
      logo: Value(logo),
      url: Value(url),
    );
  }

  factory ChannelFavorite.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelFavorite(
      channelName: serializer.fromJson<String>(json['channelName']),
      groupName: serializer.fromJson<String>(json['groupName']),
      logo: serializer.fromJson<String>(json['logo']),
      url: serializer.fromJson<Uri>(json['url']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'channelName': serializer.toJson<String>(channelName),
      'groupName': serializer.toJson<String>(groupName),
      'logo': serializer.toJson<String>(logo),
      'url': serializer.toJson<Uri>(url),
    };
  }

  ChannelFavorite copyWith(
          {String? channelName, String? groupName, String? logo, Uri? url}) =>
      ChannelFavorite(
        channelName: channelName ?? this.channelName,
        groupName: groupName ?? this.groupName,
        logo: logo ?? this.logo,
        url: url ?? this.url,
      );
  ChannelFavorite copyWithCompanion(ChannelFavoritesCompanion data) {
    return ChannelFavorite(
      channelName:
          data.channelName.present ? data.channelName.value : this.channelName,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      logo: data.logo.present ? data.logo.value : this.logo,
      url: data.url.present ? data.url.value : this.url,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelFavorite(')
          ..write('channelName: $channelName, ')
          ..write('groupName: $groupName, ')
          ..write('logo: $logo, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(channelName, groupName, logo, url);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelFavorite &&
          other.channelName == this.channelName &&
          other.groupName == this.groupName &&
          other.logo == this.logo &&
          other.url == this.url);
}

class ChannelFavoritesCompanion extends UpdateCompanion<ChannelFavorite> {
  final Value<String> channelName;
  final Value<String> groupName;
  final Value<String> logo;
  final Value<Uri> url;
  final Value<int> rowid;
  const ChannelFavoritesCompanion({
    this.channelName = const Value.absent(),
    this.groupName = const Value.absent(),
    this.logo = const Value.absent(),
    this.url = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelFavoritesCompanion.insert({
    required String channelName,
    required String groupName,
    required String logo,
    required Uri url,
    this.rowid = const Value.absent(),
  })  : channelName = Value(channelName),
        groupName = Value(groupName),
        logo = Value(logo),
        url = Value(url);
  static Insertable<ChannelFavorite> custom({
    Expression<String>? channelName,
    Expression<String>? groupName,
    Expression<String>? logo,
    Expression<String>? url,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (channelName != null) 'channel_name': channelName,
      if (groupName != null) 'group_name': groupName,
      if (logo != null) 'logo': logo,
      if (url != null) 'url': url,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelFavoritesCompanion copyWith(
      {Value<String>? channelName,
      Value<String>? groupName,
      Value<String>? logo,
      Value<Uri>? url,
      Value<int>? rowid}) {
    return ChannelFavoritesCompanion(
      channelName: channelName ?? this.channelName,
      groupName: groupName ?? this.groupName,
      logo: logo ?? this.logo,
      url: url ?? this.url,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (channelName.present) {
      map['channel_name'] = Variable<String>(channelName.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (logo.present) {
      map['logo'] = Variable<String>(logo.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(
          $ChannelFavoritesTable.$converterurl.toSql(url.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelFavoritesCompanion(')
          ..write('channelName: $channelName, ')
          ..write('groupName: $groupName, ')
          ..write('logo: $logo, ')
          ..write('url: $url, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VideosTable videos = $VideosTable(this);
  late final $VideoProgressTable videoProgress = $VideoProgressTable(this);
  late final $ChannelFavoritesTable channelFavorites =
      $ChannelFavoritesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [videos, videoProgress, channelFavorites];
}

typedef $$VideosTableCreateCompanionBuilder = VideosCompanion Function({
  required String id,
  required String channel,
  required String topic,
  Value<String?> description,
  required String title,
  Value<DateTime?> timestamp,
  Value<Duration?> duration,
  Value<int?> size,
  Value<Uri?> urlWebsite,
  Value<Uri?> urlVideoLow,
  Value<Uri?> urlVideoHd,
  Value<DateTime?> filmlisteTimestamp,
  Value<Uri?> urlVideo,
  Value<Uri?> urlSubtitle,
  required String taskId,
  Value<DateTime?> timestampVideoSaved,
  Value<String?> filePath,
  Value<String?> fileName,
  Value<String?> mimeType,
  Value<double?> rating,
  Value<int> rowid,
});
typedef $$VideosTableUpdateCompanionBuilder = VideosCompanion Function({
  Value<String> id,
  Value<String> channel,
  Value<String> topic,
  Value<String?> description,
  Value<String> title,
  Value<DateTime?> timestamp,
  Value<Duration?> duration,
  Value<int?> size,
  Value<Uri?> urlWebsite,
  Value<Uri?> urlVideoLow,
  Value<Uri?> urlVideoHd,
  Value<DateTime?> filmlisteTimestamp,
  Value<Uri?> urlVideo,
  Value<Uri?> urlSubtitle,
  Value<String> taskId,
  Value<DateTime?> timestampVideoSaved,
  Value<String?> filePath,
  Value<String?> fileName,
  Value<String?> mimeType,
  Value<double?> rating,
  Value<int> rowid,
});

class $$VideosTableFilterComposer
    extends Composer<_$AppDatabase, $VideosTable> {
  $$VideosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

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

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestampVideoSaved => $composableBuilder(
      column: $table.timestampVideoSaved,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));
}

class $$VideosTableOrderingComposer
    extends Composer<_$AppDatabase, $VideosTable> {
  $$VideosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

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

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestampVideoSaved => $composableBuilder(
      column: $table.timestampVideoSaved,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));
}

class $$VideosTableAnnotationComposer
    extends Composer<_$AppDatabase, $VideosTable> {
  $$VideosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

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

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestampVideoSaved => $composableBuilder(
      column: $table.timestampVideoSaved, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);
}

class $$VideosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VideosTable,
    VideoEntity,
    $$VideosTableFilterComposer,
    $$VideosTableOrderingComposer,
    $$VideosTableAnnotationComposer,
    $$VideosTableCreateCompanionBuilder,
    $$VideosTableUpdateCompanionBuilder,
    (VideoEntity, BaseReferences<_$AppDatabase, $VideosTable, VideoEntity>),
    VideoEntity,
    PrefetchHooks Function()> {
  $$VideosTableTableManager(_$AppDatabase db, $VideosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VideosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VideosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VideosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> channel = const Value.absent(),
            Value<String> topic = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime?> timestamp = const Value.absent(),
            Value<Duration?> duration = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<Uri?> urlWebsite = const Value.absent(),
            Value<Uri?> urlVideoLow = const Value.absent(),
            Value<Uri?> urlVideoHd = const Value.absent(),
            Value<DateTime?> filmlisteTimestamp = const Value.absent(),
            Value<Uri?> urlVideo = const Value.absent(),
            Value<Uri?> urlSubtitle = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<DateTime?> timestampVideoSaved = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<String?> fileName = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<double?> rating = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VideosCompanion(
            id: id,
            channel: channel,
            topic: topic,
            description: description,
            title: title,
            timestamp: timestamp,
            duration: duration,
            size: size,
            urlWebsite: urlWebsite,
            urlVideoLow: urlVideoLow,
            urlVideoHd: urlVideoHd,
            filmlisteTimestamp: filmlisteTimestamp,
            urlVideo: urlVideo,
            urlSubtitle: urlSubtitle,
            taskId: taskId,
            timestampVideoSaved: timestampVideoSaved,
            filePath: filePath,
            fileName: fileName,
            mimeType: mimeType,
            rating: rating,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String channel,
            required String topic,
            Value<String?> description = const Value.absent(),
            required String title,
            Value<DateTime?> timestamp = const Value.absent(),
            Value<Duration?> duration = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<Uri?> urlWebsite = const Value.absent(),
            Value<Uri?> urlVideoLow = const Value.absent(),
            Value<Uri?> urlVideoHd = const Value.absent(),
            Value<DateTime?> filmlisteTimestamp = const Value.absent(),
            Value<Uri?> urlVideo = const Value.absent(),
            Value<Uri?> urlSubtitle = const Value.absent(),
            required String taskId,
            Value<DateTime?> timestampVideoSaved = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<String?> fileName = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<double?> rating = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VideosCompanion.insert(
            id: id,
            channel: channel,
            topic: topic,
            description: description,
            title: title,
            timestamp: timestamp,
            duration: duration,
            size: size,
            urlWebsite: urlWebsite,
            urlVideoLow: urlVideoLow,
            urlVideoHd: urlVideoHd,
            filmlisteTimestamp: filmlisteTimestamp,
            urlVideo: urlVideo,
            urlSubtitle: urlSubtitle,
            taskId: taskId,
            timestampVideoSaved: timestampVideoSaved,
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

typedef $$VideosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VideosTable,
    VideoEntity,
    $$VideosTableFilterComposer,
    $$VideosTableOrderingComposer,
    $$VideosTableAnnotationComposer,
    $$VideosTableCreateCompanionBuilder,
    $$VideosTableUpdateCompanionBuilder,
    (VideoEntity, BaseReferences<_$AppDatabase, $VideosTable, VideoEntity>),
    VideoEntity,
    PrefetchHooks Function()>;
typedef $$VideoProgressTableCreateCompanionBuilder = VideoProgressCompanion
    Function({
  Value<Duration?> progress,
  Value<DateTime?> timestampLastViewed,
  Value<int> rowid,
});
typedef $$VideoProgressTableUpdateCompanionBuilder = VideoProgressCompanion
    Function({
  Value<Duration?> progress,
  Value<DateTime?> timestampLastViewed,
  Value<int> rowid,
});

class $$VideoProgressTableFilterComposer
    extends Composer<_$AppDatabase, $VideoProgressTable> {
  $$VideoProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<Duration?, Duration, int> get progress =>
      $composableBuilder(
          column: $table.progress,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get timestampLastViewed => $composableBuilder(
      column: $table.timestampLastViewed,
      builder: (column) => ColumnFilters(column));
}

class $$VideoProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $VideoProgressTable> {
  $$VideoProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestampLastViewed => $composableBuilder(
      column: $table.timestampLastViewed,
      builder: (column) => ColumnOrderings(column));
}

class $$VideoProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $VideoProgressTable> {
  $$VideoProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<Duration?, int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<DateTime> get timestampLastViewed => $composableBuilder(
      column: $table.timestampLastViewed, builder: (column) => column);
}

class $$VideoProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VideoProgressTable,
    VideoProgressEntity,
    $$VideoProgressTableFilterComposer,
    $$VideoProgressTableOrderingComposer,
    $$VideoProgressTableAnnotationComposer,
    $$VideoProgressTableCreateCompanionBuilder,
    $$VideoProgressTableUpdateCompanionBuilder,
    (
      VideoProgressEntity,
      BaseReferences<_$AppDatabase, $VideoProgressTable, VideoProgressEntity>
    ),
    VideoProgressEntity,
    PrefetchHooks Function()> {
  $$VideoProgressTableTableManager(_$AppDatabase db, $VideoProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VideoProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VideoProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VideoProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<Duration?> progress = const Value.absent(),
            Value<DateTime?> timestampLastViewed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VideoProgressCompanion(
            progress: progress,
            timestampLastViewed: timestampLastViewed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<Duration?> progress = const Value.absent(),
            Value<DateTime?> timestampLastViewed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VideoProgressCompanion.insert(
            progress: progress,
            timestampLastViewed: timestampLastViewed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VideoProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VideoProgressTable,
    VideoProgressEntity,
    $$VideoProgressTableFilterComposer,
    $$VideoProgressTableOrderingComposer,
    $$VideoProgressTableAnnotationComposer,
    $$VideoProgressTableCreateCompanionBuilder,
    $$VideoProgressTableUpdateCompanionBuilder,
    (
      VideoProgressEntity,
      BaseReferences<_$AppDatabase, $VideoProgressTable, VideoProgressEntity>
    ),
    VideoProgressEntity,
    PrefetchHooks Function()>;
typedef $$ChannelFavoritesTableCreateCompanionBuilder
    = ChannelFavoritesCompanion Function({
  required String channelName,
  required String groupName,
  required String logo,
  required Uri url,
  Value<int> rowid,
});
typedef $$ChannelFavoritesTableUpdateCompanionBuilder
    = ChannelFavoritesCompanion Function({
  Value<String> channelName,
  Value<String> groupName,
  Value<String> logo,
  Value<Uri> url,
  Value<int> rowid,
});

class $$ChannelFavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $ChannelFavoritesTable> {
  $$ChannelFavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get channelName => $composableBuilder(
      column: $table.channelName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupName => $composableBuilder(
      column: $table.groupName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logo => $composableBuilder(
      column: $table.logo, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Uri, Uri, String> get url =>
      $composableBuilder(
          column: $table.url,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$ChannelFavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChannelFavoritesTable> {
  $$ChannelFavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get channelName => $composableBuilder(
      column: $table.channelName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupName => $composableBuilder(
      column: $table.groupName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logo => $composableBuilder(
      column: $table.logo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));
}

class $$ChannelFavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChannelFavoritesTable> {
  $$ChannelFavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get channelName => $composableBuilder(
      column: $table.channelName, builder: (column) => column);

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<String> get logo =>
      $composableBuilder(column: $table.logo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Uri, String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);
}

class $$ChannelFavoritesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChannelFavoritesTable,
    ChannelFavorite,
    $$ChannelFavoritesTableFilterComposer,
    $$ChannelFavoritesTableOrderingComposer,
    $$ChannelFavoritesTableAnnotationComposer,
    $$ChannelFavoritesTableCreateCompanionBuilder,
    $$ChannelFavoritesTableUpdateCompanionBuilder,
    (
      ChannelFavorite,
      BaseReferences<_$AppDatabase, $ChannelFavoritesTable, ChannelFavorite>
    ),
    ChannelFavorite,
    PrefetchHooks Function()> {
  $$ChannelFavoritesTableTableManager(
      _$AppDatabase db, $ChannelFavoritesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelFavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelFavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelFavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> channelName = const Value.absent(),
            Value<String> groupName = const Value.absent(),
            Value<String> logo = const Value.absent(),
            Value<Uri> url = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChannelFavoritesCompanion(
            channelName: channelName,
            groupName: groupName,
            logo: logo,
            url: url,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String channelName,
            required String groupName,
            required String logo,
            required Uri url,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChannelFavoritesCompanion.insert(
            channelName: channelName,
            groupName: groupName,
            logo: logo,
            url: url,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChannelFavoritesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChannelFavoritesTable,
    ChannelFavorite,
    $$ChannelFavoritesTableFilterComposer,
    $$ChannelFavoritesTableOrderingComposer,
    $$ChannelFavoritesTableAnnotationComposer,
    $$ChannelFavoritesTableCreateCompanionBuilder,
    $$ChannelFavoritesTableUpdateCompanionBuilder,
    (
      ChannelFavorite,
      BaseReferences<_$AppDatabase, $ChannelFavoritesTable, ChannelFavorite>
    ),
    ChannelFavorite,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VideosTableTableManager get videos =>
      $$VideosTableTableManager(_db, _db.videos);
  $$VideoProgressTableTableManager get videoProgress =>
      $$VideoProgressTableTableManager(_db, _db.videoProgress);
  $$ChannelFavoritesTableTableManager get channelFavorites =>
      $$ChannelFavoritesTableTableManager(_db, _db.channelFavorites);
}
