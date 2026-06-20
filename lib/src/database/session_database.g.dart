// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_database.dart';

// ignore_for_file: type=lint
class $SessionTokensTable extends SessionTokens
    with TableInfo<$SessionTokensTable, SessionToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionTokensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refreshTokenMeta = const VerificationMeta(
    'refreshToken',
  );
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
    'refresh_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastRefreshedAtMeta = const VerificationMeta(
    'lastRefreshedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastRefreshedAt =
      GeneratedColumn<DateTime>(
        'last_refreshed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextScheduledRefreshAtMeta =
      const VerificationMeta('nextScheduledRefreshAt');
  @override
  late final GeneratedColumn<DateTime> nextScheduledRefreshAt =
      GeneratedColumn<DateTime>(
        'next_scheduled_refresh_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accessToken,
    refreshToken,
    expiresAt,
    lastRefreshedAt,
    nextScheduledRefreshAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_tokens';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionToken> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accessTokenMeta);
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
        _refreshTokenMeta,
        refreshToken.isAcceptableOrUnknown(
          data['refresh_token']!,
          _refreshTokenMeta,
        ),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('last_refreshed_at')) {
      context.handle(
        _lastRefreshedAtMeta,
        lastRefreshedAt.isAcceptableOrUnknown(
          data['last_refreshed_at']!,
          _lastRefreshedAtMeta,
        ),
      );
    }
    if (data.containsKey('next_scheduled_refresh_at')) {
      context.handle(
        _nextScheduledRefreshAtMeta,
        nextScheduledRefreshAt.isAcceptableOrUnknown(
          data['next_scheduled_refresh_at']!,
          _nextScheduledRefreshAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionToken(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      )!,
      refreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_token'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      lastRefreshedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_refreshed_at'],
      ),
      nextScheduledRefreshAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_scheduled_refresh_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SessionTokensTable createAlias(String alias) {
    return $SessionTokensTable(attachedDatabase, alias);
  }
}

class SessionToken extends DataClass implements Insertable<SessionToken> {
  final int id;
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final DateTime? lastRefreshedAt;
  final DateTime? nextScheduledRefreshAt;
  final DateTime updatedAt;
  const SessionToken({
    required this.id,
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.lastRefreshedAt,
    this.nextScheduledRefreshAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['access_token'] = Variable<String>(accessToken);
    if (!nullToAbsent || refreshToken != null) {
      map['refresh_token'] = Variable<String>(refreshToken);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    if (!nullToAbsent || lastRefreshedAt != null) {
      map['last_refreshed_at'] = Variable<DateTime>(lastRefreshedAt);
    }
    if (!nullToAbsent || nextScheduledRefreshAt != null) {
      map['next_scheduled_refresh_at'] = Variable<DateTime>(
        nextScheduledRefreshAt,
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SessionTokensCompanion toCompanion(bool nullToAbsent) {
    return SessionTokensCompanion(
      id: Value(id),
      accessToken: Value(accessToken),
      refreshToken: refreshToken == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshToken),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      lastRefreshedAt: lastRefreshedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRefreshedAt),
      nextScheduledRefreshAt: nextScheduledRefreshAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextScheduledRefreshAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SessionToken.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionToken(
      id: serializer.fromJson<int>(json['id']),
      accessToken: serializer.fromJson<String>(json['accessToken']),
      refreshToken: serializer.fromJson<String?>(json['refreshToken']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      lastRefreshedAt: serializer.fromJson<DateTime?>(json['lastRefreshedAt']),
      nextScheduledRefreshAt: serializer.fromJson<DateTime?>(
        json['nextScheduledRefreshAt'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accessToken': serializer.toJson<String>(accessToken),
      'refreshToken': serializer.toJson<String?>(refreshToken),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'lastRefreshedAt': serializer.toJson<DateTime?>(lastRefreshedAt),
      'nextScheduledRefreshAt': serializer.toJson<DateTime?>(
        nextScheduledRefreshAt,
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SessionToken copyWith({
    int? id,
    String? accessToken,
    Value<String?> refreshToken = const Value.absent(),
    Value<DateTime?> expiresAt = const Value.absent(),
    Value<DateTime?> lastRefreshedAt = const Value.absent(),
    Value<DateTime?> nextScheduledRefreshAt = const Value.absent(),
    DateTime? updatedAt,
  }) => SessionToken(
    id: id ?? this.id,
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken.present ? refreshToken.value : this.refreshToken,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    lastRefreshedAt: lastRefreshedAt.present
        ? lastRefreshedAt.value
        : this.lastRefreshedAt,
    nextScheduledRefreshAt: nextScheduledRefreshAt.present
        ? nextScheduledRefreshAt.value
        : this.nextScheduledRefreshAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SessionToken copyWithCompanion(SessionTokensCompanion data) {
    return SessionToken(
      id: data.id.present ? data.id.value : this.id,
      accessToken: data.accessToken.present
          ? data.accessToken.value
          : this.accessToken,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      lastRefreshedAt: data.lastRefreshedAt.present
          ? data.lastRefreshedAt.value
          : this.lastRefreshedAt,
      nextScheduledRefreshAt: data.nextScheduledRefreshAt.present
          ? data.nextScheduledRefreshAt.value
          : this.nextScheduledRefreshAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionToken(')
          ..write('id: $id, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('lastRefreshedAt: $lastRefreshedAt, ')
          ..write('nextScheduledRefreshAt: $nextScheduledRefreshAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accessToken,
    refreshToken,
    expiresAt,
    lastRefreshedAt,
    nextScheduledRefreshAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionToken &&
          other.id == this.id &&
          other.accessToken == this.accessToken &&
          other.refreshToken == this.refreshToken &&
          other.expiresAt == this.expiresAt &&
          other.lastRefreshedAt == this.lastRefreshedAt &&
          other.nextScheduledRefreshAt == this.nextScheduledRefreshAt &&
          other.updatedAt == this.updatedAt);
}

class SessionTokensCompanion extends UpdateCompanion<SessionToken> {
  final Value<int> id;
  final Value<String> accessToken;
  final Value<String?> refreshToken;
  final Value<DateTime?> expiresAt;
  final Value<DateTime?> lastRefreshedAt;
  final Value<DateTime?> nextScheduledRefreshAt;
  final Value<DateTime> updatedAt;
  const SessionTokensCompanion({
    this.id = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.lastRefreshedAt = const Value.absent(),
    this.nextScheduledRefreshAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SessionTokensCompanion.insert({
    this.id = const Value.absent(),
    required String accessToken,
    this.refreshToken = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.lastRefreshedAt = const Value.absent(),
    this.nextScheduledRefreshAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : accessToken = Value(accessToken);
  static Insertable<SessionToken> custom({
    Expression<int>? id,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? lastRefreshedAt,
    Expression<DateTime>? nextScheduledRefreshAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (lastRefreshedAt != null) 'last_refreshed_at': lastRefreshedAt,
      if (nextScheduledRefreshAt != null)
        'next_scheduled_refresh_at': nextScheduledRefreshAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SessionTokensCompanion copyWith({
    Value<int>? id,
    Value<String>? accessToken,
    Value<String?>? refreshToken,
    Value<DateTime?>? expiresAt,
    Value<DateTime?>? lastRefreshedAt,
    Value<DateTime?>? nextScheduledRefreshAt,
    Value<DateTime>? updatedAt,
  }) {
    return SessionTokensCompanion(
      id: id ?? this.id,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      lastRefreshedAt: lastRefreshedAt ?? this.lastRefreshedAt,
      nextScheduledRefreshAt:
          nextScheduledRefreshAt ?? this.nextScheduledRefreshAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (lastRefreshedAt.present) {
      map['last_refreshed_at'] = Variable<DateTime>(lastRefreshedAt.value);
    }
    if (nextScheduledRefreshAt.present) {
      map['next_scheduled_refresh_at'] = Variable<DateTime>(
        nextScheduledRefreshAt.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionTokensCompanion(')
          ..write('id: $id, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('lastRefreshedAt: $lastRefreshedAt, ')
          ..write('nextScheduledRefreshAt: $nextScheduledRefreshAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SessionUsersTable extends SessionUsers
    with TableInfo<$SessionUsersTable, SessionUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    metadataJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_metadataJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SessionUsersTable createAlias(String alias) {
    return $SessionUsersTable(attachedDatabase, alias);
  }
}

class SessionUser extends DataClass implements Insertable<SessionUser> {
  final String id;
  final String metadataJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SessionUser({
    required this.id,
    required this.metadataJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['metadata_json'] = Variable<String>(metadataJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SessionUsersCompanion toCompanion(bool nullToAbsent) {
    return SessionUsersCompanion(
      id: Value(id),
      metadataJson: Value(metadataJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SessionUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionUser(
      id: serializer.fromJson<String>(json['id']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'metadataJson': serializer.toJson<String>(metadataJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SessionUser copyWith({
    String? id,
    String? metadataJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SessionUser(
    id: id ?? this.id,
    metadataJson: metadataJson ?? this.metadataJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SessionUser copyWithCompanion(SessionUsersCompanion data) {
    return SessionUser(
      id: data.id.present ? data.id.value : this.id,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionUser(')
          ..write('id: $id, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, metadataJson, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionUser &&
          other.id == this.id &&
          other.metadataJson == this.metadataJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SessionUsersCompanion extends UpdateCompanion<SessionUser> {
  final Value<String> id;
  final Value<String> metadataJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SessionUsersCompanion({
    this.id = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionUsersCompanion.insert({
    required String id,
    required String metadataJson,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       metadataJson = Value(metadataJson);
  static Insertable<SessionUser> custom({
    Expression<String>? id,
    Expression<String>? metadataJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionUsersCompanion copyWith({
    Value<String>? id,
    Value<String>? metadataJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SessionUsersCompanion(
      id: id ?? this.id,
      metadataJson: metadataJson ?? this.metadataJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionUsersCompanion(')
          ..write('id: $id, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RefreshLogsTable extends RefreshLogs
    with TableInfo<$RefreshLogsTable, RefreshLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RefreshLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _triggeredByMeta = const VerificationMeta(
    'triggeredBy',
  );
  @override
  late final GeneratedColumn<String> triggeredBy = GeneratedColumn<String>(
    'triggered_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successMeta = const VerificationMeta(
    'success',
  );
  @override
  late final GeneratedColumn<bool> success = GeneratedColumn<bool>(
    'success',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("success" IN (0, 1))',
    ),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptedAtMeta = const VerificationMeta(
    'attemptedAt',
  );
  @override
  late final GeneratedColumn<DateTime> attemptedAt = GeneratedColumn<DateTime>(
    'attempted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    triggeredBy,
    success,
    errorMessage,
    attemptedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'refresh_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<RefreshLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('triggered_by')) {
      context.handle(
        _triggeredByMeta,
        triggeredBy.isAcceptableOrUnknown(
          data['triggered_by']!,
          _triggeredByMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_triggeredByMeta);
    }
    if (data.containsKey('success')) {
      context.handle(
        _successMeta,
        success.isAcceptableOrUnknown(data['success']!, _successMeta),
      );
    } else if (isInserting) {
      context.missing(_successMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('attempted_at')) {
      context.handle(
        _attemptedAtMeta,
        attemptedAt.isAcceptableOrUnknown(
          data['attempted_at']!,
          _attemptedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RefreshLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RefreshLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      triggeredBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}triggered_by'],
      )!,
      success: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}success'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      attemptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}attempted_at'],
      )!,
    );
  }

  @override
  $RefreshLogsTable createAlias(String alias) {
    return $RefreshLogsTable(attachedDatabase, alias);
  }
}

class RefreshLog extends DataClass implements Insertable<RefreshLog> {
  final int id;
  final String triggeredBy;
  final bool success;
  final String? errorMessage;
  final DateTime attemptedAt;
  const RefreshLog({
    required this.id,
    required this.triggeredBy,
    required this.success,
    this.errorMessage,
    required this.attemptedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['triggered_by'] = Variable<String>(triggeredBy);
    map['success'] = Variable<bool>(success);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['attempted_at'] = Variable<DateTime>(attemptedAt);
    return map;
  }

  RefreshLogsCompanion toCompanion(bool nullToAbsent) {
    return RefreshLogsCompanion(
      id: Value(id),
      triggeredBy: Value(triggeredBy),
      success: Value(success),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      attemptedAt: Value(attemptedAt),
    );
  }

  factory RefreshLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RefreshLog(
      id: serializer.fromJson<int>(json['id']),
      triggeredBy: serializer.fromJson<String>(json['triggeredBy']),
      success: serializer.fromJson<bool>(json['success']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      attemptedAt: serializer.fromJson<DateTime>(json['attemptedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'triggeredBy': serializer.toJson<String>(triggeredBy),
      'success': serializer.toJson<bool>(success),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'attemptedAt': serializer.toJson<DateTime>(attemptedAt),
    };
  }

  RefreshLog copyWith({
    int? id,
    String? triggeredBy,
    bool? success,
    Value<String?> errorMessage = const Value.absent(),
    DateTime? attemptedAt,
  }) => RefreshLog(
    id: id ?? this.id,
    triggeredBy: triggeredBy ?? this.triggeredBy,
    success: success ?? this.success,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    attemptedAt: attemptedAt ?? this.attemptedAt,
  );
  RefreshLog copyWithCompanion(RefreshLogsCompanion data) {
    return RefreshLog(
      id: data.id.present ? data.id.value : this.id,
      triggeredBy: data.triggeredBy.present
          ? data.triggeredBy.value
          : this.triggeredBy,
      success: data.success.present ? data.success.value : this.success,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      attemptedAt: data.attemptedAt.present
          ? data.attemptedAt.value
          : this.attemptedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RefreshLog(')
          ..write('id: $id, ')
          ..write('triggeredBy: $triggeredBy, ')
          ..write('success: $success, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, triggeredBy, success, errorMessage, attemptedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RefreshLog &&
          other.id == this.id &&
          other.triggeredBy == this.triggeredBy &&
          other.success == this.success &&
          other.errorMessage == this.errorMessage &&
          other.attemptedAt == this.attemptedAt);
}

class RefreshLogsCompanion extends UpdateCompanion<RefreshLog> {
  final Value<int> id;
  final Value<String> triggeredBy;
  final Value<bool> success;
  final Value<String?> errorMessage;
  final Value<DateTime> attemptedAt;
  const RefreshLogsCompanion({
    this.id = const Value.absent(),
    this.triggeredBy = const Value.absent(),
    this.success = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.attemptedAt = const Value.absent(),
  });
  RefreshLogsCompanion.insert({
    this.id = const Value.absent(),
    required String triggeredBy,
    required bool success,
    this.errorMessage = const Value.absent(),
    this.attemptedAt = const Value.absent(),
  }) : triggeredBy = Value(triggeredBy),
       success = Value(success);
  static Insertable<RefreshLog> custom({
    Expression<int>? id,
    Expression<String>? triggeredBy,
    Expression<bool>? success,
    Expression<String>? errorMessage,
    Expression<DateTime>? attemptedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (triggeredBy != null) 'triggered_by': triggeredBy,
      if (success != null) 'success': success,
      if (errorMessage != null) 'error_message': errorMessage,
      if (attemptedAt != null) 'attempted_at': attemptedAt,
    });
  }

  RefreshLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? triggeredBy,
    Value<bool>? success,
    Value<String?>? errorMessage,
    Value<DateTime>? attemptedAt,
  }) {
    return RefreshLogsCompanion(
      id: id ?? this.id,
      triggeredBy: triggeredBy ?? this.triggeredBy,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
      attemptedAt: attemptedAt ?? this.attemptedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (triggeredBy.present) {
      map['triggered_by'] = Variable<String>(triggeredBy.value);
    }
    if (success.present) {
      map['success'] = Variable<bool>(success.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (attemptedAt.present) {
      map['attempted_at'] = Variable<DateTime>(attemptedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RefreshLogsCompanion(')
          ..write('id: $id, ')
          ..write('triggeredBy: $triggeredBy, ')
          ..write('success: $success, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$SessionDatabase extends GeneratedDatabase {
  _$SessionDatabase(QueryExecutor e) : super(e);
  $SessionDatabaseManager get managers => $SessionDatabaseManager(this);
  late final $SessionTokensTable sessionTokens = $SessionTokensTable(this);
  late final $SessionUsersTable sessionUsers = $SessionUsersTable(this);
  late final $RefreshLogsTable refreshLogs = $RefreshLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sessionTokens,
    sessionUsers,
    refreshLogs,
  ];
}

typedef $$SessionTokensTableCreateCompanionBuilder =
    SessionTokensCompanion Function({
      Value<int> id,
      required String accessToken,
      Value<String?> refreshToken,
      Value<DateTime?> expiresAt,
      Value<DateTime?> lastRefreshedAt,
      Value<DateTime?> nextScheduledRefreshAt,
      Value<DateTime> updatedAt,
    });
typedef $$SessionTokensTableUpdateCompanionBuilder =
    SessionTokensCompanion Function({
      Value<int> id,
      Value<String> accessToken,
      Value<String?> refreshToken,
      Value<DateTime?> expiresAt,
      Value<DateTime?> lastRefreshedAt,
      Value<DateTime?> nextScheduledRefreshAt,
      Value<DateTime> updatedAt,
    });

class $$SessionTokensTableFilterComposer
    extends Composer<_$SessionDatabase, $SessionTokensTable> {
  $$SessionTokensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastRefreshedAt => $composableBuilder(
    column: $table.lastRefreshedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextScheduledRefreshAt => $composableBuilder(
    column: $table.nextScheduledRefreshAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionTokensTableOrderingComposer
    extends Composer<_$SessionDatabase, $SessionTokensTable> {
  $$SessionTokensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastRefreshedAt => $composableBuilder(
    column: $table.lastRefreshedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextScheduledRefreshAt => $composableBuilder(
    column: $table.nextScheduledRefreshAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionTokensTableAnnotationComposer
    extends Composer<_$SessionDatabase, $SessionTokensTable> {
  $$SessionTokensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastRefreshedAt => $composableBuilder(
    column: $table.lastRefreshedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextScheduledRefreshAt => $composableBuilder(
    column: $table.nextScheduledRefreshAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SessionTokensTableTableManager
    extends
        RootTableManager<
          _$SessionDatabase,
          $SessionTokensTable,
          SessionToken,
          $$SessionTokensTableFilterComposer,
          $$SessionTokensTableOrderingComposer,
          $$SessionTokensTableAnnotationComposer,
          $$SessionTokensTableCreateCompanionBuilder,
          $$SessionTokensTableUpdateCompanionBuilder,
          (
            SessionToken,
            BaseReferences<
              _$SessionDatabase,
              $SessionTokensTable,
              SessionToken
            >,
          ),
          SessionToken,
          PrefetchHooks Function()
        > {
  $$SessionTokensTableTableManager(
    _$SessionDatabase db,
    $SessionTokensTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionTokensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionTokensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionTokensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> accessToken = const Value.absent(),
                Value<String?> refreshToken = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<DateTime?> lastRefreshedAt = const Value.absent(),
                Value<DateTime?> nextScheduledRefreshAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SessionTokensCompanion(
                id: id,
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiresAt: expiresAt,
                lastRefreshedAt: lastRefreshedAt,
                nextScheduledRefreshAt: nextScheduledRefreshAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String accessToken,
                Value<String?> refreshToken = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<DateTime?> lastRefreshedAt = const Value.absent(),
                Value<DateTime?> nextScheduledRefreshAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SessionTokensCompanion.insert(
                id: id,
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiresAt: expiresAt,
                lastRefreshedAt: lastRefreshedAt,
                nextScheduledRefreshAt: nextScheduledRefreshAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionTokensTableProcessedTableManager =
    ProcessedTableManager<
      _$SessionDatabase,
      $SessionTokensTable,
      SessionToken,
      $$SessionTokensTableFilterComposer,
      $$SessionTokensTableOrderingComposer,
      $$SessionTokensTableAnnotationComposer,
      $$SessionTokensTableCreateCompanionBuilder,
      $$SessionTokensTableUpdateCompanionBuilder,
      (
        SessionToken,
        BaseReferences<_$SessionDatabase, $SessionTokensTable, SessionToken>,
      ),
      SessionToken,
      PrefetchHooks Function()
    >;
typedef $$SessionUsersTableCreateCompanionBuilder =
    SessionUsersCompanion Function({
      required String id,
      required String metadataJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SessionUsersTableUpdateCompanionBuilder =
    SessionUsersCompanion Function({
      Value<String> id,
      Value<String> metadataJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SessionUsersTableFilterComposer
    extends Composer<_$SessionDatabase, $SessionUsersTable> {
  $$SessionUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionUsersTableOrderingComposer
    extends Composer<_$SessionDatabase, $SessionUsersTable> {
  $$SessionUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionUsersTableAnnotationComposer
    extends Composer<_$SessionDatabase, $SessionUsersTable> {
  $$SessionUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SessionUsersTableTableManager
    extends
        RootTableManager<
          _$SessionDatabase,
          $SessionUsersTable,
          SessionUser,
          $$SessionUsersTableFilterComposer,
          $$SessionUsersTableOrderingComposer,
          $$SessionUsersTableAnnotationComposer,
          $$SessionUsersTableCreateCompanionBuilder,
          $$SessionUsersTableUpdateCompanionBuilder,
          (
            SessionUser,
            BaseReferences<_$SessionDatabase, $SessionUsersTable, SessionUser>,
          ),
          SessionUser,
          PrefetchHooks Function()
        > {
  $$SessionUsersTableTableManager(
    _$SessionDatabase db,
    $SessionUsersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionUsersCompanion(
                id: id,
                metadataJson: metadataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String metadataJson,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionUsersCompanion.insert(
                id: id,
                metadataJson: metadataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$SessionDatabase,
      $SessionUsersTable,
      SessionUser,
      $$SessionUsersTableFilterComposer,
      $$SessionUsersTableOrderingComposer,
      $$SessionUsersTableAnnotationComposer,
      $$SessionUsersTableCreateCompanionBuilder,
      $$SessionUsersTableUpdateCompanionBuilder,
      (
        SessionUser,
        BaseReferences<_$SessionDatabase, $SessionUsersTable, SessionUser>,
      ),
      SessionUser,
      PrefetchHooks Function()
    >;
typedef $$RefreshLogsTableCreateCompanionBuilder =
    RefreshLogsCompanion Function({
      Value<int> id,
      required String triggeredBy,
      required bool success,
      Value<String?> errorMessage,
      Value<DateTime> attemptedAt,
    });
typedef $$RefreshLogsTableUpdateCompanionBuilder =
    RefreshLogsCompanion Function({
      Value<int> id,
      Value<String> triggeredBy,
      Value<bool> success,
      Value<String?> errorMessage,
      Value<DateTime> attemptedAt,
    });

class $$RefreshLogsTableFilterComposer
    extends Composer<_$SessionDatabase, $RefreshLogsTable> {
  $$RefreshLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggeredBy => $composableBuilder(
    column: $table.triggeredBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RefreshLogsTableOrderingComposer
    extends Composer<_$SessionDatabase, $RefreshLogsTable> {
  $$RefreshLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggeredBy => $composableBuilder(
    column: $table.triggeredBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RefreshLogsTableAnnotationComposer
    extends Composer<_$SessionDatabase, $RefreshLogsTable> {
  $$RefreshLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get triggeredBy => $composableBuilder(
    column: $table.triggeredBy,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get success =>
      $composableBuilder(column: $table.success, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => column,
  );
}

class $$RefreshLogsTableTableManager
    extends
        RootTableManager<
          _$SessionDatabase,
          $RefreshLogsTable,
          RefreshLog,
          $$RefreshLogsTableFilterComposer,
          $$RefreshLogsTableOrderingComposer,
          $$RefreshLogsTableAnnotationComposer,
          $$RefreshLogsTableCreateCompanionBuilder,
          $$RefreshLogsTableUpdateCompanionBuilder,
          (
            RefreshLog,
            BaseReferences<_$SessionDatabase, $RefreshLogsTable, RefreshLog>,
          ),
          RefreshLog,
          PrefetchHooks Function()
        > {
  $$RefreshLogsTableTableManager(_$SessionDatabase db, $RefreshLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RefreshLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RefreshLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RefreshLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> triggeredBy = const Value.absent(),
                Value<bool> success = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> attemptedAt = const Value.absent(),
              }) => RefreshLogsCompanion(
                id: id,
                triggeredBy: triggeredBy,
                success: success,
                errorMessage: errorMessage,
                attemptedAt: attemptedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String triggeredBy,
                required bool success,
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> attemptedAt = const Value.absent(),
              }) => RefreshLogsCompanion.insert(
                id: id,
                triggeredBy: triggeredBy,
                success: success,
                errorMessage: errorMessage,
                attemptedAt: attemptedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RefreshLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$SessionDatabase,
      $RefreshLogsTable,
      RefreshLog,
      $$RefreshLogsTableFilterComposer,
      $$RefreshLogsTableOrderingComposer,
      $$RefreshLogsTableAnnotationComposer,
      $$RefreshLogsTableCreateCompanionBuilder,
      $$RefreshLogsTableUpdateCompanionBuilder,
      (
        RefreshLog,
        BaseReferences<_$SessionDatabase, $RefreshLogsTable, RefreshLog>,
      ),
      RefreshLog,
      PrefetchHooks Function()
    >;

class $SessionDatabaseManager {
  final _$SessionDatabase _db;
  $SessionDatabaseManager(this._db);
  $$SessionTokensTableTableManager get sessionTokens =>
      $$SessionTokensTableTableManager(_db, _db.sessionTokens);
  $$SessionUsersTableTableManager get sessionUsers =>
      $$SessionUsersTableTableManager(_db, _db.sessionUsers);
  $$RefreshLogsTableTableManager get refreshLogs =>
      $$RefreshLogsTableTableManager(_db, _db.refreshLogs);
}
