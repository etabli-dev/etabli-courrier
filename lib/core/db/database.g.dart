// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseUrlMeta = const VerificationMeta(
    'baseUrl',
  );
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
  static const VerificationMeta _secretsRefMeta = const VerificationMeta(
    'secretsRef',
  );
  @override
  late final GeneratedColumn<String> secretsRef = GeneratedColumn<String>(
    'secrets_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    displayName,
    baseUrl,
    username,
    enabled,
    createdAt,
    secretsRef,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(
        _baseUrlMeta,
        baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('secrets_ref')) {
      context.handle(
        _secretsRefMeta,
        secretsRef.isAcceptableOrUnknown(data['secrets_ref']!, _secretsRefMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      ),
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      secretsRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secrets_ref'],
      ),
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String kind;
  final String displayName;
  final String? baseUrl;
  final String? username;
  final bool enabled;
  final DateTime createdAt;
  final String? secretsRef;
  const Account({
    required this.id,
    required this.kind,
    required this.displayName,
    this.baseUrl,
    this.username,
    required this.enabled,
    required this.createdAt,
    this.secretsRef,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || baseUrl != null) {
      map['base_url'] = Variable<String>(baseUrl);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || secretsRef != null) {
      map['secrets_ref'] = Variable<String>(secretsRef);
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      kind: Value(kind),
      displayName: Value(displayName),
      baseUrl: baseUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(baseUrl),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
      secretsRef: secretsRef == null && nullToAbsent
          ? const Value.absent()
          : Value(secretsRef),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      displayName: serializer.fromJson<String>(json['displayName']),
      baseUrl: serializer.fromJson<String?>(json['baseUrl']),
      username: serializer.fromJson<String?>(json['username']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      secretsRef: serializer.fromJson<String?>(json['secretsRef']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'displayName': serializer.toJson<String>(displayName),
      'baseUrl': serializer.toJson<String?>(baseUrl),
      'username': serializer.toJson<String?>(username),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'secretsRef': serializer.toJson<String?>(secretsRef),
    };
  }

  Account copyWith({
    int? id,
    String? kind,
    String? displayName,
    Value<String?> baseUrl = const Value.absent(),
    Value<String?> username = const Value.absent(),
    bool? enabled,
    DateTime? createdAt,
    Value<String?> secretsRef = const Value.absent(),
  }) => Account(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    displayName: displayName ?? this.displayName,
    baseUrl: baseUrl.present ? baseUrl.value : this.baseUrl,
    username: username.present ? username.value : this.username,
    enabled: enabled ?? this.enabled,
    createdAt: createdAt ?? this.createdAt,
    secretsRef: secretsRef.present ? secretsRef.value : this.secretsRef,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      username: data.username.present ? data.username.value : this.username,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      secretsRef: data.secretsRef.present
          ? data.secretsRef.value
          : this.secretsRef,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('displayName: $displayName, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('username: $username, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('secretsRef: $secretsRef')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    displayName,
    baseUrl,
    username,
    enabled,
    createdAt,
    secretsRef,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.displayName == this.displayName &&
          other.baseUrl == this.baseUrl &&
          other.username == this.username &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt &&
          other.secretsRef == this.secretsRef);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> kind;
  final Value<String> displayName;
  final Value<String?> baseUrl;
  final Value<String?> username;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  final Value<String?> secretsRef;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.displayName = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.username = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.secretsRef = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required String displayName,
    this.baseUrl = const Value.absent(),
    this.username = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.secretsRef = const Value.absent(),
  }) : kind = Value(kind),
       displayName = Value(displayName);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? displayName,
    Expression<String>? baseUrl,
    Expression<String>? username,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
    Expression<String>? secretsRef,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (displayName != null) 'display_name': displayName,
      if (baseUrl != null) 'base_url': baseUrl,
      if (username != null) 'username': username,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
      if (secretsRef != null) 'secrets_ref': secretsRef,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<String>? displayName,
    Value<String?>? baseUrl,
    Value<String?>? username,
    Value<bool>? enabled,
    Value<DateTime>? createdAt,
    Value<String?>? secretsRef,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      displayName: displayName ?? this.displayName,
      baseUrl: baseUrl ?? this.baseUrl,
      username: username ?? this.username,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      secretsRef: secretsRef ?? this.secretsRef,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (secretsRef.present) {
      map['secrets_ref'] = Variable<String>(secretsRef.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('displayName: $displayName, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('username: $username, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('secretsRef: $secretsRef')
          ..write(')'))
        .toString();
  }
}

class $CollectionsTable extends Collections
    with TableInfo<$CollectionsTable, Collection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteHrefMeta = const VerificationMeta(
    'remoteHref',
  );
  @override
  late final GeneratedColumn<String> remoteHref = GeneratedColumn<String>(
    'remote_href',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ctagMeta = const VerificationMeta('ctag');
  @override
  late final GeneratedColumn<String> ctag = GeneratedColumn<String>(
    'ctag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncTokenMeta = const VerificationMeta(
    'syncToken',
  );
  @override
  late final GeneratedColumn<String> syncToken = GeneratedColumn<String>(
    'sync_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _windowSizeMeta = const VerificationMeta(
    'windowSize',
  );
  @override
  late final GeneratedColumn<int> windowSize = GeneratedColumn<int>(
    'window_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    kind,
    remoteHref,
    displayName,
    color,
    ctag,
    syncToken,
    windowSize,
    enabled,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Collection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('remote_href')) {
      context.handle(
        _remoteHrefMeta,
        remoteHref.isAcceptableOrUnknown(data['remote_href']!, _remoteHrefMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('ctag')) {
      context.handle(
        _ctagMeta,
        ctag.isAcceptableOrUnknown(data['ctag']!, _ctagMeta),
      );
    }
    if (data.containsKey('sync_token')) {
      context.handle(
        _syncTokenMeta,
        syncToken.isAcceptableOrUnknown(data['sync_token']!, _syncTokenMeta),
      );
    }
    if (data.containsKey('window_size')) {
      context.handle(
        _windowSizeMeta,
        windowSize.isAcceptableOrUnknown(data['window_size']!, _windowSizeMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Collection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Collection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      remoteHref: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_href'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      ctag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ctag'],
      ),
      syncToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_token'],
      ),
      windowSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}window_size'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $CollectionsTable createAlias(String alias) {
    return $CollectionsTable(attachedDatabase, alias);
  }
}

class Collection extends DataClass implements Insertable<Collection> {
  final int id;
  final int accountId;
  final String kind;
  final String? remoteHref;
  final String displayName;
  final String? color;
  final String? ctag;
  final String? syncToken;
  final int? windowSize;
  final bool enabled;
  final DateTime? lastSyncedAt;
  const Collection({
    required this.id,
    required this.accountId,
    required this.kind,
    this.remoteHref,
    required this.displayName,
    this.color,
    this.ctag,
    this.syncToken,
    this.windowSize,
    required this.enabled,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || remoteHref != null) {
      map['remote_href'] = Variable<String>(remoteHref);
    }
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || ctag != null) {
      map['ctag'] = Variable<String>(ctag);
    }
    if (!nullToAbsent || syncToken != null) {
      map['sync_token'] = Variable<String>(syncToken);
    }
    if (!nullToAbsent || windowSize != null) {
      map['window_size'] = Variable<int>(windowSize);
    }
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  CollectionsCompanion toCompanion(bool nullToAbsent) {
    return CollectionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      kind: Value(kind),
      remoteHref: remoteHref == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteHref),
      displayName: Value(displayName),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      ctag: ctag == null && nullToAbsent ? const Value.absent() : Value(ctag),
      syncToken: syncToken == null && nullToAbsent
          ? const Value.absent()
          : Value(syncToken),
      windowSize: windowSize == null && nullToAbsent
          ? const Value.absent()
          : Value(windowSize),
      enabled: Value(enabled),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory Collection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Collection(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      kind: serializer.fromJson<String>(json['kind']),
      remoteHref: serializer.fromJson<String?>(json['remoteHref']),
      displayName: serializer.fromJson<String>(json['displayName']),
      color: serializer.fromJson<String?>(json['color']),
      ctag: serializer.fromJson<String?>(json['ctag']),
      syncToken: serializer.fromJson<String?>(json['syncToken']),
      windowSize: serializer.fromJson<int?>(json['windowSize']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'kind': serializer.toJson<String>(kind),
      'remoteHref': serializer.toJson<String?>(remoteHref),
      'displayName': serializer.toJson<String>(displayName),
      'color': serializer.toJson<String?>(color),
      'ctag': serializer.toJson<String?>(ctag),
      'syncToken': serializer.toJson<String?>(syncToken),
      'windowSize': serializer.toJson<int?>(windowSize),
      'enabled': serializer.toJson<bool>(enabled),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  Collection copyWith({
    int? id,
    int? accountId,
    String? kind,
    Value<String?> remoteHref = const Value.absent(),
    String? displayName,
    Value<String?> color = const Value.absent(),
    Value<String?> ctag = const Value.absent(),
    Value<String?> syncToken = const Value.absent(),
    Value<int?> windowSize = const Value.absent(),
    bool? enabled,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => Collection(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    kind: kind ?? this.kind,
    remoteHref: remoteHref.present ? remoteHref.value : this.remoteHref,
    displayName: displayName ?? this.displayName,
    color: color.present ? color.value : this.color,
    ctag: ctag.present ? ctag.value : this.ctag,
    syncToken: syncToken.present ? syncToken.value : this.syncToken,
    windowSize: windowSize.present ? windowSize.value : this.windowSize,
    enabled: enabled ?? this.enabled,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  Collection copyWithCompanion(CollectionsCompanion data) {
    return Collection(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      kind: data.kind.present ? data.kind.value : this.kind,
      remoteHref: data.remoteHref.present
          ? data.remoteHref.value
          : this.remoteHref,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      color: data.color.present ? data.color.value : this.color,
      ctag: data.ctag.present ? data.ctag.value : this.ctag,
      syncToken: data.syncToken.present ? data.syncToken.value : this.syncToken,
      windowSize: data.windowSize.present
          ? data.windowSize.value
          : this.windowSize,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Collection(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('kind: $kind, ')
          ..write('remoteHref: $remoteHref, ')
          ..write('displayName: $displayName, ')
          ..write('color: $color, ')
          ..write('ctag: $ctag, ')
          ..write('syncToken: $syncToken, ')
          ..write('windowSize: $windowSize, ')
          ..write('enabled: $enabled, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    kind,
    remoteHref,
    displayName,
    color,
    ctag,
    syncToken,
    windowSize,
    enabled,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Collection &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.kind == this.kind &&
          other.remoteHref == this.remoteHref &&
          other.displayName == this.displayName &&
          other.color == this.color &&
          other.ctag == this.ctag &&
          other.syncToken == this.syncToken &&
          other.windowSize == this.windowSize &&
          other.enabled == this.enabled &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class CollectionsCompanion extends UpdateCompanion<Collection> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> kind;
  final Value<String?> remoteHref;
  final Value<String> displayName;
  final Value<String?> color;
  final Value<String?> ctag;
  final Value<String?> syncToken;
  final Value<int?> windowSize;
  final Value<bool> enabled;
  final Value<DateTime?> lastSyncedAt;
  const CollectionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.kind = const Value.absent(),
    this.remoteHref = const Value.absent(),
    this.displayName = const Value.absent(),
    this.color = const Value.absent(),
    this.ctag = const Value.absent(),
    this.syncToken = const Value.absent(),
    this.windowSize = const Value.absent(),
    this.enabled = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  CollectionsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String kind,
    this.remoteHref = const Value.absent(),
    required String displayName,
    this.color = const Value.absent(),
    this.ctag = const Value.absent(),
    this.syncToken = const Value.absent(),
    this.windowSize = const Value.absent(),
    this.enabled = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  }) : accountId = Value(accountId),
       kind = Value(kind),
       displayName = Value(displayName);
  static Insertable<Collection> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? kind,
    Expression<String>? remoteHref,
    Expression<String>? displayName,
    Expression<String>? color,
    Expression<String>? ctag,
    Expression<String>? syncToken,
    Expression<int>? windowSize,
    Expression<bool>? enabled,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (kind != null) 'kind': kind,
      if (remoteHref != null) 'remote_href': remoteHref,
      if (displayName != null) 'display_name': displayName,
      if (color != null) 'color': color,
      if (ctag != null) 'ctag': ctag,
      if (syncToken != null) 'sync_token': syncToken,
      if (windowSize != null) 'window_size': windowSize,
      if (enabled != null) 'enabled': enabled,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  CollectionsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<String>? kind,
    Value<String?>? remoteHref,
    Value<String>? displayName,
    Value<String?>? color,
    Value<String?>? ctag,
    Value<String?>? syncToken,
    Value<int?>? windowSize,
    Value<bool>? enabled,
    Value<DateTime?>? lastSyncedAt,
  }) {
    return CollectionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      kind: kind ?? this.kind,
      remoteHref: remoteHref ?? this.remoteHref,
      displayName: displayName ?? this.displayName,
      color: color ?? this.color,
      ctag: ctag ?? this.ctag,
      syncToken: syncToken ?? this.syncToken,
      windowSize: windowSize ?? this.windowSize,
      enabled: enabled ?? this.enabled,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (remoteHref.present) {
      map['remote_href'] = Variable<String>(remoteHref.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (ctag.present) {
      map['ctag'] = Variable<String>(ctag.value);
    }
    if (syncToken.present) {
      map['sync_token'] = Variable<String>(syncToken.value);
    }
    if (windowSize.present) {
      map['window_size'] = Variable<int>(windowSize.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('kind: $kind, ')
          ..write('remoteHref: $remoteHref, ')
          ..write('displayName: $displayName, ')
          ..write('color: $color, ')
          ..write('ctag: $ctag, ')
          ..write('syncToken: $syncToken, ')
          ..write('windowSize: $windowSize, ')
          ..write('enabled: $enabled, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $CalendarEventsTable extends CalendarEvents
    with TableInfo<$CalendarEventsTable, CalendarEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<int> collectionId = GeneratedColumn<int>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES collections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dtstartMeta = const VerificationMeta(
    'dtstart',
  );
  @override
  late final GeneratedColumn<DateTime> dtstart = GeneratedColumn<DateTime>(
    'dtstart',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dtendMeta = const VerificationMeta('dtend');
  @override
  late final GeneratedColumn<DateTime> dtend = GeneratedColumn<DateTime>(
    'dtend',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allDayMeta = const VerificationMeta('allDay');
  @override
  late final GeneratedColumn<bool> allDay = GeneratedColumn<bool>(
    'all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _rruleMeta = const VerificationMeta('rrule');
  @override
  late final GeneratedColumn<String> rrule = GeneratedColumn<String>(
    'rrule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _organizerMeta = const VerificationMeta(
    'organizer',
  );
  @override
  late final GeneratedColumn<String> organizer = GeneratedColumn<String>(
    'organizer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attendeesJsonMeta = const VerificationMeta(
    'attendeesJson',
  );
  @override
  late final GeneratedColumn<String> attendeesJson = GeneratedColumn<String>(
    'attendees_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawIcsMeta = const VerificationMeta('rawIcs');
  @override
  late final GeneratedColumn<String> rawIcs = GeneratedColumn<String>(
    'raw_ics',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedLocallyMeta = const VerificationMeta(
    'deletedLocally',
  );
  @override
  late final GeneratedColumn<bool> deletedLocally = GeneratedColumn<bool>(
    'deleted_locally',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_locally" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    collectionId,
    uid,
    etag,
    summary,
    location,
    description,
    dtstart,
    dtend,
    allDay,
    rrule,
    organizer,
    attendeesJson,
    rawIcs,
    lastModified,
    deletedLocally,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('dtstart')) {
      context.handle(
        _dtstartMeta,
        dtstart.isAcceptableOrUnknown(data['dtstart']!, _dtstartMeta),
      );
    }
    if (data.containsKey('dtend')) {
      context.handle(
        _dtendMeta,
        dtend.isAcceptableOrUnknown(data['dtend']!, _dtendMeta),
      );
    }
    if (data.containsKey('all_day')) {
      context.handle(
        _allDayMeta,
        allDay.isAcceptableOrUnknown(data['all_day']!, _allDayMeta),
      );
    }
    if (data.containsKey('rrule')) {
      context.handle(
        _rruleMeta,
        rrule.isAcceptableOrUnknown(data['rrule']!, _rruleMeta),
      );
    }
    if (data.containsKey('organizer')) {
      context.handle(
        _organizerMeta,
        organizer.isAcceptableOrUnknown(data['organizer']!, _organizerMeta),
      );
    }
    if (data.containsKey('attendees_json')) {
      context.handle(
        _attendeesJsonMeta,
        attendeesJson.isAcceptableOrUnknown(
          data['attendees_json']!,
          _attendeesJsonMeta,
        ),
      );
    }
    if (data.containsKey('raw_ics')) {
      context.handle(
        _rawIcsMeta,
        rawIcs.isAcceptableOrUnknown(data['raw_ics']!, _rawIcsMeta),
      );
    } else if (isInserting) {
      context.missing(_rawIcsMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('deleted_locally')) {
      context.handle(
        _deletedLocallyMeta,
        deletedLocally.isAcceptableOrUnknown(
          data['deleted_locally']!,
          _deletedLocallyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {collectionId, uid},
  ];
  @override
  CalendarEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_id'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dtstart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dtstart'],
      ),
      dtend: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dtend'],
      ),
      allDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}all_day'],
      )!,
      rrule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rrule'],
      ),
      organizer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organizer'],
      ),
      attendeesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attendees_json'],
      ),
      rawIcs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_ics'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
      deletedLocally: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_locally'],
      )!,
    );
  }

  @override
  $CalendarEventsTable createAlias(String alias) {
    return $CalendarEventsTable(attachedDatabase, alias);
  }
}

class CalendarEvent extends DataClass implements Insertable<CalendarEvent> {
  final int id;
  final int collectionId;
  final String uid;
  final String? etag;
  final String? summary;
  final String? location;
  final String? description;
  final DateTime? dtstart;
  final DateTime? dtend;
  final bool allDay;
  final String? rrule;
  final String? organizer;
  final String? attendeesJson;
  final String rawIcs;
  final DateTime lastModified;
  final bool deletedLocally;
  const CalendarEvent({
    required this.id,
    required this.collectionId,
    required this.uid,
    this.etag,
    this.summary,
    this.location,
    this.description,
    this.dtstart,
    this.dtend,
    required this.allDay,
    this.rrule,
    this.organizer,
    this.attendeesJson,
    required this.rawIcs,
    required this.lastModified,
    required this.deletedLocally,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['collection_id'] = Variable<int>(collectionId);
    map['uid'] = Variable<String>(uid);
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || dtstart != null) {
      map['dtstart'] = Variable<DateTime>(dtstart);
    }
    if (!nullToAbsent || dtend != null) {
      map['dtend'] = Variable<DateTime>(dtend);
    }
    map['all_day'] = Variable<bool>(allDay);
    if (!nullToAbsent || rrule != null) {
      map['rrule'] = Variable<String>(rrule);
    }
    if (!nullToAbsent || organizer != null) {
      map['organizer'] = Variable<String>(organizer);
    }
    if (!nullToAbsent || attendeesJson != null) {
      map['attendees_json'] = Variable<String>(attendeesJson);
    }
    map['raw_ics'] = Variable<String>(rawIcs);
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['deleted_locally'] = Variable<bool>(deletedLocally);
    return map;
  }

  CalendarEventsCompanion toCompanion(bool nullToAbsent) {
    return CalendarEventsCompanion(
      id: Value(id),
      collectionId: Value(collectionId),
      uid: Value(uid),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dtstart: dtstart == null && nullToAbsent
          ? const Value.absent()
          : Value(dtstart),
      dtend: dtend == null && nullToAbsent
          ? const Value.absent()
          : Value(dtend),
      allDay: Value(allDay),
      rrule: rrule == null && nullToAbsent
          ? const Value.absent()
          : Value(rrule),
      organizer: organizer == null && nullToAbsent
          ? const Value.absent()
          : Value(organizer),
      attendeesJson: attendeesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(attendeesJson),
      rawIcs: Value(rawIcs),
      lastModified: Value(lastModified),
      deletedLocally: Value(deletedLocally),
    );
  }

  factory CalendarEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarEvent(
      id: serializer.fromJson<int>(json['id']),
      collectionId: serializer.fromJson<int>(json['collectionId']),
      uid: serializer.fromJson<String>(json['uid']),
      etag: serializer.fromJson<String?>(json['etag']),
      summary: serializer.fromJson<String?>(json['summary']),
      location: serializer.fromJson<String?>(json['location']),
      description: serializer.fromJson<String?>(json['description']),
      dtstart: serializer.fromJson<DateTime?>(json['dtstart']),
      dtend: serializer.fromJson<DateTime?>(json['dtend']),
      allDay: serializer.fromJson<bool>(json['allDay']),
      rrule: serializer.fromJson<String?>(json['rrule']),
      organizer: serializer.fromJson<String?>(json['organizer']),
      attendeesJson: serializer.fromJson<String?>(json['attendeesJson']),
      rawIcs: serializer.fromJson<String>(json['rawIcs']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      deletedLocally: serializer.fromJson<bool>(json['deletedLocally']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'collectionId': serializer.toJson<int>(collectionId),
      'uid': serializer.toJson<String>(uid),
      'etag': serializer.toJson<String?>(etag),
      'summary': serializer.toJson<String?>(summary),
      'location': serializer.toJson<String?>(location),
      'description': serializer.toJson<String?>(description),
      'dtstart': serializer.toJson<DateTime?>(dtstart),
      'dtend': serializer.toJson<DateTime?>(dtend),
      'allDay': serializer.toJson<bool>(allDay),
      'rrule': serializer.toJson<String?>(rrule),
      'organizer': serializer.toJson<String?>(organizer),
      'attendeesJson': serializer.toJson<String?>(attendeesJson),
      'rawIcs': serializer.toJson<String>(rawIcs),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'deletedLocally': serializer.toJson<bool>(deletedLocally),
    };
  }

  CalendarEvent copyWith({
    int? id,
    int? collectionId,
    String? uid,
    Value<String?> etag = const Value.absent(),
    Value<String?> summary = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<DateTime?> dtstart = const Value.absent(),
    Value<DateTime?> dtend = const Value.absent(),
    bool? allDay,
    Value<String?> rrule = const Value.absent(),
    Value<String?> organizer = const Value.absent(),
    Value<String?> attendeesJson = const Value.absent(),
    String? rawIcs,
    DateTime? lastModified,
    bool? deletedLocally,
  }) => CalendarEvent(
    id: id ?? this.id,
    collectionId: collectionId ?? this.collectionId,
    uid: uid ?? this.uid,
    etag: etag.present ? etag.value : this.etag,
    summary: summary.present ? summary.value : this.summary,
    location: location.present ? location.value : this.location,
    description: description.present ? description.value : this.description,
    dtstart: dtstart.present ? dtstart.value : this.dtstart,
    dtend: dtend.present ? dtend.value : this.dtend,
    allDay: allDay ?? this.allDay,
    rrule: rrule.present ? rrule.value : this.rrule,
    organizer: organizer.present ? organizer.value : this.organizer,
    attendeesJson: attendeesJson.present
        ? attendeesJson.value
        : this.attendeesJson,
    rawIcs: rawIcs ?? this.rawIcs,
    lastModified: lastModified ?? this.lastModified,
    deletedLocally: deletedLocally ?? this.deletedLocally,
  );
  CalendarEvent copyWithCompanion(CalendarEventsCompanion data) {
    return CalendarEvent(
      id: data.id.present ? data.id.value : this.id,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      uid: data.uid.present ? data.uid.value : this.uid,
      etag: data.etag.present ? data.etag.value : this.etag,
      summary: data.summary.present ? data.summary.value : this.summary,
      location: data.location.present ? data.location.value : this.location,
      description: data.description.present
          ? data.description.value
          : this.description,
      dtstart: data.dtstart.present ? data.dtstart.value : this.dtstart,
      dtend: data.dtend.present ? data.dtend.value : this.dtend,
      allDay: data.allDay.present ? data.allDay.value : this.allDay,
      rrule: data.rrule.present ? data.rrule.value : this.rrule,
      organizer: data.organizer.present ? data.organizer.value : this.organizer,
      attendeesJson: data.attendeesJson.present
          ? data.attendeesJson.value
          : this.attendeesJson,
      rawIcs: data.rawIcs.present ? data.rawIcs.value : this.rawIcs,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      deletedLocally: data.deletedLocally.present
          ? data.deletedLocally.value
          : this.deletedLocally,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEvent(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('uid: $uid, ')
          ..write('etag: $etag, ')
          ..write('summary: $summary, ')
          ..write('location: $location, ')
          ..write('description: $description, ')
          ..write('dtstart: $dtstart, ')
          ..write('dtend: $dtend, ')
          ..write('allDay: $allDay, ')
          ..write('rrule: $rrule, ')
          ..write('organizer: $organizer, ')
          ..write('attendeesJson: $attendeesJson, ')
          ..write('rawIcs: $rawIcs, ')
          ..write('lastModified: $lastModified, ')
          ..write('deletedLocally: $deletedLocally')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    collectionId,
    uid,
    etag,
    summary,
    location,
    description,
    dtstart,
    dtend,
    allDay,
    rrule,
    organizer,
    attendeesJson,
    rawIcs,
    lastModified,
    deletedLocally,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarEvent &&
          other.id == this.id &&
          other.collectionId == this.collectionId &&
          other.uid == this.uid &&
          other.etag == this.etag &&
          other.summary == this.summary &&
          other.location == this.location &&
          other.description == this.description &&
          other.dtstart == this.dtstart &&
          other.dtend == this.dtend &&
          other.allDay == this.allDay &&
          other.rrule == this.rrule &&
          other.organizer == this.organizer &&
          other.attendeesJson == this.attendeesJson &&
          other.rawIcs == this.rawIcs &&
          other.lastModified == this.lastModified &&
          other.deletedLocally == this.deletedLocally);
}

class CalendarEventsCompanion extends UpdateCompanion<CalendarEvent> {
  final Value<int> id;
  final Value<int> collectionId;
  final Value<String> uid;
  final Value<String?> etag;
  final Value<String?> summary;
  final Value<String?> location;
  final Value<String?> description;
  final Value<DateTime?> dtstart;
  final Value<DateTime?> dtend;
  final Value<bool> allDay;
  final Value<String?> rrule;
  final Value<String?> organizer;
  final Value<String?> attendeesJson;
  final Value<String> rawIcs;
  final Value<DateTime> lastModified;
  final Value<bool> deletedLocally;
  const CalendarEventsCompanion({
    this.id = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.uid = const Value.absent(),
    this.etag = const Value.absent(),
    this.summary = const Value.absent(),
    this.location = const Value.absent(),
    this.description = const Value.absent(),
    this.dtstart = const Value.absent(),
    this.dtend = const Value.absent(),
    this.allDay = const Value.absent(),
    this.rrule = const Value.absent(),
    this.organizer = const Value.absent(),
    this.attendeesJson = const Value.absent(),
    this.rawIcs = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.deletedLocally = const Value.absent(),
  });
  CalendarEventsCompanion.insert({
    this.id = const Value.absent(),
    required int collectionId,
    required String uid,
    this.etag = const Value.absent(),
    this.summary = const Value.absent(),
    this.location = const Value.absent(),
    this.description = const Value.absent(),
    this.dtstart = const Value.absent(),
    this.dtend = const Value.absent(),
    this.allDay = const Value.absent(),
    this.rrule = const Value.absent(),
    this.organizer = const Value.absent(),
    this.attendeesJson = const Value.absent(),
    required String rawIcs,
    this.lastModified = const Value.absent(),
    this.deletedLocally = const Value.absent(),
  }) : collectionId = Value(collectionId),
       uid = Value(uid),
       rawIcs = Value(rawIcs);
  static Insertable<CalendarEvent> custom({
    Expression<int>? id,
    Expression<int>? collectionId,
    Expression<String>? uid,
    Expression<String>? etag,
    Expression<String>? summary,
    Expression<String>? location,
    Expression<String>? description,
    Expression<DateTime>? dtstart,
    Expression<DateTime>? dtend,
    Expression<bool>? allDay,
    Expression<String>? rrule,
    Expression<String>? organizer,
    Expression<String>? attendeesJson,
    Expression<String>? rawIcs,
    Expression<DateTime>? lastModified,
    Expression<bool>? deletedLocally,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collectionId != null) 'collection_id': collectionId,
      if (uid != null) 'uid': uid,
      if (etag != null) 'etag': etag,
      if (summary != null) 'summary': summary,
      if (location != null) 'location': location,
      if (description != null) 'description': description,
      if (dtstart != null) 'dtstart': dtstart,
      if (dtend != null) 'dtend': dtend,
      if (allDay != null) 'all_day': allDay,
      if (rrule != null) 'rrule': rrule,
      if (organizer != null) 'organizer': organizer,
      if (attendeesJson != null) 'attendees_json': attendeesJson,
      if (rawIcs != null) 'raw_ics': rawIcs,
      if (lastModified != null) 'last_modified': lastModified,
      if (deletedLocally != null) 'deleted_locally': deletedLocally,
    });
  }

  CalendarEventsCompanion copyWith({
    Value<int>? id,
    Value<int>? collectionId,
    Value<String>? uid,
    Value<String?>? etag,
    Value<String?>? summary,
    Value<String?>? location,
    Value<String?>? description,
    Value<DateTime?>? dtstart,
    Value<DateTime?>? dtend,
    Value<bool>? allDay,
    Value<String?>? rrule,
    Value<String?>? organizer,
    Value<String?>? attendeesJson,
    Value<String>? rawIcs,
    Value<DateTime>? lastModified,
    Value<bool>? deletedLocally,
  }) {
    return CalendarEventsCompanion(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      uid: uid ?? this.uid,
      etag: etag ?? this.etag,
      summary: summary ?? this.summary,
      location: location ?? this.location,
      description: description ?? this.description,
      dtstart: dtstart ?? this.dtstart,
      dtend: dtend ?? this.dtend,
      allDay: allDay ?? this.allDay,
      rrule: rrule ?? this.rrule,
      organizer: organizer ?? this.organizer,
      attendeesJson: attendeesJson ?? this.attendeesJson,
      rawIcs: rawIcs ?? this.rawIcs,
      lastModified: lastModified ?? this.lastModified,
      deletedLocally: deletedLocally ?? this.deletedLocally,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<int>(collectionId.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dtstart.present) {
      map['dtstart'] = Variable<DateTime>(dtstart.value);
    }
    if (dtend.present) {
      map['dtend'] = Variable<DateTime>(dtend.value);
    }
    if (allDay.present) {
      map['all_day'] = Variable<bool>(allDay.value);
    }
    if (rrule.present) {
      map['rrule'] = Variable<String>(rrule.value);
    }
    if (organizer.present) {
      map['organizer'] = Variable<String>(organizer.value);
    }
    if (attendeesJson.present) {
      map['attendees_json'] = Variable<String>(attendeesJson.value);
    }
    if (rawIcs.present) {
      map['raw_ics'] = Variable<String>(rawIcs.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (deletedLocally.present) {
      map['deleted_locally'] = Variable<bool>(deletedLocally.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEventsCompanion(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('uid: $uid, ')
          ..write('etag: $etag, ')
          ..write('summary: $summary, ')
          ..write('location: $location, ')
          ..write('description: $description, ')
          ..write('dtstart: $dtstart, ')
          ..write('dtend: $dtend, ')
          ..write('allDay: $allDay, ')
          ..write('rrule: $rrule, ')
          ..write('organizer: $organizer, ')
          ..write('attendeesJson: $attendeesJson, ')
          ..write('rawIcs: $rawIcs, ')
          ..write('lastModified: $lastModified, ')
          ..write('deletedLocally: $deletedLocally')
          ..write(')'))
        .toString();
  }
}

class $EventRemindersTable extends EventReminders
    with TableInfo<$EventRemindersTable, EventReminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventRemindersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calendar_events (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _minutesBeforeStartMeta =
      const VerificationMeta('minutesBeforeStart');
  @override
  late final GeneratedColumn<int> minutesBeforeStart = GeneratedColumn<int>(
    'minutes_before_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _absoluteTriggerMeta = const VerificationMeta(
    'absoluteTrigger',
  );
  @override
  late final GeneratedColumn<DateTime> absoluteTrigger =
      GeneratedColumn<DateTime>(
        'absolute_trigger',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('DISPLAY'),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    minutesBeforeStart,
    absoluteTrigger,
    action,
    label,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventReminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('minutes_before_start')) {
      context.handle(
        _minutesBeforeStartMeta,
        minutesBeforeStart.isAcceptableOrUnknown(
          data['minutes_before_start']!,
          _minutesBeforeStartMeta,
        ),
      );
    }
    if (data.containsKey('absolute_trigger')) {
      context.handle(
        _absoluteTriggerMeta,
        absoluteTrigger.isAcceptableOrUnknown(
          data['absolute_trigger']!,
          _absoluteTriggerMeta,
        ),
      );
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventReminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventReminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}event_id'],
      )!,
      minutesBeforeStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes_before_start'],
      ),
      absoluteTrigger: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}absolute_trigger'],
      ),
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
    );
  }

  @override
  $EventRemindersTable createAlias(String alias) {
    return $EventRemindersTable(attachedDatabase, alias);
  }
}

class EventReminder extends DataClass implements Insertable<EventReminder> {
  final int id;
  final int eventId;
  final int? minutesBeforeStart;
  final DateTime? absoluteTrigger;
  final String action;
  final String? label;
  const EventReminder({
    required this.id,
    required this.eventId,
    this.minutesBeforeStart,
    this.absoluteTrigger,
    required this.action,
    this.label,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<int>(eventId);
    if (!nullToAbsent || minutesBeforeStart != null) {
      map['minutes_before_start'] = Variable<int>(minutesBeforeStart);
    }
    if (!nullToAbsent || absoluteTrigger != null) {
      map['absolute_trigger'] = Variable<DateTime>(absoluteTrigger);
    }
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    return map;
  }

  EventRemindersCompanion toCompanion(bool nullToAbsent) {
    return EventRemindersCompanion(
      id: Value(id),
      eventId: Value(eventId),
      minutesBeforeStart: minutesBeforeStart == null && nullToAbsent
          ? const Value.absent()
          : Value(minutesBeforeStart),
      absoluteTrigger: absoluteTrigger == null && nullToAbsent
          ? const Value.absent()
          : Value(absoluteTrigger),
      action: Value(action),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
    );
  }

  factory EventReminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventReminder(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<int>(json['eventId']),
      minutesBeforeStart: serializer.fromJson<int?>(json['minutesBeforeStart']),
      absoluteTrigger: serializer.fromJson<DateTime?>(json['absoluteTrigger']),
      action: serializer.fromJson<String>(json['action']),
      label: serializer.fromJson<String?>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<int>(eventId),
      'minutesBeforeStart': serializer.toJson<int?>(minutesBeforeStart),
      'absoluteTrigger': serializer.toJson<DateTime?>(absoluteTrigger),
      'action': serializer.toJson<String>(action),
      'label': serializer.toJson<String?>(label),
    };
  }

  EventReminder copyWith({
    int? id,
    int? eventId,
    Value<int?> minutesBeforeStart = const Value.absent(),
    Value<DateTime?> absoluteTrigger = const Value.absent(),
    String? action,
    Value<String?> label = const Value.absent(),
  }) => EventReminder(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    minutesBeforeStart: minutesBeforeStart.present
        ? minutesBeforeStart.value
        : this.minutesBeforeStart,
    absoluteTrigger: absoluteTrigger.present
        ? absoluteTrigger.value
        : this.absoluteTrigger,
    action: action ?? this.action,
    label: label.present ? label.value : this.label,
  );
  EventReminder copyWithCompanion(EventRemindersCompanion data) {
    return EventReminder(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      minutesBeforeStart: data.minutesBeforeStart.present
          ? data.minutesBeforeStart.value
          : this.minutesBeforeStart,
      absoluteTrigger: data.absoluteTrigger.present
          ? data.absoluteTrigger.value
          : this.absoluteTrigger,
      action: data.action.present ? data.action.value : this.action,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventReminder(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('minutesBeforeStart: $minutesBeforeStart, ')
          ..write('absoluteTrigger: $absoluteTrigger, ')
          ..write('action: $action, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventId,
    minutesBeforeStart,
    absoluteTrigger,
    action,
    label,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventReminder &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.minutesBeforeStart == this.minutesBeforeStart &&
          other.absoluteTrigger == this.absoluteTrigger &&
          other.action == this.action &&
          other.label == this.label);
}

class EventRemindersCompanion extends UpdateCompanion<EventReminder> {
  final Value<int> id;
  final Value<int> eventId;
  final Value<int?> minutesBeforeStart;
  final Value<DateTime?> absoluteTrigger;
  final Value<String> action;
  final Value<String?> label;
  const EventRemindersCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.minutesBeforeStart = const Value.absent(),
    this.absoluteTrigger = const Value.absent(),
    this.action = const Value.absent(),
    this.label = const Value.absent(),
  });
  EventRemindersCompanion.insert({
    this.id = const Value.absent(),
    required int eventId,
    this.minutesBeforeStart = const Value.absent(),
    this.absoluteTrigger = const Value.absent(),
    this.action = const Value.absent(),
    this.label = const Value.absent(),
  }) : eventId = Value(eventId);
  static Insertable<EventReminder> custom({
    Expression<int>? id,
    Expression<int>? eventId,
    Expression<int>? minutesBeforeStart,
    Expression<DateTime>? absoluteTrigger,
    Expression<String>? action,
    Expression<String>? label,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (minutesBeforeStart != null)
        'minutes_before_start': minutesBeforeStart,
      if (absoluteTrigger != null) 'absolute_trigger': absoluteTrigger,
      if (action != null) 'action': action,
      if (label != null) 'label': label,
    });
  }

  EventRemindersCompanion copyWith({
    Value<int>? id,
    Value<int>? eventId,
    Value<int?>? minutesBeforeStart,
    Value<DateTime?>? absoluteTrigger,
    Value<String>? action,
    Value<String?>? label,
  }) {
    return EventRemindersCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      minutesBeforeStart: minutesBeforeStart ?? this.minutesBeforeStart,
      absoluteTrigger: absoluteTrigger ?? this.absoluteTrigger,
      action: action ?? this.action,
      label: label ?? this.label,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (minutesBeforeStart.present) {
      map['minutes_before_start'] = Variable<int>(minutesBeforeStart.value);
    }
    if (absoluteTrigger.present) {
      map['absolute_trigger'] = Variable<DateTime>(absoluteTrigger.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventRemindersCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('minutesBeforeStart: $minutesBeforeStart, ')
          ..write('absoluteTrigger: $absoluteTrigger, ')
          ..write('action: $action, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }
}

class $EventRecurrenceOverridesTable extends EventRecurrenceOverrides
    with TableInfo<$EventRecurrenceOverridesTable, EventRecurrenceOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventRecurrenceOverridesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calendar_events (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, eventId, kind, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_recurrence_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventRecurrenceOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventRecurrenceOverride map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventRecurrenceOverride(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}event_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $EventRecurrenceOverridesTable createAlias(String alias) {
    return $EventRecurrenceOverridesTable(attachedDatabase, alias);
  }
}

class EventRecurrenceOverride extends DataClass
    implements Insertable<EventRecurrenceOverride> {
  final int id;
  final int eventId;
  final String kind;
  final String value;
  const EventRecurrenceOverride({
    required this.id,
    required this.eventId,
    required this.kind,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<int>(eventId);
    map['kind'] = Variable<String>(kind);
    map['value'] = Variable<String>(value);
    return map;
  }

  EventRecurrenceOverridesCompanion toCompanion(bool nullToAbsent) {
    return EventRecurrenceOverridesCompanion(
      id: Value(id),
      eventId: Value(eventId),
      kind: Value(kind),
      value: Value(value),
    );
  }

  factory EventRecurrenceOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventRecurrenceOverride(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<int>(json['eventId']),
      kind: serializer.fromJson<String>(json['kind']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<int>(eventId),
      'kind': serializer.toJson<String>(kind),
      'value': serializer.toJson<String>(value),
    };
  }

  EventRecurrenceOverride copyWith({
    int? id,
    int? eventId,
    String? kind,
    String? value,
  }) => EventRecurrenceOverride(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    kind: kind ?? this.kind,
    value: value ?? this.value,
  );
  EventRecurrenceOverride copyWithCompanion(
    EventRecurrenceOverridesCompanion data,
  ) {
    return EventRecurrenceOverride(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      kind: data.kind.present ? data.kind.value : this.kind,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventRecurrenceOverride(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('kind: $kind, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventId, kind, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventRecurrenceOverride &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.kind == this.kind &&
          other.value == this.value);
}

class EventRecurrenceOverridesCompanion
    extends UpdateCompanion<EventRecurrenceOverride> {
  final Value<int> id;
  final Value<int> eventId;
  final Value<String> kind;
  final Value<String> value;
  const EventRecurrenceOverridesCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.kind = const Value.absent(),
    this.value = const Value.absent(),
  });
  EventRecurrenceOverridesCompanion.insert({
    this.id = const Value.absent(),
    required int eventId,
    required String kind,
    required String value,
  }) : eventId = Value(eventId),
       kind = Value(kind),
       value = Value(value);
  static Insertable<EventRecurrenceOverride> custom({
    Expression<int>? id,
    Expression<int>? eventId,
    Expression<String>? kind,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (kind != null) 'kind': kind,
      if (value != null) 'value': value,
    });
  }

  EventRecurrenceOverridesCompanion copyWith({
    Value<int>? id,
    Value<int>? eventId,
    Value<String>? kind,
    Value<String>? value,
  }) {
    return EventRecurrenceOverridesCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      kind: kind ?? this.kind,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventRecurrenceOverridesCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('kind: $kind, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $ContactCardsTable extends ContactCards
    with TableInfo<$ContactCardsTable, ContactCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactCardsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<int> collectionId = GeneratedColumn<int>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES collections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formattedNameMeta = const VerificationMeta(
    'formattedName',
  );
  @override
  late final GeneratedColumn<String> formattedName = GeneratedColumn<String>(
    'formatted_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _givenNameMeta = const VerificationMeta(
    'givenName',
  );
  @override
  late final GeneratedColumn<String> givenName = GeneratedColumn<String>(
    'given_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _familyNameMeta = const VerificationMeta(
    'familyName',
  );
  @override
  late final GeneratedColumn<String> familyName = GeneratedColumn<String>(
    'family_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _organizationMeta = const VerificationMeta(
    'organization',
  );
  @override
  late final GeneratedColumn<String> organization = GeneratedColumn<String>(
    'organization',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryEmailMeta = const VerificationMeta(
    'primaryEmail',
  );
  @override
  late final GeneratedColumn<String> primaryEmail = GeneratedColumn<String>(
    'primary_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryPhoneMeta = const VerificationMeta(
    'primaryPhone',
  );
  @override
  late final GeneratedColumn<String> primaryPhone = GeneratedColumn<String>(
    'primary_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawVcardMeta = const VerificationMeta(
    'rawVcard',
  );
  @override
  late final GeneratedColumn<String> rawVcard = GeneratedColumn<String>(
    'raw_vcard',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoRefMeta = const VerificationMeta(
    'photoRef',
  );
  @override
  late final GeneratedColumn<String> photoRef = GeneratedColumn<String>(
    'photo_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedLocallyMeta = const VerificationMeta(
    'deletedLocally',
  );
  @override
  late final GeneratedColumn<bool> deletedLocally = GeneratedColumn<bool>(
    'deleted_locally',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_locally" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    collectionId,
    uid,
    etag,
    formattedName,
    givenName,
    familyName,
    organization,
    primaryEmail,
    primaryPhone,
    rawVcard,
    photoRef,
    lastModified,
    deletedLocally,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contact_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContactCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    if (data.containsKey('formatted_name')) {
      context.handle(
        _formattedNameMeta,
        formattedName.isAcceptableOrUnknown(
          data['formatted_name']!,
          _formattedNameMeta,
        ),
      );
    }
    if (data.containsKey('given_name')) {
      context.handle(
        _givenNameMeta,
        givenName.isAcceptableOrUnknown(data['given_name']!, _givenNameMeta),
      );
    }
    if (data.containsKey('family_name')) {
      context.handle(
        _familyNameMeta,
        familyName.isAcceptableOrUnknown(data['family_name']!, _familyNameMeta),
      );
    }
    if (data.containsKey('organization')) {
      context.handle(
        _organizationMeta,
        organization.isAcceptableOrUnknown(
          data['organization']!,
          _organizationMeta,
        ),
      );
    }
    if (data.containsKey('primary_email')) {
      context.handle(
        _primaryEmailMeta,
        primaryEmail.isAcceptableOrUnknown(
          data['primary_email']!,
          _primaryEmailMeta,
        ),
      );
    }
    if (data.containsKey('primary_phone')) {
      context.handle(
        _primaryPhoneMeta,
        primaryPhone.isAcceptableOrUnknown(
          data['primary_phone']!,
          _primaryPhoneMeta,
        ),
      );
    }
    if (data.containsKey('raw_vcard')) {
      context.handle(
        _rawVcardMeta,
        rawVcard.isAcceptableOrUnknown(data['raw_vcard']!, _rawVcardMeta),
      );
    } else if (isInserting) {
      context.missing(_rawVcardMeta);
    }
    if (data.containsKey('photo_ref')) {
      context.handle(
        _photoRefMeta,
        photoRef.isAcceptableOrUnknown(data['photo_ref']!, _photoRefMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('deleted_locally')) {
      context.handle(
        _deletedLocallyMeta,
        deletedLocally.isAcceptableOrUnknown(
          data['deleted_locally']!,
          _deletedLocallyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {collectionId, uid},
  ];
  @override
  ContactCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContactCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_id'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      formattedName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formatted_name'],
      ),
      givenName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}given_name'],
      ),
      familyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_name'],
      ),
      organization: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization'],
      ),
      primaryEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_email'],
      ),
      primaryPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_phone'],
      ),
      rawVcard: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_vcard'],
      )!,
      photoRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_ref'],
      ),
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
      deletedLocally: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_locally'],
      )!,
    );
  }

  @override
  $ContactCardsTable createAlias(String alias) {
    return $ContactCardsTable(attachedDatabase, alias);
  }
}

class ContactCard extends DataClass implements Insertable<ContactCard> {
  final int id;
  final int collectionId;
  final String uid;
  final String? etag;
  final String? formattedName;
  final String? givenName;
  final String? familyName;
  final String? organization;
  final String? primaryEmail;
  final String? primaryPhone;
  final String rawVcard;
  final String? photoRef;
  final DateTime lastModified;
  final bool deletedLocally;
  const ContactCard({
    required this.id,
    required this.collectionId,
    required this.uid,
    this.etag,
    this.formattedName,
    this.givenName,
    this.familyName,
    this.organization,
    this.primaryEmail,
    this.primaryPhone,
    required this.rawVcard,
    this.photoRef,
    required this.lastModified,
    required this.deletedLocally,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['collection_id'] = Variable<int>(collectionId);
    map['uid'] = Variable<String>(uid);
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    if (!nullToAbsent || formattedName != null) {
      map['formatted_name'] = Variable<String>(formattedName);
    }
    if (!nullToAbsent || givenName != null) {
      map['given_name'] = Variable<String>(givenName);
    }
    if (!nullToAbsent || familyName != null) {
      map['family_name'] = Variable<String>(familyName);
    }
    if (!nullToAbsent || organization != null) {
      map['organization'] = Variable<String>(organization);
    }
    if (!nullToAbsent || primaryEmail != null) {
      map['primary_email'] = Variable<String>(primaryEmail);
    }
    if (!nullToAbsent || primaryPhone != null) {
      map['primary_phone'] = Variable<String>(primaryPhone);
    }
    map['raw_vcard'] = Variable<String>(rawVcard);
    if (!nullToAbsent || photoRef != null) {
      map['photo_ref'] = Variable<String>(photoRef);
    }
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['deleted_locally'] = Variable<bool>(deletedLocally);
    return map;
  }

  ContactCardsCompanion toCompanion(bool nullToAbsent) {
    return ContactCardsCompanion(
      id: Value(id),
      collectionId: Value(collectionId),
      uid: Value(uid),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      formattedName: formattedName == null && nullToAbsent
          ? const Value.absent()
          : Value(formattedName),
      givenName: givenName == null && nullToAbsent
          ? const Value.absent()
          : Value(givenName),
      familyName: familyName == null && nullToAbsent
          ? const Value.absent()
          : Value(familyName),
      organization: organization == null && nullToAbsent
          ? const Value.absent()
          : Value(organization),
      primaryEmail: primaryEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryEmail),
      primaryPhone: primaryPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryPhone),
      rawVcard: Value(rawVcard),
      photoRef: photoRef == null && nullToAbsent
          ? const Value.absent()
          : Value(photoRef),
      lastModified: Value(lastModified),
      deletedLocally: Value(deletedLocally),
    );
  }

  factory ContactCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContactCard(
      id: serializer.fromJson<int>(json['id']),
      collectionId: serializer.fromJson<int>(json['collectionId']),
      uid: serializer.fromJson<String>(json['uid']),
      etag: serializer.fromJson<String?>(json['etag']),
      formattedName: serializer.fromJson<String?>(json['formattedName']),
      givenName: serializer.fromJson<String?>(json['givenName']),
      familyName: serializer.fromJson<String?>(json['familyName']),
      organization: serializer.fromJson<String?>(json['organization']),
      primaryEmail: serializer.fromJson<String?>(json['primaryEmail']),
      primaryPhone: serializer.fromJson<String?>(json['primaryPhone']),
      rawVcard: serializer.fromJson<String>(json['rawVcard']),
      photoRef: serializer.fromJson<String?>(json['photoRef']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      deletedLocally: serializer.fromJson<bool>(json['deletedLocally']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'collectionId': serializer.toJson<int>(collectionId),
      'uid': serializer.toJson<String>(uid),
      'etag': serializer.toJson<String?>(etag),
      'formattedName': serializer.toJson<String?>(formattedName),
      'givenName': serializer.toJson<String?>(givenName),
      'familyName': serializer.toJson<String?>(familyName),
      'organization': serializer.toJson<String?>(organization),
      'primaryEmail': serializer.toJson<String?>(primaryEmail),
      'primaryPhone': serializer.toJson<String?>(primaryPhone),
      'rawVcard': serializer.toJson<String>(rawVcard),
      'photoRef': serializer.toJson<String?>(photoRef),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'deletedLocally': serializer.toJson<bool>(deletedLocally),
    };
  }

  ContactCard copyWith({
    int? id,
    int? collectionId,
    String? uid,
    Value<String?> etag = const Value.absent(),
    Value<String?> formattedName = const Value.absent(),
    Value<String?> givenName = const Value.absent(),
    Value<String?> familyName = const Value.absent(),
    Value<String?> organization = const Value.absent(),
    Value<String?> primaryEmail = const Value.absent(),
    Value<String?> primaryPhone = const Value.absent(),
    String? rawVcard,
    Value<String?> photoRef = const Value.absent(),
    DateTime? lastModified,
    bool? deletedLocally,
  }) => ContactCard(
    id: id ?? this.id,
    collectionId: collectionId ?? this.collectionId,
    uid: uid ?? this.uid,
    etag: etag.present ? etag.value : this.etag,
    formattedName: formattedName.present
        ? formattedName.value
        : this.formattedName,
    givenName: givenName.present ? givenName.value : this.givenName,
    familyName: familyName.present ? familyName.value : this.familyName,
    organization: organization.present ? organization.value : this.organization,
    primaryEmail: primaryEmail.present ? primaryEmail.value : this.primaryEmail,
    primaryPhone: primaryPhone.present ? primaryPhone.value : this.primaryPhone,
    rawVcard: rawVcard ?? this.rawVcard,
    photoRef: photoRef.present ? photoRef.value : this.photoRef,
    lastModified: lastModified ?? this.lastModified,
    deletedLocally: deletedLocally ?? this.deletedLocally,
  );
  ContactCard copyWithCompanion(ContactCardsCompanion data) {
    return ContactCard(
      id: data.id.present ? data.id.value : this.id,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      uid: data.uid.present ? data.uid.value : this.uid,
      etag: data.etag.present ? data.etag.value : this.etag,
      formattedName: data.formattedName.present
          ? data.formattedName.value
          : this.formattedName,
      givenName: data.givenName.present ? data.givenName.value : this.givenName,
      familyName: data.familyName.present
          ? data.familyName.value
          : this.familyName,
      organization: data.organization.present
          ? data.organization.value
          : this.organization,
      primaryEmail: data.primaryEmail.present
          ? data.primaryEmail.value
          : this.primaryEmail,
      primaryPhone: data.primaryPhone.present
          ? data.primaryPhone.value
          : this.primaryPhone,
      rawVcard: data.rawVcard.present ? data.rawVcard.value : this.rawVcard,
      photoRef: data.photoRef.present ? data.photoRef.value : this.photoRef,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      deletedLocally: data.deletedLocally.present
          ? data.deletedLocally.value
          : this.deletedLocally,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContactCard(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('uid: $uid, ')
          ..write('etag: $etag, ')
          ..write('formattedName: $formattedName, ')
          ..write('givenName: $givenName, ')
          ..write('familyName: $familyName, ')
          ..write('organization: $organization, ')
          ..write('primaryEmail: $primaryEmail, ')
          ..write('primaryPhone: $primaryPhone, ')
          ..write('rawVcard: $rawVcard, ')
          ..write('photoRef: $photoRef, ')
          ..write('lastModified: $lastModified, ')
          ..write('deletedLocally: $deletedLocally')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    collectionId,
    uid,
    etag,
    formattedName,
    givenName,
    familyName,
    organization,
    primaryEmail,
    primaryPhone,
    rawVcard,
    photoRef,
    lastModified,
    deletedLocally,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactCard &&
          other.id == this.id &&
          other.collectionId == this.collectionId &&
          other.uid == this.uid &&
          other.etag == this.etag &&
          other.formattedName == this.formattedName &&
          other.givenName == this.givenName &&
          other.familyName == this.familyName &&
          other.organization == this.organization &&
          other.primaryEmail == this.primaryEmail &&
          other.primaryPhone == this.primaryPhone &&
          other.rawVcard == this.rawVcard &&
          other.photoRef == this.photoRef &&
          other.lastModified == this.lastModified &&
          other.deletedLocally == this.deletedLocally);
}

class ContactCardsCompanion extends UpdateCompanion<ContactCard> {
  final Value<int> id;
  final Value<int> collectionId;
  final Value<String> uid;
  final Value<String?> etag;
  final Value<String?> formattedName;
  final Value<String?> givenName;
  final Value<String?> familyName;
  final Value<String?> organization;
  final Value<String?> primaryEmail;
  final Value<String?> primaryPhone;
  final Value<String> rawVcard;
  final Value<String?> photoRef;
  final Value<DateTime> lastModified;
  final Value<bool> deletedLocally;
  const ContactCardsCompanion({
    this.id = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.uid = const Value.absent(),
    this.etag = const Value.absent(),
    this.formattedName = const Value.absent(),
    this.givenName = const Value.absent(),
    this.familyName = const Value.absent(),
    this.organization = const Value.absent(),
    this.primaryEmail = const Value.absent(),
    this.primaryPhone = const Value.absent(),
    this.rawVcard = const Value.absent(),
    this.photoRef = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.deletedLocally = const Value.absent(),
  });
  ContactCardsCompanion.insert({
    this.id = const Value.absent(),
    required int collectionId,
    required String uid,
    this.etag = const Value.absent(),
    this.formattedName = const Value.absent(),
    this.givenName = const Value.absent(),
    this.familyName = const Value.absent(),
    this.organization = const Value.absent(),
    this.primaryEmail = const Value.absent(),
    this.primaryPhone = const Value.absent(),
    required String rawVcard,
    this.photoRef = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.deletedLocally = const Value.absent(),
  }) : collectionId = Value(collectionId),
       uid = Value(uid),
       rawVcard = Value(rawVcard);
  static Insertable<ContactCard> custom({
    Expression<int>? id,
    Expression<int>? collectionId,
    Expression<String>? uid,
    Expression<String>? etag,
    Expression<String>? formattedName,
    Expression<String>? givenName,
    Expression<String>? familyName,
    Expression<String>? organization,
    Expression<String>? primaryEmail,
    Expression<String>? primaryPhone,
    Expression<String>? rawVcard,
    Expression<String>? photoRef,
    Expression<DateTime>? lastModified,
    Expression<bool>? deletedLocally,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collectionId != null) 'collection_id': collectionId,
      if (uid != null) 'uid': uid,
      if (etag != null) 'etag': etag,
      if (formattedName != null) 'formatted_name': formattedName,
      if (givenName != null) 'given_name': givenName,
      if (familyName != null) 'family_name': familyName,
      if (organization != null) 'organization': organization,
      if (primaryEmail != null) 'primary_email': primaryEmail,
      if (primaryPhone != null) 'primary_phone': primaryPhone,
      if (rawVcard != null) 'raw_vcard': rawVcard,
      if (photoRef != null) 'photo_ref': photoRef,
      if (lastModified != null) 'last_modified': lastModified,
      if (deletedLocally != null) 'deleted_locally': deletedLocally,
    });
  }

  ContactCardsCompanion copyWith({
    Value<int>? id,
    Value<int>? collectionId,
    Value<String>? uid,
    Value<String?>? etag,
    Value<String?>? formattedName,
    Value<String?>? givenName,
    Value<String?>? familyName,
    Value<String?>? organization,
    Value<String?>? primaryEmail,
    Value<String?>? primaryPhone,
    Value<String>? rawVcard,
    Value<String?>? photoRef,
    Value<DateTime>? lastModified,
    Value<bool>? deletedLocally,
  }) {
    return ContactCardsCompanion(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      uid: uid ?? this.uid,
      etag: etag ?? this.etag,
      formattedName: formattedName ?? this.formattedName,
      givenName: givenName ?? this.givenName,
      familyName: familyName ?? this.familyName,
      organization: organization ?? this.organization,
      primaryEmail: primaryEmail ?? this.primaryEmail,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      rawVcard: rawVcard ?? this.rawVcard,
      photoRef: photoRef ?? this.photoRef,
      lastModified: lastModified ?? this.lastModified,
      deletedLocally: deletedLocally ?? this.deletedLocally,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<int>(collectionId.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (formattedName.present) {
      map['formatted_name'] = Variable<String>(formattedName.value);
    }
    if (givenName.present) {
      map['given_name'] = Variable<String>(givenName.value);
    }
    if (familyName.present) {
      map['family_name'] = Variable<String>(familyName.value);
    }
    if (organization.present) {
      map['organization'] = Variable<String>(organization.value);
    }
    if (primaryEmail.present) {
      map['primary_email'] = Variable<String>(primaryEmail.value);
    }
    if (primaryPhone.present) {
      map['primary_phone'] = Variable<String>(primaryPhone.value);
    }
    if (rawVcard.present) {
      map['raw_vcard'] = Variable<String>(rawVcard.value);
    }
    if (photoRef.present) {
      map['photo_ref'] = Variable<String>(photoRef.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (deletedLocally.present) {
      map['deleted_locally'] = Variable<bool>(deletedLocally.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactCardsCompanion(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('uid: $uid, ')
          ..write('etag: $etag, ')
          ..write('formattedName: $formattedName, ')
          ..write('givenName: $givenName, ')
          ..write('familyName: $familyName, ')
          ..write('organization: $organization, ')
          ..write('primaryEmail: $primaryEmail, ')
          ..write('primaryPhone: $primaryPhone, ')
          ..write('rawVcard: $rawVcard, ')
          ..write('photoRef: $photoRef, ')
          ..write('lastModified: $lastModified, ')
          ..write('deletedLocally: $deletedLocally')
          ..write(')'))
        .toString();
  }
}

class $ContactGroupsTable extends ContactGroups
    with TableInfo<$ContactGroupsTable, ContactGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactGroupsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<int> collectionId = GeneratedColumn<int>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES collections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, collectionId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contact_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContactGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContactGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContactGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $ContactGroupsTable createAlias(String alias) {
    return $ContactGroupsTable(attachedDatabase, alias);
  }
}

class ContactGroup extends DataClass implements Insertable<ContactGroup> {
  final int id;
  final int collectionId;
  final String name;
  const ContactGroup({
    required this.id,
    required this.collectionId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['collection_id'] = Variable<int>(collectionId);
    map['name'] = Variable<String>(name);
    return map;
  }

  ContactGroupsCompanion toCompanion(bool nullToAbsent) {
    return ContactGroupsCompanion(
      id: Value(id),
      collectionId: Value(collectionId),
      name: Value(name),
    );
  }

  factory ContactGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContactGroup(
      id: serializer.fromJson<int>(json['id']),
      collectionId: serializer.fromJson<int>(json['collectionId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'collectionId': serializer.toJson<int>(collectionId),
      'name': serializer.toJson<String>(name),
    };
  }

  ContactGroup copyWith({int? id, int? collectionId, String? name}) =>
      ContactGroup(
        id: id ?? this.id,
        collectionId: collectionId ?? this.collectionId,
        name: name ?? this.name,
      );
  ContactGroup copyWithCompanion(ContactGroupsCompanion data) {
    return ContactGroup(
      id: data.id.present ? data.id.value : this.id,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContactGroup(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, collectionId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactGroup &&
          other.id == this.id &&
          other.collectionId == this.collectionId &&
          other.name == this.name);
}

class ContactGroupsCompanion extends UpdateCompanion<ContactGroup> {
  final Value<int> id;
  final Value<int> collectionId;
  final Value<String> name;
  const ContactGroupsCompanion({
    this.id = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.name = const Value.absent(),
  });
  ContactGroupsCompanion.insert({
    this.id = const Value.absent(),
    required int collectionId,
    required String name,
  }) : collectionId = Value(collectionId),
       name = Value(name);
  static Insertable<ContactGroup> custom({
    Expression<int>? id,
    Expression<int>? collectionId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collectionId != null) 'collection_id': collectionId,
      if (name != null) 'name': name,
    });
  }

  ContactGroupsCompanion copyWith({
    Value<int>? id,
    Value<int>? collectionId,
    Value<String>? name,
  }) {
    return ContactGroupsCompanion(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<int>(collectionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactGroupsCompanion(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ContactGroupMembersTable extends ContactGroupMembers
    with TableInfo<$ContactGroupMembersTable, ContactGroupMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactGroupMembersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contact_groups (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _contactIdMeta = const VerificationMeta(
    'contactId',
  );
  @override
  late final GeneratedColumn<int> contactId = GeneratedColumn<int>(
    'contact_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contact_cards (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, groupId, contactId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contact_group_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContactGroupMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('contact_id')) {
      context.handle(
        _contactIdMeta,
        contactId.isAcceptableOrUnknown(data['contact_id']!, _contactIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contactIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContactGroupMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContactGroupMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
      contactId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contact_id'],
      )!,
    );
  }

  @override
  $ContactGroupMembersTable createAlias(String alias) {
    return $ContactGroupMembersTable(attachedDatabase, alias);
  }
}

class ContactGroupMember extends DataClass
    implements Insertable<ContactGroupMember> {
  final int id;
  final int groupId;
  final int contactId;
  const ContactGroupMember({
    required this.id,
    required this.groupId,
    required this.contactId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['contact_id'] = Variable<int>(contactId);
    return map;
  }

  ContactGroupMembersCompanion toCompanion(bool nullToAbsent) {
    return ContactGroupMembersCompanion(
      id: Value(id),
      groupId: Value(groupId),
      contactId: Value(contactId),
    );
  }

  factory ContactGroupMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContactGroupMember(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      contactId: serializer.fromJson<int>(json['contactId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'contactId': serializer.toJson<int>(contactId),
    };
  }

  ContactGroupMember copyWith({int? id, int? groupId, int? contactId}) =>
      ContactGroupMember(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        contactId: contactId ?? this.contactId,
      );
  ContactGroupMember copyWithCompanion(ContactGroupMembersCompanion data) {
    return ContactGroupMember(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      contactId: data.contactId.present ? data.contactId.value : this.contactId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContactGroupMember(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('contactId: $contactId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, contactId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactGroupMember &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.contactId == this.contactId);
}

class ContactGroupMembersCompanion extends UpdateCompanion<ContactGroupMember> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> contactId;
  const ContactGroupMembersCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.contactId = const Value.absent(),
  });
  ContactGroupMembersCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int contactId,
  }) : groupId = Value(groupId),
       contactId = Value(contactId);
  static Insertable<ContactGroupMember> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? contactId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (contactId != null) 'contact_id': contactId,
    });
  }

  ContactGroupMembersCompanion copyWith({
    Value<int>? id,
    Value<int>? groupId,
    Value<int>? contactId,
  }) {
    return ContactGroupMembersCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      contactId: contactId ?? this.contactId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (contactId.present) {
      map['contact_id'] = Variable<int>(contactId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactGroupMembersCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('contactId: $contactId')
          ..write(')'))
        .toString();
  }
}

class $TodoItemsTable extends TodoItems
    with TableInfo<$TodoItemsTable, TodoItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<int> collectionId = GeneratedColumn<int>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES collections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
    'due',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<DateTime> completed = GeneratedColumn<DateTime>(
    'completed',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _percentCompleteMeta = const VerificationMeta(
    'percentComplete',
  );
  @override
  late final GeneratedColumn<int> percentComplete = GeneratedColumn<int>(
    'percent_complete',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rruleMeta = const VerificationMeta('rrule');
  @override
  late final GeneratedColumn<String> rrule = GeneratedColumn<String>(
    'rrule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatAfterCompletionMeta =
      const VerificationMeta('repeatAfterCompletion');
  @override
  late final GeneratedColumn<bool> repeatAfterCompletion =
      GeneratedColumn<bool>(
        'repeat_after_completion',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("repeat_after_completion" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _parentUidMeta = const VerificationMeta(
    'parentUid',
  );
  @override
  late final GeneratedColumn<String> parentUid = GeneratedColumn<String>(
    'parent_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawIcsMeta = const VerificationMeta('rawIcs');
  @override
  late final GeneratedColumn<String> rawIcs = GeneratedColumn<String>(
    'raw_ics',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedLocallyMeta = const VerificationMeta(
    'deletedLocally',
  );
  @override
  late final GeneratedColumn<bool> deletedLocally = GeneratedColumn<bool>(
    'deleted_locally',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_locally" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    collectionId,
    uid,
    etag,
    summary,
    description,
    due,
    completed,
    percentComplete,
    priority,
    rrule,
    repeatAfterCompletion,
    parentUid,
    rawIcs,
    lastModified,
    deletedLocally,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('percent_complete')) {
      context.handle(
        _percentCompleteMeta,
        percentComplete.isAcceptableOrUnknown(
          data['percent_complete']!,
          _percentCompleteMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('rrule')) {
      context.handle(
        _rruleMeta,
        rrule.isAcceptableOrUnknown(data['rrule']!, _rruleMeta),
      );
    }
    if (data.containsKey('repeat_after_completion')) {
      context.handle(
        _repeatAfterCompletionMeta,
        repeatAfterCompletion.isAcceptableOrUnknown(
          data['repeat_after_completion']!,
          _repeatAfterCompletionMeta,
        ),
      );
    }
    if (data.containsKey('parent_uid')) {
      context.handle(
        _parentUidMeta,
        parentUid.isAcceptableOrUnknown(data['parent_uid']!, _parentUidMeta),
      );
    }
    if (data.containsKey('raw_ics')) {
      context.handle(
        _rawIcsMeta,
        rawIcs.isAcceptableOrUnknown(data['raw_ics']!, _rawIcsMeta),
      );
    } else if (isInserting) {
      context.missing(_rawIcsMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('deleted_locally')) {
      context.handle(
        _deletedLocallyMeta,
        deletedLocally.isAcceptableOrUnknown(
          data['deleted_locally']!,
          _deletedLocallyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {collectionId, uid},
  ];
  @override
  TodoItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_id'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed'],
      ),
      percentComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}percent_complete'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      ),
      rrule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rrule'],
      ),
      repeatAfterCompletion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}repeat_after_completion'],
      )!,
      parentUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_uid'],
      ),
      rawIcs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_ics'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
      deletedLocally: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_locally'],
      )!,
    );
  }

  @override
  $TodoItemsTable createAlias(String alias) {
    return $TodoItemsTable(attachedDatabase, alias);
  }
}

class TodoItem extends DataClass implements Insertable<TodoItem> {
  final int id;
  final int collectionId;
  final String uid;
  final String? etag;
  final String? summary;
  final String? description;
  final DateTime? due;
  final DateTime? completed;
  final int? percentComplete;
  final int? priority;
  final String? rrule;
  final bool repeatAfterCompletion;
  final String? parentUid;
  final String rawIcs;
  final DateTime lastModified;
  final bool deletedLocally;
  const TodoItem({
    required this.id,
    required this.collectionId,
    required this.uid,
    this.etag,
    this.summary,
    this.description,
    this.due,
    this.completed,
    this.percentComplete,
    this.priority,
    this.rrule,
    required this.repeatAfterCompletion,
    this.parentUid,
    required this.rawIcs,
    required this.lastModified,
    required this.deletedLocally,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['collection_id'] = Variable<int>(collectionId);
    map['uid'] = Variable<String>(uid);
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || due != null) {
      map['due'] = Variable<DateTime>(due);
    }
    if (!nullToAbsent || completed != null) {
      map['completed'] = Variable<DateTime>(completed);
    }
    if (!nullToAbsent || percentComplete != null) {
      map['percent_complete'] = Variable<int>(percentComplete);
    }
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<int>(priority);
    }
    if (!nullToAbsent || rrule != null) {
      map['rrule'] = Variable<String>(rrule);
    }
    map['repeat_after_completion'] = Variable<bool>(repeatAfterCompletion);
    if (!nullToAbsent || parentUid != null) {
      map['parent_uid'] = Variable<String>(parentUid);
    }
    map['raw_ics'] = Variable<String>(rawIcs);
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['deleted_locally'] = Variable<bool>(deletedLocally);
    return map;
  }

  TodoItemsCompanion toCompanion(bool nullToAbsent) {
    return TodoItemsCompanion(
      id: Value(id),
      collectionId: Value(collectionId),
      uid: Value(uid),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      due: due == null && nullToAbsent ? const Value.absent() : Value(due),
      completed: completed == null && nullToAbsent
          ? const Value.absent()
          : Value(completed),
      percentComplete: percentComplete == null && nullToAbsent
          ? const Value.absent()
          : Value(percentComplete),
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
      rrule: rrule == null && nullToAbsent
          ? const Value.absent()
          : Value(rrule),
      repeatAfterCompletion: Value(repeatAfterCompletion),
      parentUid: parentUid == null && nullToAbsent
          ? const Value.absent()
          : Value(parentUid),
      rawIcs: Value(rawIcs),
      lastModified: Value(lastModified),
      deletedLocally: Value(deletedLocally),
    );
  }

  factory TodoItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoItem(
      id: serializer.fromJson<int>(json['id']),
      collectionId: serializer.fromJson<int>(json['collectionId']),
      uid: serializer.fromJson<String>(json['uid']),
      etag: serializer.fromJson<String?>(json['etag']),
      summary: serializer.fromJson<String?>(json['summary']),
      description: serializer.fromJson<String?>(json['description']),
      due: serializer.fromJson<DateTime?>(json['due']),
      completed: serializer.fromJson<DateTime?>(json['completed']),
      percentComplete: serializer.fromJson<int?>(json['percentComplete']),
      priority: serializer.fromJson<int?>(json['priority']),
      rrule: serializer.fromJson<String?>(json['rrule']),
      repeatAfterCompletion: serializer.fromJson<bool>(
        json['repeatAfterCompletion'],
      ),
      parentUid: serializer.fromJson<String?>(json['parentUid']),
      rawIcs: serializer.fromJson<String>(json['rawIcs']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      deletedLocally: serializer.fromJson<bool>(json['deletedLocally']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'collectionId': serializer.toJson<int>(collectionId),
      'uid': serializer.toJson<String>(uid),
      'etag': serializer.toJson<String?>(etag),
      'summary': serializer.toJson<String?>(summary),
      'description': serializer.toJson<String?>(description),
      'due': serializer.toJson<DateTime?>(due),
      'completed': serializer.toJson<DateTime?>(completed),
      'percentComplete': serializer.toJson<int?>(percentComplete),
      'priority': serializer.toJson<int?>(priority),
      'rrule': serializer.toJson<String?>(rrule),
      'repeatAfterCompletion': serializer.toJson<bool>(repeatAfterCompletion),
      'parentUid': serializer.toJson<String?>(parentUid),
      'rawIcs': serializer.toJson<String>(rawIcs),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'deletedLocally': serializer.toJson<bool>(deletedLocally),
    };
  }

  TodoItem copyWith({
    int? id,
    int? collectionId,
    String? uid,
    Value<String?> etag = const Value.absent(),
    Value<String?> summary = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<DateTime?> due = const Value.absent(),
    Value<DateTime?> completed = const Value.absent(),
    Value<int?> percentComplete = const Value.absent(),
    Value<int?> priority = const Value.absent(),
    Value<String?> rrule = const Value.absent(),
    bool? repeatAfterCompletion,
    Value<String?> parentUid = const Value.absent(),
    String? rawIcs,
    DateTime? lastModified,
    bool? deletedLocally,
  }) => TodoItem(
    id: id ?? this.id,
    collectionId: collectionId ?? this.collectionId,
    uid: uid ?? this.uid,
    etag: etag.present ? etag.value : this.etag,
    summary: summary.present ? summary.value : this.summary,
    description: description.present ? description.value : this.description,
    due: due.present ? due.value : this.due,
    completed: completed.present ? completed.value : this.completed,
    percentComplete: percentComplete.present
        ? percentComplete.value
        : this.percentComplete,
    priority: priority.present ? priority.value : this.priority,
    rrule: rrule.present ? rrule.value : this.rrule,
    repeatAfterCompletion: repeatAfterCompletion ?? this.repeatAfterCompletion,
    parentUid: parentUid.present ? parentUid.value : this.parentUid,
    rawIcs: rawIcs ?? this.rawIcs,
    lastModified: lastModified ?? this.lastModified,
    deletedLocally: deletedLocally ?? this.deletedLocally,
  );
  TodoItem copyWithCompanion(TodoItemsCompanion data) {
    return TodoItem(
      id: data.id.present ? data.id.value : this.id,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      uid: data.uid.present ? data.uid.value : this.uid,
      etag: data.etag.present ? data.etag.value : this.etag,
      summary: data.summary.present ? data.summary.value : this.summary,
      description: data.description.present
          ? data.description.value
          : this.description,
      due: data.due.present ? data.due.value : this.due,
      completed: data.completed.present ? data.completed.value : this.completed,
      percentComplete: data.percentComplete.present
          ? data.percentComplete.value
          : this.percentComplete,
      priority: data.priority.present ? data.priority.value : this.priority,
      rrule: data.rrule.present ? data.rrule.value : this.rrule,
      repeatAfterCompletion: data.repeatAfterCompletion.present
          ? data.repeatAfterCompletion.value
          : this.repeatAfterCompletion,
      parentUid: data.parentUid.present ? data.parentUid.value : this.parentUid,
      rawIcs: data.rawIcs.present ? data.rawIcs.value : this.rawIcs,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      deletedLocally: data.deletedLocally.present
          ? data.deletedLocally.value
          : this.deletedLocally,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoItem(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('uid: $uid, ')
          ..write('etag: $etag, ')
          ..write('summary: $summary, ')
          ..write('description: $description, ')
          ..write('due: $due, ')
          ..write('completed: $completed, ')
          ..write('percentComplete: $percentComplete, ')
          ..write('priority: $priority, ')
          ..write('rrule: $rrule, ')
          ..write('repeatAfterCompletion: $repeatAfterCompletion, ')
          ..write('parentUid: $parentUid, ')
          ..write('rawIcs: $rawIcs, ')
          ..write('lastModified: $lastModified, ')
          ..write('deletedLocally: $deletedLocally')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    collectionId,
    uid,
    etag,
    summary,
    description,
    due,
    completed,
    percentComplete,
    priority,
    rrule,
    repeatAfterCompletion,
    parentUid,
    rawIcs,
    lastModified,
    deletedLocally,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoItem &&
          other.id == this.id &&
          other.collectionId == this.collectionId &&
          other.uid == this.uid &&
          other.etag == this.etag &&
          other.summary == this.summary &&
          other.description == this.description &&
          other.due == this.due &&
          other.completed == this.completed &&
          other.percentComplete == this.percentComplete &&
          other.priority == this.priority &&
          other.rrule == this.rrule &&
          other.repeatAfterCompletion == this.repeatAfterCompletion &&
          other.parentUid == this.parentUid &&
          other.rawIcs == this.rawIcs &&
          other.lastModified == this.lastModified &&
          other.deletedLocally == this.deletedLocally);
}

class TodoItemsCompanion extends UpdateCompanion<TodoItem> {
  final Value<int> id;
  final Value<int> collectionId;
  final Value<String> uid;
  final Value<String?> etag;
  final Value<String?> summary;
  final Value<String?> description;
  final Value<DateTime?> due;
  final Value<DateTime?> completed;
  final Value<int?> percentComplete;
  final Value<int?> priority;
  final Value<String?> rrule;
  final Value<bool> repeatAfterCompletion;
  final Value<String?> parentUid;
  final Value<String> rawIcs;
  final Value<DateTime> lastModified;
  final Value<bool> deletedLocally;
  const TodoItemsCompanion({
    this.id = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.uid = const Value.absent(),
    this.etag = const Value.absent(),
    this.summary = const Value.absent(),
    this.description = const Value.absent(),
    this.due = const Value.absent(),
    this.completed = const Value.absent(),
    this.percentComplete = const Value.absent(),
    this.priority = const Value.absent(),
    this.rrule = const Value.absent(),
    this.repeatAfterCompletion = const Value.absent(),
    this.parentUid = const Value.absent(),
    this.rawIcs = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.deletedLocally = const Value.absent(),
  });
  TodoItemsCompanion.insert({
    this.id = const Value.absent(),
    required int collectionId,
    required String uid,
    this.etag = const Value.absent(),
    this.summary = const Value.absent(),
    this.description = const Value.absent(),
    this.due = const Value.absent(),
    this.completed = const Value.absent(),
    this.percentComplete = const Value.absent(),
    this.priority = const Value.absent(),
    this.rrule = const Value.absent(),
    this.repeatAfterCompletion = const Value.absent(),
    this.parentUid = const Value.absent(),
    required String rawIcs,
    this.lastModified = const Value.absent(),
    this.deletedLocally = const Value.absent(),
  }) : collectionId = Value(collectionId),
       uid = Value(uid),
       rawIcs = Value(rawIcs);
  static Insertable<TodoItem> custom({
    Expression<int>? id,
    Expression<int>? collectionId,
    Expression<String>? uid,
    Expression<String>? etag,
    Expression<String>? summary,
    Expression<String>? description,
    Expression<DateTime>? due,
    Expression<DateTime>? completed,
    Expression<int>? percentComplete,
    Expression<int>? priority,
    Expression<String>? rrule,
    Expression<bool>? repeatAfterCompletion,
    Expression<String>? parentUid,
    Expression<String>? rawIcs,
    Expression<DateTime>? lastModified,
    Expression<bool>? deletedLocally,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collectionId != null) 'collection_id': collectionId,
      if (uid != null) 'uid': uid,
      if (etag != null) 'etag': etag,
      if (summary != null) 'summary': summary,
      if (description != null) 'description': description,
      if (due != null) 'due': due,
      if (completed != null) 'completed': completed,
      if (percentComplete != null) 'percent_complete': percentComplete,
      if (priority != null) 'priority': priority,
      if (rrule != null) 'rrule': rrule,
      if (repeatAfterCompletion != null)
        'repeat_after_completion': repeatAfterCompletion,
      if (parentUid != null) 'parent_uid': parentUid,
      if (rawIcs != null) 'raw_ics': rawIcs,
      if (lastModified != null) 'last_modified': lastModified,
      if (deletedLocally != null) 'deleted_locally': deletedLocally,
    });
  }

  TodoItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? collectionId,
    Value<String>? uid,
    Value<String?>? etag,
    Value<String?>? summary,
    Value<String?>? description,
    Value<DateTime?>? due,
    Value<DateTime?>? completed,
    Value<int?>? percentComplete,
    Value<int?>? priority,
    Value<String?>? rrule,
    Value<bool>? repeatAfterCompletion,
    Value<String?>? parentUid,
    Value<String>? rawIcs,
    Value<DateTime>? lastModified,
    Value<bool>? deletedLocally,
  }) {
    return TodoItemsCompanion(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      uid: uid ?? this.uid,
      etag: etag ?? this.etag,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      due: due ?? this.due,
      completed: completed ?? this.completed,
      percentComplete: percentComplete ?? this.percentComplete,
      priority: priority ?? this.priority,
      rrule: rrule ?? this.rrule,
      repeatAfterCompletion:
          repeatAfterCompletion ?? this.repeatAfterCompletion,
      parentUid: parentUid ?? this.parentUid,
      rawIcs: rawIcs ?? this.rawIcs,
      lastModified: lastModified ?? this.lastModified,
      deletedLocally: deletedLocally ?? this.deletedLocally,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<int>(collectionId.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    if (completed.present) {
      map['completed'] = Variable<DateTime>(completed.value);
    }
    if (percentComplete.present) {
      map['percent_complete'] = Variable<int>(percentComplete.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (rrule.present) {
      map['rrule'] = Variable<String>(rrule.value);
    }
    if (repeatAfterCompletion.present) {
      map['repeat_after_completion'] = Variable<bool>(
        repeatAfterCompletion.value,
      );
    }
    if (parentUid.present) {
      map['parent_uid'] = Variable<String>(parentUid.value);
    }
    if (rawIcs.present) {
      map['raw_ics'] = Variable<String>(rawIcs.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (deletedLocally.present) {
      map['deleted_locally'] = Variable<bool>(deletedLocally.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoItemsCompanion(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('uid: $uid, ')
          ..write('etag: $etag, ')
          ..write('summary: $summary, ')
          ..write('description: $description, ')
          ..write('due: $due, ')
          ..write('completed: $completed, ')
          ..write('percentComplete: $percentComplete, ')
          ..write('priority: $priority, ')
          ..write('rrule: $rrule, ')
          ..write('repeatAfterCompletion: $repeatAfterCompletion, ')
          ..write('parentUid: $parentUid, ')
          ..write('rawIcs: $rawIcs, ')
          ..write('lastModified: $lastModified, ')
          ..write('deletedLocally: $deletedLocally')
          ..write(')'))
        .toString();
  }
}

class $NoteItemsTable extends NoteItems
    with TableInfo<$NoteItemsTable, NoteItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<int> collectionId = GeneratedColumn<int>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES collections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('text'),
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lockedMeta = const VerificationMeta('locked');
  @override
  late final GeneratedColumn<bool> locked = GeneratedColumn<bool>(
    'locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _modifiedMeta = const VerificationMeta(
    'modified',
  );
  @override
  late final GeneratedColumn<DateTime> modified = GeneratedColumn<DateTime>(
    'modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedLocallyMeta = const VerificationMeta(
    'deletedLocally',
  );
  @override
  late final GeneratedColumn<bool> deletedLocally = GeneratedColumn<bool>(
    'deleted_locally',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_locally" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    collectionId,
    remoteId,
    etag,
    title,
    category,
    content,
    kind,
    favorite,
    locked,
    modified,
    deletedLocally,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    if (data.containsKey('locked')) {
      context.handle(
        _lockedMeta,
        locked.isAcceptableOrUnknown(data['locked']!, _lockedMeta),
      );
    }
    if (data.containsKey('modified')) {
      context.handle(
        _modifiedMeta,
        modified.isAcceptableOrUnknown(data['modified']!, _modifiedMeta),
      );
    }
    if (data.containsKey('deleted_locally')) {
      context.handle(
        _deletedLocallyMeta,
        deletedLocally.isAcceptableOrUnknown(
          data['deleted_locally']!,
          _deletedLocallyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {collectionId, remoteId},
  ];
  @override
  NoteItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
      locked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}locked'],
      )!,
      modified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified'],
      )!,
      deletedLocally: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_locally'],
      )!,
    );
  }

  @override
  $NoteItemsTable createAlias(String alias) {
    return $NoteItemsTable(attachedDatabase, alias);
  }
}

class NoteItem extends DataClass implements Insertable<NoteItem> {
  final int id;
  final int collectionId;
  final String? remoteId;
  final String? etag;
  final String title;
  final String? category;
  final String content;
  final String kind;
  final bool favorite;
  final bool locked;
  final DateTime modified;
  final bool deletedLocally;
  const NoteItem({
    required this.id,
    required this.collectionId,
    this.remoteId,
    this.etag,
    required this.title,
    this.category,
    required this.content,
    required this.kind,
    required this.favorite,
    required this.locked,
    required this.modified,
    required this.deletedLocally,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['collection_id'] = Variable<int>(collectionId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['content'] = Variable<String>(content);
    map['kind'] = Variable<String>(kind);
    map['favorite'] = Variable<bool>(favorite);
    map['locked'] = Variable<bool>(locked);
    map['modified'] = Variable<DateTime>(modified);
    map['deleted_locally'] = Variable<bool>(deletedLocally);
    return map;
  }

  NoteItemsCompanion toCompanion(bool nullToAbsent) {
    return NoteItemsCompanion(
      id: Value(id),
      collectionId: Value(collectionId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      title: Value(title),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      content: Value(content),
      kind: Value(kind),
      favorite: Value(favorite),
      locked: Value(locked),
      modified: Value(modified),
      deletedLocally: Value(deletedLocally),
    );
  }

  factory NoteItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteItem(
      id: serializer.fromJson<int>(json['id']),
      collectionId: serializer.fromJson<int>(json['collectionId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      etag: serializer.fromJson<String?>(json['etag']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String?>(json['category']),
      content: serializer.fromJson<String>(json['content']),
      kind: serializer.fromJson<String>(json['kind']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      locked: serializer.fromJson<bool>(json['locked']),
      modified: serializer.fromJson<DateTime>(json['modified']),
      deletedLocally: serializer.fromJson<bool>(json['deletedLocally']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'collectionId': serializer.toJson<int>(collectionId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'etag': serializer.toJson<String?>(etag),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String?>(category),
      'content': serializer.toJson<String>(content),
      'kind': serializer.toJson<String>(kind),
      'favorite': serializer.toJson<bool>(favorite),
      'locked': serializer.toJson<bool>(locked),
      'modified': serializer.toJson<DateTime>(modified),
      'deletedLocally': serializer.toJson<bool>(deletedLocally),
    };
  }

  NoteItem copyWith({
    int? id,
    int? collectionId,
    Value<String?> remoteId = const Value.absent(),
    Value<String?> etag = const Value.absent(),
    String? title,
    Value<String?> category = const Value.absent(),
    String? content,
    String? kind,
    bool? favorite,
    bool? locked,
    DateTime? modified,
    bool? deletedLocally,
  }) => NoteItem(
    id: id ?? this.id,
    collectionId: collectionId ?? this.collectionId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    etag: etag.present ? etag.value : this.etag,
    title: title ?? this.title,
    category: category.present ? category.value : this.category,
    content: content ?? this.content,
    kind: kind ?? this.kind,
    favorite: favorite ?? this.favorite,
    locked: locked ?? this.locked,
    modified: modified ?? this.modified,
    deletedLocally: deletedLocally ?? this.deletedLocally,
  );
  NoteItem copyWithCompanion(NoteItemsCompanion data) {
    return NoteItem(
      id: data.id.present ? data.id.value : this.id,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      etag: data.etag.present ? data.etag.value : this.etag,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      content: data.content.present ? data.content.value : this.content,
      kind: data.kind.present ? data.kind.value : this.kind,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      locked: data.locked.present ? data.locked.value : this.locked,
      modified: data.modified.present ? data.modified.value : this.modified,
      deletedLocally: data.deletedLocally.present
          ? data.deletedLocally.value
          : this.deletedLocally,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteItem(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('remoteId: $remoteId, ')
          ..write('etag: $etag, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('content: $content, ')
          ..write('kind: $kind, ')
          ..write('favorite: $favorite, ')
          ..write('locked: $locked, ')
          ..write('modified: $modified, ')
          ..write('deletedLocally: $deletedLocally')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    collectionId,
    remoteId,
    etag,
    title,
    category,
    content,
    kind,
    favorite,
    locked,
    modified,
    deletedLocally,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteItem &&
          other.id == this.id &&
          other.collectionId == this.collectionId &&
          other.remoteId == this.remoteId &&
          other.etag == this.etag &&
          other.title == this.title &&
          other.category == this.category &&
          other.content == this.content &&
          other.kind == this.kind &&
          other.favorite == this.favorite &&
          other.locked == this.locked &&
          other.modified == this.modified &&
          other.deletedLocally == this.deletedLocally);
}

class NoteItemsCompanion extends UpdateCompanion<NoteItem> {
  final Value<int> id;
  final Value<int> collectionId;
  final Value<String?> remoteId;
  final Value<String?> etag;
  final Value<String> title;
  final Value<String?> category;
  final Value<String> content;
  final Value<String> kind;
  final Value<bool> favorite;
  final Value<bool> locked;
  final Value<DateTime> modified;
  final Value<bool> deletedLocally;
  const NoteItemsCompanion({
    this.id = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.etag = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.content = const Value.absent(),
    this.kind = const Value.absent(),
    this.favorite = const Value.absent(),
    this.locked = const Value.absent(),
    this.modified = const Value.absent(),
    this.deletedLocally = const Value.absent(),
  });
  NoteItemsCompanion.insert({
    this.id = const Value.absent(),
    required int collectionId,
    this.remoteId = const Value.absent(),
    this.etag = const Value.absent(),
    required String title,
    this.category = const Value.absent(),
    required String content,
    this.kind = const Value.absent(),
    this.favorite = const Value.absent(),
    this.locked = const Value.absent(),
    this.modified = const Value.absent(),
    this.deletedLocally = const Value.absent(),
  }) : collectionId = Value(collectionId),
       title = Value(title),
       content = Value(content);
  static Insertable<NoteItem> custom({
    Expression<int>? id,
    Expression<int>? collectionId,
    Expression<String>? remoteId,
    Expression<String>? etag,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? content,
    Expression<String>? kind,
    Expression<bool>? favorite,
    Expression<bool>? locked,
    Expression<DateTime>? modified,
    Expression<bool>? deletedLocally,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collectionId != null) 'collection_id': collectionId,
      if (remoteId != null) 'remote_id': remoteId,
      if (etag != null) 'etag': etag,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (content != null) 'content': content,
      if (kind != null) 'kind': kind,
      if (favorite != null) 'favorite': favorite,
      if (locked != null) 'locked': locked,
      if (modified != null) 'modified': modified,
      if (deletedLocally != null) 'deleted_locally': deletedLocally,
    });
  }

  NoteItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? collectionId,
    Value<String?>? remoteId,
    Value<String?>? etag,
    Value<String>? title,
    Value<String?>? category,
    Value<String>? content,
    Value<String>? kind,
    Value<bool>? favorite,
    Value<bool>? locked,
    Value<DateTime>? modified,
    Value<bool>? deletedLocally,
  }) {
    return NoteItemsCompanion(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      remoteId: remoteId ?? this.remoteId,
      etag: etag ?? this.etag,
      title: title ?? this.title,
      category: category ?? this.category,
      content: content ?? this.content,
      kind: kind ?? this.kind,
      favorite: favorite ?? this.favorite,
      locked: locked ?? this.locked,
      modified: modified ?? this.modified,
      deletedLocally: deletedLocally ?? this.deletedLocally,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<int>(collectionId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (locked.present) {
      map['locked'] = Variable<bool>(locked.value);
    }
    if (modified.present) {
      map['modified'] = Variable<DateTime>(modified.value);
    }
    if (deletedLocally.present) {
      map['deleted_locally'] = Variable<bool>(deletedLocally.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteItemsCompanion(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('remoteId: $remoteId, ')
          ..write('etag: $etag, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('content: $content, ')
          ..write('kind: $kind, ')
          ..write('favorite: $favorite, ')
          ..write('locked: $locked, ')
          ..write('modified: $modified, ')
          ..write('deletedLocally: $deletedLocally')
          ..write(')'))
        .toString();
  }
}

class $FeedSubscriptionsTable extends FeedSubscriptions
    with TableInfo<$FeedSubscriptionsTable, FeedSubscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedSubscriptionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folderMeta = const VerificationMeta('folder');
  @override
  late final GeneratedColumn<String> folder = GeneratedColumn<String>(
    'folder',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refreshIntervalMinutesMeta =
      const VerificationMeta('refreshIntervalMinutes');
  @override
  late final GeneratedColumn<int> refreshIntervalMinutes = GeneratedColumn<int>(
    'refresh_interval_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _lastFetchedMeta = const VerificationMeta(
    'lastFetched',
  );
  @override
  late final GeneratedColumn<DateTime> lastFetched = GeneratedColumn<DateTime>(
    'last_fetched',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    url,
    title,
    folder,
    refreshIntervalMinutes,
    lastFetched,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feed_subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeedSubscription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('folder')) {
      context.handle(
        _folderMeta,
        folder.isAcceptableOrUnknown(data['folder']!, _folderMeta),
      );
    }
    if (data.containsKey('refresh_interval_minutes')) {
      context.handle(
        _refreshIntervalMinutesMeta,
        refreshIntervalMinutes.isAcceptableOrUnknown(
          data['refresh_interval_minutes']!,
          _refreshIntervalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('last_fetched')) {
      context.handle(
        _lastFetchedMeta,
        lastFetched.isAcceptableOrUnknown(
          data['last_fetched']!,
          _lastFetchedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedSubscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedSubscription(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder'],
      ),
      refreshIntervalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}refresh_interval_minutes'],
      )!,
      lastFetched: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_fetched'],
      ),
    );
  }

  @override
  $FeedSubscriptionsTable createAlias(String alias) {
    return $FeedSubscriptionsTable(attachedDatabase, alias);
  }
}

class FeedSubscription extends DataClass
    implements Insertable<FeedSubscription> {
  final int id;
  final int accountId;
  final String url;
  final String title;
  final String? folder;
  final int refreshIntervalMinutes;
  final DateTime? lastFetched;
  const FeedSubscription({
    required this.id,
    required this.accountId,
    required this.url,
    required this.title,
    this.folder,
    required this.refreshIntervalMinutes,
    this.lastFetched,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['url'] = Variable<String>(url);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || folder != null) {
      map['folder'] = Variable<String>(folder);
    }
    map['refresh_interval_minutes'] = Variable<int>(refreshIntervalMinutes);
    if (!nullToAbsent || lastFetched != null) {
      map['last_fetched'] = Variable<DateTime>(lastFetched);
    }
    return map;
  }

  FeedSubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return FeedSubscriptionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      url: Value(url),
      title: Value(title),
      folder: folder == null && nullToAbsent
          ? const Value.absent()
          : Value(folder),
      refreshIntervalMinutes: Value(refreshIntervalMinutes),
      lastFetched: lastFetched == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFetched),
    );
  }

  factory FeedSubscription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedSubscription(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      url: serializer.fromJson<String>(json['url']),
      title: serializer.fromJson<String>(json['title']),
      folder: serializer.fromJson<String?>(json['folder']),
      refreshIntervalMinutes: serializer.fromJson<int>(
        json['refreshIntervalMinutes'],
      ),
      lastFetched: serializer.fromJson<DateTime?>(json['lastFetched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'url': serializer.toJson<String>(url),
      'title': serializer.toJson<String>(title),
      'folder': serializer.toJson<String?>(folder),
      'refreshIntervalMinutes': serializer.toJson<int>(refreshIntervalMinutes),
      'lastFetched': serializer.toJson<DateTime?>(lastFetched),
    };
  }

  FeedSubscription copyWith({
    int? id,
    int? accountId,
    String? url,
    String? title,
    Value<String?> folder = const Value.absent(),
    int? refreshIntervalMinutes,
    Value<DateTime?> lastFetched = const Value.absent(),
  }) => FeedSubscription(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    url: url ?? this.url,
    title: title ?? this.title,
    folder: folder.present ? folder.value : this.folder,
    refreshIntervalMinutes:
        refreshIntervalMinutes ?? this.refreshIntervalMinutes,
    lastFetched: lastFetched.present ? lastFetched.value : this.lastFetched,
  );
  FeedSubscription copyWithCompanion(FeedSubscriptionsCompanion data) {
    return FeedSubscription(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      url: data.url.present ? data.url.value : this.url,
      title: data.title.present ? data.title.value : this.title,
      folder: data.folder.present ? data.folder.value : this.folder,
      refreshIntervalMinutes: data.refreshIntervalMinutes.present
          ? data.refreshIntervalMinutes.value
          : this.refreshIntervalMinutes,
      lastFetched: data.lastFetched.present
          ? data.lastFetched.value
          : this.lastFetched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedSubscription(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('folder: $folder, ')
          ..write('refreshIntervalMinutes: $refreshIntervalMinutes, ')
          ..write('lastFetched: $lastFetched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    url,
    title,
    folder,
    refreshIntervalMinutes,
    lastFetched,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedSubscription &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.url == this.url &&
          other.title == this.title &&
          other.folder == this.folder &&
          other.refreshIntervalMinutes == this.refreshIntervalMinutes &&
          other.lastFetched == this.lastFetched);
}

class FeedSubscriptionsCompanion extends UpdateCompanion<FeedSubscription> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> url;
  final Value<String> title;
  final Value<String?> folder;
  final Value<int> refreshIntervalMinutes;
  final Value<DateTime?> lastFetched;
  const FeedSubscriptionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.url = const Value.absent(),
    this.title = const Value.absent(),
    this.folder = const Value.absent(),
    this.refreshIntervalMinutes = const Value.absent(),
    this.lastFetched = const Value.absent(),
  });
  FeedSubscriptionsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String url,
    required String title,
    this.folder = const Value.absent(),
    this.refreshIntervalMinutes = const Value.absent(),
    this.lastFetched = const Value.absent(),
  }) : accountId = Value(accountId),
       url = Value(url),
       title = Value(title);
  static Insertable<FeedSubscription> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? url,
    Expression<String>? title,
    Expression<String>? folder,
    Expression<int>? refreshIntervalMinutes,
    Expression<DateTime>? lastFetched,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (url != null) 'url': url,
      if (title != null) 'title': title,
      if (folder != null) 'folder': folder,
      if (refreshIntervalMinutes != null)
        'refresh_interval_minutes': refreshIntervalMinutes,
      if (lastFetched != null) 'last_fetched': lastFetched,
    });
  }

  FeedSubscriptionsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<String>? url,
    Value<String>? title,
    Value<String?>? folder,
    Value<int>? refreshIntervalMinutes,
    Value<DateTime?>? lastFetched,
  }) {
    return FeedSubscriptionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      url: url ?? this.url,
      title: title ?? this.title,
      folder: folder ?? this.folder,
      refreshIntervalMinutes:
          refreshIntervalMinutes ?? this.refreshIntervalMinutes,
      lastFetched: lastFetched ?? this.lastFetched,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (folder.present) {
      map['folder'] = Variable<String>(folder.value);
    }
    if (refreshIntervalMinutes.present) {
      map['refresh_interval_minutes'] = Variable<int>(
        refreshIntervalMinutes.value,
      );
    }
    if (lastFetched.present) {
      map['last_fetched'] = Variable<DateTime>(lastFetched.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedSubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('folder: $folder, ')
          ..write('refreshIntervalMinutes: $refreshIntervalMinutes, ')
          ..write('lastFetched: $lastFetched')
          ..write(')'))
        .toString();
  }
}

class $FeedItemsTable extends FeedItems
    with TableInfo<$FeedItemsTable, FeedItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _feedIdMeta = const VerificationMeta('feedId');
  @override
  late final GeneratedColumn<int> feedId = GeneratedColumn<int>(
    'feed_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES feed_subscriptions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
    'guid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linkMeta = const VerificationMeta('link');
  @override
  late final GeneratedColumn<String> link = GeneratedColumn<String>(
    'link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readMeta = const VerificationMeta('read');
  @override
  late final GeneratedColumn<bool> read = GeneratedColumn<bool>(
    'read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _starredMeta = const VerificationMeta(
    'starred',
  );
  @override
  late final GeneratedColumn<bool> starred = GeneratedColumn<bool>(
    'starred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("starred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    feedId,
    guid,
    title,
    link,
    author,
    content,
    publishedAt,
    read,
    starred,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feed_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeedItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('feed_id')) {
      context.handle(
        _feedIdMeta,
        feedId.isAcceptableOrUnknown(data['feed_id']!, _feedIdMeta),
      );
    } else if (isInserting) {
      context.missing(_feedIdMeta);
    }
    if (data.containsKey('guid')) {
      context.handle(
        _guidMeta,
        guid.isAcceptableOrUnknown(data['guid']!, _guidMeta),
      );
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('link')) {
      context.handle(
        _linkMeta,
        link.isAcceptableOrUnknown(data['link']!, _linkMeta),
      );
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('read')) {
      context.handle(
        _readMeta,
        read.isAcceptableOrUnknown(data['read']!, _readMeta),
      );
    }
    if (data.containsKey('starred')) {
      context.handle(
        _starredMeta,
        starred.isAcceptableOrUnknown(data['starred']!, _starredMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {feedId, guid},
  ];
  @override
  FeedItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      feedId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}feed_id'],
      )!,
      guid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guid'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      link: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link'],
      ),
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
      read: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}read'],
      )!,
      starred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}starred'],
      )!,
    );
  }

  @override
  $FeedItemsTable createAlias(String alias) {
    return $FeedItemsTable(attachedDatabase, alias);
  }
}

class FeedItem extends DataClass implements Insertable<FeedItem> {
  final int id;
  final int feedId;
  final String guid;
  final String title;
  final String? link;
  final String? author;
  final String? content;
  final DateTime? publishedAt;
  final bool read;
  final bool starred;
  const FeedItem({
    required this.id,
    required this.feedId,
    required this.guid,
    required this.title,
    this.link,
    this.author,
    this.content,
    this.publishedAt,
    required this.read,
    required this.starred,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['feed_id'] = Variable<int>(feedId);
    map['guid'] = Variable<String>(guid);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || link != null) {
      map['link'] = Variable<String>(link);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    map['read'] = Variable<bool>(read);
    map['starred'] = Variable<bool>(starred);
    return map;
  }

  FeedItemsCompanion toCompanion(bool nullToAbsent) {
    return FeedItemsCompanion(
      id: Value(id),
      feedId: Value(feedId),
      guid: Value(guid),
      title: Value(title),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      read: Value(read),
      starred: Value(starred),
    );
  }

  factory FeedItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedItem(
      id: serializer.fromJson<int>(json['id']),
      feedId: serializer.fromJson<int>(json['feedId']),
      guid: serializer.fromJson<String>(json['guid']),
      title: serializer.fromJson<String>(json['title']),
      link: serializer.fromJson<String?>(json['link']),
      author: serializer.fromJson<String?>(json['author']),
      content: serializer.fromJson<String?>(json['content']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      read: serializer.fromJson<bool>(json['read']),
      starred: serializer.fromJson<bool>(json['starred']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feedId': serializer.toJson<int>(feedId),
      'guid': serializer.toJson<String>(guid),
      'title': serializer.toJson<String>(title),
      'link': serializer.toJson<String?>(link),
      'author': serializer.toJson<String?>(author),
      'content': serializer.toJson<String?>(content),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'read': serializer.toJson<bool>(read),
      'starred': serializer.toJson<bool>(starred),
    };
  }

  FeedItem copyWith({
    int? id,
    int? feedId,
    String? guid,
    String? title,
    Value<String?> link = const Value.absent(),
    Value<String?> author = const Value.absent(),
    Value<String?> content = const Value.absent(),
    Value<DateTime?> publishedAt = const Value.absent(),
    bool? read,
    bool? starred,
  }) => FeedItem(
    id: id ?? this.id,
    feedId: feedId ?? this.feedId,
    guid: guid ?? this.guid,
    title: title ?? this.title,
    link: link.present ? link.value : this.link,
    author: author.present ? author.value : this.author,
    content: content.present ? content.value : this.content,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    read: read ?? this.read,
    starred: starred ?? this.starred,
  );
  FeedItem copyWithCompanion(FeedItemsCompanion data) {
    return FeedItem(
      id: data.id.present ? data.id.value : this.id,
      feedId: data.feedId.present ? data.feedId.value : this.feedId,
      guid: data.guid.present ? data.guid.value : this.guid,
      title: data.title.present ? data.title.value : this.title,
      link: data.link.present ? data.link.value : this.link,
      author: data.author.present ? data.author.value : this.author,
      content: data.content.present ? data.content.value : this.content,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      read: data.read.present ? data.read.value : this.read,
      starred: data.starred.present ? data.starred.value : this.starred,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedItem(')
          ..write('id: $id, ')
          ..write('feedId: $feedId, ')
          ..write('guid: $guid, ')
          ..write('title: $title, ')
          ..write('link: $link, ')
          ..write('author: $author, ')
          ..write('content: $content, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('read: $read, ')
          ..write('starred: $starred')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    feedId,
    guid,
    title,
    link,
    author,
    content,
    publishedAt,
    read,
    starred,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedItem &&
          other.id == this.id &&
          other.feedId == this.feedId &&
          other.guid == this.guid &&
          other.title == this.title &&
          other.link == this.link &&
          other.author == this.author &&
          other.content == this.content &&
          other.publishedAt == this.publishedAt &&
          other.read == this.read &&
          other.starred == this.starred);
}

class FeedItemsCompanion extends UpdateCompanion<FeedItem> {
  final Value<int> id;
  final Value<int> feedId;
  final Value<String> guid;
  final Value<String> title;
  final Value<String?> link;
  final Value<String?> author;
  final Value<String?> content;
  final Value<DateTime?> publishedAt;
  final Value<bool> read;
  final Value<bool> starred;
  const FeedItemsCompanion({
    this.id = const Value.absent(),
    this.feedId = const Value.absent(),
    this.guid = const Value.absent(),
    this.title = const Value.absent(),
    this.link = const Value.absent(),
    this.author = const Value.absent(),
    this.content = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.read = const Value.absent(),
    this.starred = const Value.absent(),
  });
  FeedItemsCompanion.insert({
    this.id = const Value.absent(),
    required int feedId,
    required String guid,
    required String title,
    this.link = const Value.absent(),
    this.author = const Value.absent(),
    this.content = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.read = const Value.absent(),
    this.starred = const Value.absent(),
  }) : feedId = Value(feedId),
       guid = Value(guid),
       title = Value(title);
  static Insertable<FeedItem> custom({
    Expression<int>? id,
    Expression<int>? feedId,
    Expression<String>? guid,
    Expression<String>? title,
    Expression<String>? link,
    Expression<String>? author,
    Expression<String>? content,
    Expression<DateTime>? publishedAt,
    Expression<bool>? read,
    Expression<bool>? starred,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feedId != null) 'feed_id': feedId,
      if (guid != null) 'guid': guid,
      if (title != null) 'title': title,
      if (link != null) 'link': link,
      if (author != null) 'author': author,
      if (content != null) 'content': content,
      if (publishedAt != null) 'published_at': publishedAt,
      if (read != null) 'read': read,
      if (starred != null) 'starred': starred,
    });
  }

  FeedItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? feedId,
    Value<String>? guid,
    Value<String>? title,
    Value<String?>? link,
    Value<String?>? author,
    Value<String?>? content,
    Value<DateTime?>? publishedAt,
    Value<bool>? read,
    Value<bool>? starred,
  }) {
    return FeedItemsCompanion(
      id: id ?? this.id,
      feedId: feedId ?? this.feedId,
      guid: guid ?? this.guid,
      title: title ?? this.title,
      link: link ?? this.link,
      author: author ?? this.author,
      content: content ?? this.content,
      publishedAt: publishedAt ?? this.publishedAt,
      read: read ?? this.read,
      starred: starred ?? this.starred,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (feedId.present) {
      map['feed_id'] = Variable<int>(feedId.value);
    }
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (read.present) {
      map['read'] = Variable<bool>(read.value);
    }
    if (starred.present) {
      map['starred'] = Variable<bool>(starred.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedItemsCompanion(')
          ..write('id: $id, ')
          ..write('feedId: $feedId, ')
          ..write('guid: $guid, ')
          ..write('title: $title, ')
          ..write('link: $link, ')
          ..write('author: $author, ')
          ..write('content: $content, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('read: $read, ')
          ..write('starred: $starred')
          ..write(')'))
        .toString();
  }
}

class $MailFoldersTable extends MailFolders
    with TableInfo<$MailFoldersTable, MailFolder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MailFoldersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specialUseMeta = const VerificationMeta(
    'specialUse',
  );
  @override
  late final GeneratedColumn<String> specialUse = GeneratedColumn<String>(
    'special_use',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _delimiterMeta = const VerificationMeta(
    'delimiter',
  );
  @override
  late final GeneratedColumn<String> delimiter = GeneratedColumn<String>(
    'delimiter',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uidValidityMeta = const VerificationMeta(
    'uidValidity',
  );
  @override
  late final GeneratedColumn<int> uidValidity = GeneratedColumn<int>(
    'uid_validity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uidNextMeta = const VerificationMeta(
    'uidNext',
  );
  @override
  late final GeneratedColumn<int> uidNext = GeneratedColumn<int>(
    'uid_next',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _highestModseqMeta = const VerificationMeta(
    'highestModseq',
  );
  @override
  late final GeneratedColumn<int> highestModseq = GeneratedColumn<int>(
    'highest_modseq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    name,
    specialUse,
    delimiter,
    uidValidity,
    uidNext,
    highestModseq,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mail_folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<MailFolder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('special_use')) {
      context.handle(
        _specialUseMeta,
        specialUse.isAcceptableOrUnknown(data['special_use']!, _specialUseMeta),
      );
    }
    if (data.containsKey('delimiter')) {
      context.handle(
        _delimiterMeta,
        delimiter.isAcceptableOrUnknown(data['delimiter']!, _delimiterMeta),
      );
    }
    if (data.containsKey('uid_validity')) {
      context.handle(
        _uidValidityMeta,
        uidValidity.isAcceptableOrUnknown(
          data['uid_validity']!,
          _uidValidityMeta,
        ),
      );
    }
    if (data.containsKey('uid_next')) {
      context.handle(
        _uidNextMeta,
        uidNext.isAcceptableOrUnknown(data['uid_next']!, _uidNextMeta),
      );
    }
    if (data.containsKey('highest_modseq')) {
      context.handle(
        _highestModseqMeta,
        highestModseq.isAcceptableOrUnknown(
          data['highest_modseq']!,
          _highestModseqMeta,
        ),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {accountId, name},
  ];
  @override
  MailFolder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MailFolder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      specialUse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}special_use'],
      ),
      delimiter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delimiter'],
      ),
      uidValidity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uid_validity'],
      ),
      uidNext: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uid_next'],
      ),
      highestModseq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}highest_modseq'],
      ),
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $MailFoldersTable createAlias(String alias) {
    return $MailFoldersTable(attachedDatabase, alias);
  }
}

class MailFolder extends DataClass implements Insertable<MailFolder> {
  final int id;
  final int accountId;
  final String name;
  final String? specialUse;
  final String? delimiter;
  final int? uidValidity;
  final int? uidNext;
  final int? highestModseq;
  final DateTime? lastSyncedAt;
  const MailFolder({
    required this.id,
    required this.accountId,
    required this.name,
    this.specialUse,
    this.delimiter,
    this.uidValidity,
    this.uidNext,
    this.highestModseq,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || specialUse != null) {
      map['special_use'] = Variable<String>(specialUse);
    }
    if (!nullToAbsent || delimiter != null) {
      map['delimiter'] = Variable<String>(delimiter);
    }
    if (!nullToAbsent || uidValidity != null) {
      map['uid_validity'] = Variable<int>(uidValidity);
    }
    if (!nullToAbsent || uidNext != null) {
      map['uid_next'] = Variable<int>(uidNext);
    }
    if (!nullToAbsent || highestModseq != null) {
      map['highest_modseq'] = Variable<int>(highestModseq);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  MailFoldersCompanion toCompanion(bool nullToAbsent) {
    return MailFoldersCompanion(
      id: Value(id),
      accountId: Value(accountId),
      name: Value(name),
      specialUse: specialUse == null && nullToAbsent
          ? const Value.absent()
          : Value(specialUse),
      delimiter: delimiter == null && nullToAbsent
          ? const Value.absent()
          : Value(delimiter),
      uidValidity: uidValidity == null && nullToAbsent
          ? const Value.absent()
          : Value(uidValidity),
      uidNext: uidNext == null && nullToAbsent
          ? const Value.absent()
          : Value(uidNext),
      highestModseq: highestModseq == null && nullToAbsent
          ? const Value.absent()
          : Value(highestModseq),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory MailFolder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MailFolder(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      name: serializer.fromJson<String>(json['name']),
      specialUse: serializer.fromJson<String?>(json['specialUse']),
      delimiter: serializer.fromJson<String?>(json['delimiter']),
      uidValidity: serializer.fromJson<int?>(json['uidValidity']),
      uidNext: serializer.fromJson<int?>(json['uidNext']),
      highestModseq: serializer.fromJson<int?>(json['highestModseq']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'name': serializer.toJson<String>(name),
      'specialUse': serializer.toJson<String?>(specialUse),
      'delimiter': serializer.toJson<String?>(delimiter),
      'uidValidity': serializer.toJson<int?>(uidValidity),
      'uidNext': serializer.toJson<int?>(uidNext),
      'highestModseq': serializer.toJson<int?>(highestModseq),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  MailFolder copyWith({
    int? id,
    int? accountId,
    String? name,
    Value<String?> specialUse = const Value.absent(),
    Value<String?> delimiter = const Value.absent(),
    Value<int?> uidValidity = const Value.absent(),
    Value<int?> uidNext = const Value.absent(),
    Value<int?> highestModseq = const Value.absent(),
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => MailFolder(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    name: name ?? this.name,
    specialUse: specialUse.present ? specialUse.value : this.specialUse,
    delimiter: delimiter.present ? delimiter.value : this.delimiter,
    uidValidity: uidValidity.present ? uidValidity.value : this.uidValidity,
    uidNext: uidNext.present ? uidNext.value : this.uidNext,
    highestModseq: highestModseq.present
        ? highestModseq.value
        : this.highestModseq,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  MailFolder copyWithCompanion(MailFoldersCompanion data) {
    return MailFolder(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      specialUse: data.specialUse.present
          ? data.specialUse.value
          : this.specialUse,
      delimiter: data.delimiter.present ? data.delimiter.value : this.delimiter,
      uidValidity: data.uidValidity.present
          ? data.uidValidity.value
          : this.uidValidity,
      uidNext: data.uidNext.present ? data.uidNext.value : this.uidNext,
      highestModseq: data.highestModseq.present
          ? data.highestModseq.value
          : this.highestModseq,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MailFolder(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('specialUse: $specialUse, ')
          ..write('delimiter: $delimiter, ')
          ..write('uidValidity: $uidValidity, ')
          ..write('uidNext: $uidNext, ')
          ..write('highestModseq: $highestModseq, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    name,
    specialUse,
    delimiter,
    uidValidity,
    uidNext,
    highestModseq,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MailFolder &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.specialUse == this.specialUse &&
          other.delimiter == this.delimiter &&
          other.uidValidity == this.uidValidity &&
          other.uidNext == this.uidNext &&
          other.highestModseq == this.highestModseq &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class MailFoldersCompanion extends UpdateCompanion<MailFolder> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> name;
  final Value<String?> specialUse;
  final Value<String?> delimiter;
  final Value<int?> uidValidity;
  final Value<int?> uidNext;
  final Value<int?> highestModseq;
  final Value<DateTime?> lastSyncedAt;
  const MailFoldersCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.specialUse = const Value.absent(),
    this.delimiter = const Value.absent(),
    this.uidValidity = const Value.absent(),
    this.uidNext = const Value.absent(),
    this.highestModseq = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  MailFoldersCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String name,
    this.specialUse = const Value.absent(),
    this.delimiter = const Value.absent(),
    this.uidValidity = const Value.absent(),
    this.uidNext = const Value.absent(),
    this.highestModseq = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  }) : accountId = Value(accountId),
       name = Value(name);
  static Insertable<MailFolder> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? name,
    Expression<String>? specialUse,
    Expression<String>? delimiter,
    Expression<int>? uidValidity,
    Expression<int>? uidNext,
    Expression<int>? highestModseq,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (specialUse != null) 'special_use': specialUse,
      if (delimiter != null) 'delimiter': delimiter,
      if (uidValidity != null) 'uid_validity': uidValidity,
      if (uidNext != null) 'uid_next': uidNext,
      if (highestModseq != null) 'highest_modseq': highestModseq,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  MailFoldersCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<String>? name,
    Value<String?>? specialUse,
    Value<String?>? delimiter,
    Value<int?>? uidValidity,
    Value<int?>? uidNext,
    Value<int?>? highestModseq,
    Value<DateTime?>? lastSyncedAt,
  }) {
    return MailFoldersCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      specialUse: specialUse ?? this.specialUse,
      delimiter: delimiter ?? this.delimiter,
      uidValidity: uidValidity ?? this.uidValidity,
      uidNext: uidNext ?? this.uidNext,
      highestModseq: highestModseq ?? this.highestModseq,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (specialUse.present) {
      map['special_use'] = Variable<String>(specialUse.value);
    }
    if (delimiter.present) {
      map['delimiter'] = Variable<String>(delimiter.value);
    }
    if (uidValidity.present) {
      map['uid_validity'] = Variable<int>(uidValidity.value);
    }
    if (uidNext.present) {
      map['uid_next'] = Variable<int>(uidNext.value);
    }
    if (highestModseq.present) {
      map['highest_modseq'] = Variable<int>(highestModseq.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MailFoldersCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('specialUse: $specialUse, ')
          ..write('delimiter: $delimiter, ')
          ..write('uidValidity: $uidValidity, ')
          ..write('uidNext: $uidNext, ')
          ..write('highestModseq: $highestModseq, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $MailMessagesTable extends MailMessages
    with TableInfo<$MailMessagesTable, MailMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MailMessagesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<int> folderId = GeneratedColumn<int>(
    'folder_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mail_folders (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<int> uid = GeneratedColumn<int>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageIdHeaderMeta = const VerificationMeta(
    'messageIdHeader',
  );
  @override
  late final GeneratedColumn<String> messageIdHeader = GeneratedColumn<String>(
    'message_id_header',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inReplyToMeta = const VerificationMeta(
    'inReplyTo',
  );
  @override
  late final GeneratedColumn<String> inReplyTo = GeneratedColumn<String>(
    'in_reply_to',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referencesHeaderMeta = const VerificationMeta(
    'referencesHeader',
  );
  @override
  late final GeneratedColumn<String> referencesHeader = GeneratedColumn<String>(
    'references_header',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromAddressMeta = const VerificationMeta(
    'fromAddress',
  );
  @override
  late final GeneratedColumn<String> fromAddress = GeneratedColumn<String>(
    'from_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toAddressesMeta = const VerificationMeta(
    'toAddresses',
  );
  @override
  late final GeneratedColumn<String> toAddresses = GeneratedColumn<String>(
    'to_addresses',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ccAddressesMeta = const VerificationMeta(
    'ccAddresses',
  );
  @override
  late final GeneratedColumn<String> ccAddresses = GeneratedColumn<String>(
    'cc_addresses',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bccAddressesMeta = const VerificationMeta(
    'bccAddresses',
  );
  @override
  late final GeneratedColumn<String> bccAddresses = GeneratedColumn<String>(
    'bcc_addresses',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seenMeta = const VerificationMeta('seen');
  @override
  late final GeneratedColumn<bool> seen = GeneratedColumn<bool>(
    'seen',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("seen" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _flaggedMeta = const VerificationMeta(
    'flagged',
  );
  @override
  late final GeneratedColumn<bool> flagged = GeneratedColumn<bool>(
    'flagged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("flagged" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _answeredMeta = const VerificationMeta(
    'answered',
  );
  @override
  late final GeneratedColumn<bool> answered = GeneratedColumn<bool>(
    'answered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("answered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasAttachmentsMeta = const VerificationMeta(
    'hasAttachments',
  );
  @override
  late final GeneratedColumn<bool> hasAttachments = GeneratedColumn<bool>(
    'has_attachments',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_attachments" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _bodyDownloadedMeta = const VerificationMeta(
    'bodyDownloaded',
  );
  @override
  late final GeneratedColumn<bool> bodyDownloaded = GeneratedColumn<bool>(
    'body_downloaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("body_downloaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _remoteContentAllowedMeta =
      const VerificationMeta('remoteContentAllowed');
  @override
  late final GeneratedColumn<bool> remoteContentAllowed = GeneratedColumn<bool>(
    'remote_content_allowed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("remote_content_allowed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _snippetMeta = const VerificationMeta(
    'snippet',
  );
  @override
  late final GeneratedColumn<String> snippet = GeneratedColumn<String>(
    'snippet',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyTextMeta = const VerificationMeta(
    'bodyText',
  );
  @override
  late final GeneratedColumn<String> bodyText = GeneratedColumn<String>(
    'body_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyHtmlMeta = const VerificationMeta(
    'bodyHtml',
  );
  @override
  late final GeneratedColumn<String> bodyHtml = GeneratedColumn<String>(
    'body_html',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trashedMeta = const VerificationMeta(
    'trashed',
  );
  @override
  late final GeneratedColumn<bool> trashed = GeneratedColumn<bool>(
    'trashed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("trashed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _trashedAtMeta = const VerificationMeta(
    'trashedAt',
  );
  @override
  late final GeneratedColumn<DateTime> trashedAt = GeneratedColumn<DateTime>(
    'trashed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folderId,
    uid,
    messageIdHeader,
    inReplyTo,
    referencesHeader,
    subject,
    fromAddress,
    toAddresses,
    ccAddresses,
    bccAddresses,
    sentAt,
    seen,
    flagged,
    answered,
    hasAttachments,
    bodyDownloaded,
    remoteContentAllowed,
    snippet,
    bodyText,
    bodyHtml,
    trashed,
    trashedAt,
    receivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mail_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<MailMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('message_id_header')) {
      context.handle(
        _messageIdHeaderMeta,
        messageIdHeader.isAcceptableOrUnknown(
          data['message_id_header']!,
          _messageIdHeaderMeta,
        ),
      );
    }
    if (data.containsKey('in_reply_to')) {
      context.handle(
        _inReplyToMeta,
        inReplyTo.isAcceptableOrUnknown(data['in_reply_to']!, _inReplyToMeta),
      );
    }
    if (data.containsKey('references_header')) {
      context.handle(
        _referencesHeaderMeta,
        referencesHeader.isAcceptableOrUnknown(
          data['references_header']!,
          _referencesHeaderMeta,
        ),
      );
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    }
    if (data.containsKey('from_address')) {
      context.handle(
        _fromAddressMeta,
        fromAddress.isAcceptableOrUnknown(
          data['from_address']!,
          _fromAddressMeta,
        ),
      );
    }
    if (data.containsKey('to_addresses')) {
      context.handle(
        _toAddressesMeta,
        toAddresses.isAcceptableOrUnknown(
          data['to_addresses']!,
          _toAddressesMeta,
        ),
      );
    }
    if (data.containsKey('cc_addresses')) {
      context.handle(
        _ccAddressesMeta,
        ccAddresses.isAcceptableOrUnknown(
          data['cc_addresses']!,
          _ccAddressesMeta,
        ),
      );
    }
    if (data.containsKey('bcc_addresses')) {
      context.handle(
        _bccAddressesMeta,
        bccAddresses.isAcceptableOrUnknown(
          data['bcc_addresses']!,
          _bccAddressesMeta,
        ),
      );
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    }
    if (data.containsKey('seen')) {
      context.handle(
        _seenMeta,
        seen.isAcceptableOrUnknown(data['seen']!, _seenMeta),
      );
    }
    if (data.containsKey('flagged')) {
      context.handle(
        _flaggedMeta,
        flagged.isAcceptableOrUnknown(data['flagged']!, _flaggedMeta),
      );
    }
    if (data.containsKey('answered')) {
      context.handle(
        _answeredMeta,
        answered.isAcceptableOrUnknown(data['answered']!, _answeredMeta),
      );
    }
    if (data.containsKey('has_attachments')) {
      context.handle(
        _hasAttachmentsMeta,
        hasAttachments.isAcceptableOrUnknown(
          data['has_attachments']!,
          _hasAttachmentsMeta,
        ),
      );
    }
    if (data.containsKey('body_downloaded')) {
      context.handle(
        _bodyDownloadedMeta,
        bodyDownloaded.isAcceptableOrUnknown(
          data['body_downloaded']!,
          _bodyDownloadedMeta,
        ),
      );
    }
    if (data.containsKey('remote_content_allowed')) {
      context.handle(
        _remoteContentAllowedMeta,
        remoteContentAllowed.isAcceptableOrUnknown(
          data['remote_content_allowed']!,
          _remoteContentAllowedMeta,
        ),
      );
    }
    if (data.containsKey('snippet')) {
      context.handle(
        _snippetMeta,
        snippet.isAcceptableOrUnknown(data['snippet']!, _snippetMeta),
      );
    }
    if (data.containsKey('body_text')) {
      context.handle(
        _bodyTextMeta,
        bodyText.isAcceptableOrUnknown(data['body_text']!, _bodyTextMeta),
      );
    }
    if (data.containsKey('body_html')) {
      context.handle(
        _bodyHtmlMeta,
        bodyHtml.isAcceptableOrUnknown(data['body_html']!, _bodyHtmlMeta),
      );
    }
    if (data.containsKey('trashed')) {
      context.handle(
        _trashedMeta,
        trashed.isAcceptableOrUnknown(data['trashed']!, _trashedMeta),
      );
    }
    if (data.containsKey('trashed_at')) {
      context.handle(
        _trashedAtMeta,
        trashedAt.isAcceptableOrUnknown(data['trashed_at']!, _trashedAtMeta),
      );
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {folderId, uid},
  ];
  @override
  MailMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MailMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder_id'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uid'],
      )!,
      messageIdHeader: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id_header'],
      ),
      inReplyTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}in_reply_to'],
      ),
      referencesHeader: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}references_header'],
      ),
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      ),
      fromAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_address'],
      ),
      toAddresses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_addresses'],
      ),
      ccAddresses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cc_addresses'],
      ),
      bccAddresses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bcc_addresses'],
      ),
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      ),
      seen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}seen'],
      )!,
      flagged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}flagged'],
      )!,
      answered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}answered'],
      )!,
      hasAttachments: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_attachments'],
      )!,
      bodyDownloaded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}body_downloaded'],
      )!,
      remoteContentAllowed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}remote_content_allowed'],
      )!,
      snippet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snippet'],
      ),
      bodyText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_text'],
      ),
      bodyHtml: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_html'],
      ),
      trashed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}trashed'],
      )!,
      trashedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trashed_at'],
      ),
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
    );
  }

  @override
  $MailMessagesTable createAlias(String alias) {
    return $MailMessagesTable(attachedDatabase, alias);
  }
}

class MailMessage extends DataClass implements Insertable<MailMessage> {
  final int id;
  final int folderId;
  final int uid;
  final String? messageIdHeader;
  final String? inReplyTo;
  final String? referencesHeader;
  final String? subject;
  final String? fromAddress;
  final String? toAddresses;
  final String? ccAddresses;
  final String? bccAddresses;
  final DateTime? sentAt;
  final bool seen;
  final bool flagged;
  final bool answered;
  final bool hasAttachments;
  final bool bodyDownloaded;
  final bool remoteContentAllowed;
  final String? snippet;
  final String? bodyText;
  final String? bodyHtml;
  final bool trashed;
  final DateTime? trashedAt;
  final DateTime receivedAt;
  const MailMessage({
    required this.id,
    required this.folderId,
    required this.uid,
    this.messageIdHeader,
    this.inReplyTo,
    this.referencesHeader,
    this.subject,
    this.fromAddress,
    this.toAddresses,
    this.ccAddresses,
    this.bccAddresses,
    this.sentAt,
    required this.seen,
    required this.flagged,
    required this.answered,
    required this.hasAttachments,
    required this.bodyDownloaded,
    required this.remoteContentAllowed,
    this.snippet,
    this.bodyText,
    this.bodyHtml,
    required this.trashed,
    this.trashedAt,
    required this.receivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['folder_id'] = Variable<int>(folderId);
    map['uid'] = Variable<int>(uid);
    if (!nullToAbsent || messageIdHeader != null) {
      map['message_id_header'] = Variable<String>(messageIdHeader);
    }
    if (!nullToAbsent || inReplyTo != null) {
      map['in_reply_to'] = Variable<String>(inReplyTo);
    }
    if (!nullToAbsent || referencesHeader != null) {
      map['references_header'] = Variable<String>(referencesHeader);
    }
    if (!nullToAbsent || subject != null) {
      map['subject'] = Variable<String>(subject);
    }
    if (!nullToAbsent || fromAddress != null) {
      map['from_address'] = Variable<String>(fromAddress);
    }
    if (!nullToAbsent || toAddresses != null) {
      map['to_addresses'] = Variable<String>(toAddresses);
    }
    if (!nullToAbsent || ccAddresses != null) {
      map['cc_addresses'] = Variable<String>(ccAddresses);
    }
    if (!nullToAbsent || bccAddresses != null) {
      map['bcc_addresses'] = Variable<String>(bccAddresses);
    }
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    map['seen'] = Variable<bool>(seen);
    map['flagged'] = Variable<bool>(flagged);
    map['answered'] = Variable<bool>(answered);
    map['has_attachments'] = Variable<bool>(hasAttachments);
    map['body_downloaded'] = Variable<bool>(bodyDownloaded);
    map['remote_content_allowed'] = Variable<bool>(remoteContentAllowed);
    if (!nullToAbsent || snippet != null) {
      map['snippet'] = Variable<String>(snippet);
    }
    if (!nullToAbsent || bodyText != null) {
      map['body_text'] = Variable<String>(bodyText);
    }
    if (!nullToAbsent || bodyHtml != null) {
      map['body_html'] = Variable<String>(bodyHtml);
    }
    map['trashed'] = Variable<bool>(trashed);
    if (!nullToAbsent || trashedAt != null) {
      map['trashed_at'] = Variable<DateTime>(trashedAt);
    }
    map['received_at'] = Variable<DateTime>(receivedAt);
    return map;
  }

  MailMessagesCompanion toCompanion(bool nullToAbsent) {
    return MailMessagesCompanion(
      id: Value(id),
      folderId: Value(folderId),
      uid: Value(uid),
      messageIdHeader: messageIdHeader == null && nullToAbsent
          ? const Value.absent()
          : Value(messageIdHeader),
      inReplyTo: inReplyTo == null && nullToAbsent
          ? const Value.absent()
          : Value(inReplyTo),
      referencesHeader: referencesHeader == null && nullToAbsent
          ? const Value.absent()
          : Value(referencesHeader),
      subject: subject == null && nullToAbsent
          ? const Value.absent()
          : Value(subject),
      fromAddress: fromAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(fromAddress),
      toAddresses: toAddresses == null && nullToAbsent
          ? const Value.absent()
          : Value(toAddresses),
      ccAddresses: ccAddresses == null && nullToAbsent
          ? const Value.absent()
          : Value(ccAddresses),
      bccAddresses: bccAddresses == null && nullToAbsent
          ? const Value.absent()
          : Value(bccAddresses),
      sentAt: sentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(sentAt),
      seen: Value(seen),
      flagged: Value(flagged),
      answered: Value(answered),
      hasAttachments: Value(hasAttachments),
      bodyDownloaded: Value(bodyDownloaded),
      remoteContentAllowed: Value(remoteContentAllowed),
      snippet: snippet == null && nullToAbsent
          ? const Value.absent()
          : Value(snippet),
      bodyText: bodyText == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyText),
      bodyHtml: bodyHtml == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyHtml),
      trashed: Value(trashed),
      trashedAt: trashedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(trashedAt),
      receivedAt: Value(receivedAt),
    );
  }

  factory MailMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MailMessage(
      id: serializer.fromJson<int>(json['id']),
      folderId: serializer.fromJson<int>(json['folderId']),
      uid: serializer.fromJson<int>(json['uid']),
      messageIdHeader: serializer.fromJson<String?>(json['messageIdHeader']),
      inReplyTo: serializer.fromJson<String?>(json['inReplyTo']),
      referencesHeader: serializer.fromJson<String?>(json['referencesHeader']),
      subject: serializer.fromJson<String?>(json['subject']),
      fromAddress: serializer.fromJson<String?>(json['fromAddress']),
      toAddresses: serializer.fromJson<String?>(json['toAddresses']),
      ccAddresses: serializer.fromJson<String?>(json['ccAddresses']),
      bccAddresses: serializer.fromJson<String?>(json['bccAddresses']),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
      seen: serializer.fromJson<bool>(json['seen']),
      flagged: serializer.fromJson<bool>(json['flagged']),
      answered: serializer.fromJson<bool>(json['answered']),
      hasAttachments: serializer.fromJson<bool>(json['hasAttachments']),
      bodyDownloaded: serializer.fromJson<bool>(json['bodyDownloaded']),
      remoteContentAllowed: serializer.fromJson<bool>(
        json['remoteContentAllowed'],
      ),
      snippet: serializer.fromJson<String?>(json['snippet']),
      bodyText: serializer.fromJson<String?>(json['bodyText']),
      bodyHtml: serializer.fromJson<String?>(json['bodyHtml']),
      trashed: serializer.fromJson<bool>(json['trashed']),
      trashedAt: serializer.fromJson<DateTime?>(json['trashedAt']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'folderId': serializer.toJson<int>(folderId),
      'uid': serializer.toJson<int>(uid),
      'messageIdHeader': serializer.toJson<String?>(messageIdHeader),
      'inReplyTo': serializer.toJson<String?>(inReplyTo),
      'referencesHeader': serializer.toJson<String?>(referencesHeader),
      'subject': serializer.toJson<String?>(subject),
      'fromAddress': serializer.toJson<String?>(fromAddress),
      'toAddresses': serializer.toJson<String?>(toAddresses),
      'ccAddresses': serializer.toJson<String?>(ccAddresses),
      'bccAddresses': serializer.toJson<String?>(bccAddresses),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
      'seen': serializer.toJson<bool>(seen),
      'flagged': serializer.toJson<bool>(flagged),
      'answered': serializer.toJson<bool>(answered),
      'hasAttachments': serializer.toJson<bool>(hasAttachments),
      'bodyDownloaded': serializer.toJson<bool>(bodyDownloaded),
      'remoteContentAllowed': serializer.toJson<bool>(remoteContentAllowed),
      'snippet': serializer.toJson<String?>(snippet),
      'bodyText': serializer.toJson<String?>(bodyText),
      'bodyHtml': serializer.toJson<String?>(bodyHtml),
      'trashed': serializer.toJson<bool>(trashed),
      'trashedAt': serializer.toJson<DateTime?>(trashedAt),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
    };
  }

  MailMessage copyWith({
    int? id,
    int? folderId,
    int? uid,
    Value<String?> messageIdHeader = const Value.absent(),
    Value<String?> inReplyTo = const Value.absent(),
    Value<String?> referencesHeader = const Value.absent(),
    Value<String?> subject = const Value.absent(),
    Value<String?> fromAddress = const Value.absent(),
    Value<String?> toAddresses = const Value.absent(),
    Value<String?> ccAddresses = const Value.absent(),
    Value<String?> bccAddresses = const Value.absent(),
    Value<DateTime?> sentAt = const Value.absent(),
    bool? seen,
    bool? flagged,
    bool? answered,
    bool? hasAttachments,
    bool? bodyDownloaded,
    bool? remoteContentAllowed,
    Value<String?> snippet = const Value.absent(),
    Value<String?> bodyText = const Value.absent(),
    Value<String?> bodyHtml = const Value.absent(),
    bool? trashed,
    Value<DateTime?> trashedAt = const Value.absent(),
    DateTime? receivedAt,
  }) => MailMessage(
    id: id ?? this.id,
    folderId: folderId ?? this.folderId,
    uid: uid ?? this.uid,
    messageIdHeader: messageIdHeader.present
        ? messageIdHeader.value
        : this.messageIdHeader,
    inReplyTo: inReplyTo.present ? inReplyTo.value : this.inReplyTo,
    referencesHeader: referencesHeader.present
        ? referencesHeader.value
        : this.referencesHeader,
    subject: subject.present ? subject.value : this.subject,
    fromAddress: fromAddress.present ? fromAddress.value : this.fromAddress,
    toAddresses: toAddresses.present ? toAddresses.value : this.toAddresses,
    ccAddresses: ccAddresses.present ? ccAddresses.value : this.ccAddresses,
    bccAddresses: bccAddresses.present ? bccAddresses.value : this.bccAddresses,
    sentAt: sentAt.present ? sentAt.value : this.sentAt,
    seen: seen ?? this.seen,
    flagged: flagged ?? this.flagged,
    answered: answered ?? this.answered,
    hasAttachments: hasAttachments ?? this.hasAttachments,
    bodyDownloaded: bodyDownloaded ?? this.bodyDownloaded,
    remoteContentAllowed: remoteContentAllowed ?? this.remoteContentAllowed,
    snippet: snippet.present ? snippet.value : this.snippet,
    bodyText: bodyText.present ? bodyText.value : this.bodyText,
    bodyHtml: bodyHtml.present ? bodyHtml.value : this.bodyHtml,
    trashed: trashed ?? this.trashed,
    trashedAt: trashedAt.present ? trashedAt.value : this.trashedAt,
    receivedAt: receivedAt ?? this.receivedAt,
  );
  MailMessage copyWithCompanion(MailMessagesCompanion data) {
    return MailMessage(
      id: data.id.present ? data.id.value : this.id,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      uid: data.uid.present ? data.uid.value : this.uid,
      messageIdHeader: data.messageIdHeader.present
          ? data.messageIdHeader.value
          : this.messageIdHeader,
      inReplyTo: data.inReplyTo.present ? data.inReplyTo.value : this.inReplyTo,
      referencesHeader: data.referencesHeader.present
          ? data.referencesHeader.value
          : this.referencesHeader,
      subject: data.subject.present ? data.subject.value : this.subject,
      fromAddress: data.fromAddress.present
          ? data.fromAddress.value
          : this.fromAddress,
      toAddresses: data.toAddresses.present
          ? data.toAddresses.value
          : this.toAddresses,
      ccAddresses: data.ccAddresses.present
          ? data.ccAddresses.value
          : this.ccAddresses,
      bccAddresses: data.bccAddresses.present
          ? data.bccAddresses.value
          : this.bccAddresses,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      seen: data.seen.present ? data.seen.value : this.seen,
      flagged: data.flagged.present ? data.flagged.value : this.flagged,
      answered: data.answered.present ? data.answered.value : this.answered,
      hasAttachments: data.hasAttachments.present
          ? data.hasAttachments.value
          : this.hasAttachments,
      bodyDownloaded: data.bodyDownloaded.present
          ? data.bodyDownloaded.value
          : this.bodyDownloaded,
      remoteContentAllowed: data.remoteContentAllowed.present
          ? data.remoteContentAllowed.value
          : this.remoteContentAllowed,
      snippet: data.snippet.present ? data.snippet.value : this.snippet,
      bodyText: data.bodyText.present ? data.bodyText.value : this.bodyText,
      bodyHtml: data.bodyHtml.present ? data.bodyHtml.value : this.bodyHtml,
      trashed: data.trashed.present ? data.trashed.value : this.trashed,
      trashedAt: data.trashedAt.present ? data.trashedAt.value : this.trashedAt,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MailMessage(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('uid: $uid, ')
          ..write('messageIdHeader: $messageIdHeader, ')
          ..write('inReplyTo: $inReplyTo, ')
          ..write('referencesHeader: $referencesHeader, ')
          ..write('subject: $subject, ')
          ..write('fromAddress: $fromAddress, ')
          ..write('toAddresses: $toAddresses, ')
          ..write('ccAddresses: $ccAddresses, ')
          ..write('bccAddresses: $bccAddresses, ')
          ..write('sentAt: $sentAt, ')
          ..write('seen: $seen, ')
          ..write('flagged: $flagged, ')
          ..write('answered: $answered, ')
          ..write('hasAttachments: $hasAttachments, ')
          ..write('bodyDownloaded: $bodyDownloaded, ')
          ..write('remoteContentAllowed: $remoteContentAllowed, ')
          ..write('snippet: $snippet, ')
          ..write('bodyText: $bodyText, ')
          ..write('bodyHtml: $bodyHtml, ')
          ..write('trashed: $trashed, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    folderId,
    uid,
    messageIdHeader,
    inReplyTo,
    referencesHeader,
    subject,
    fromAddress,
    toAddresses,
    ccAddresses,
    bccAddresses,
    sentAt,
    seen,
    flagged,
    answered,
    hasAttachments,
    bodyDownloaded,
    remoteContentAllowed,
    snippet,
    bodyText,
    bodyHtml,
    trashed,
    trashedAt,
    receivedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MailMessage &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.uid == this.uid &&
          other.messageIdHeader == this.messageIdHeader &&
          other.inReplyTo == this.inReplyTo &&
          other.referencesHeader == this.referencesHeader &&
          other.subject == this.subject &&
          other.fromAddress == this.fromAddress &&
          other.toAddresses == this.toAddresses &&
          other.ccAddresses == this.ccAddresses &&
          other.bccAddresses == this.bccAddresses &&
          other.sentAt == this.sentAt &&
          other.seen == this.seen &&
          other.flagged == this.flagged &&
          other.answered == this.answered &&
          other.hasAttachments == this.hasAttachments &&
          other.bodyDownloaded == this.bodyDownloaded &&
          other.remoteContentAllowed == this.remoteContentAllowed &&
          other.snippet == this.snippet &&
          other.bodyText == this.bodyText &&
          other.bodyHtml == this.bodyHtml &&
          other.trashed == this.trashed &&
          other.trashedAt == this.trashedAt &&
          other.receivedAt == this.receivedAt);
}

class MailMessagesCompanion extends UpdateCompanion<MailMessage> {
  final Value<int> id;
  final Value<int> folderId;
  final Value<int> uid;
  final Value<String?> messageIdHeader;
  final Value<String?> inReplyTo;
  final Value<String?> referencesHeader;
  final Value<String?> subject;
  final Value<String?> fromAddress;
  final Value<String?> toAddresses;
  final Value<String?> ccAddresses;
  final Value<String?> bccAddresses;
  final Value<DateTime?> sentAt;
  final Value<bool> seen;
  final Value<bool> flagged;
  final Value<bool> answered;
  final Value<bool> hasAttachments;
  final Value<bool> bodyDownloaded;
  final Value<bool> remoteContentAllowed;
  final Value<String?> snippet;
  final Value<String?> bodyText;
  final Value<String?> bodyHtml;
  final Value<bool> trashed;
  final Value<DateTime?> trashedAt;
  final Value<DateTime> receivedAt;
  const MailMessagesCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.uid = const Value.absent(),
    this.messageIdHeader = const Value.absent(),
    this.inReplyTo = const Value.absent(),
    this.referencesHeader = const Value.absent(),
    this.subject = const Value.absent(),
    this.fromAddress = const Value.absent(),
    this.toAddresses = const Value.absent(),
    this.ccAddresses = const Value.absent(),
    this.bccAddresses = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.seen = const Value.absent(),
    this.flagged = const Value.absent(),
    this.answered = const Value.absent(),
    this.hasAttachments = const Value.absent(),
    this.bodyDownloaded = const Value.absent(),
    this.remoteContentAllowed = const Value.absent(),
    this.snippet = const Value.absent(),
    this.bodyText = const Value.absent(),
    this.bodyHtml = const Value.absent(),
    this.trashed = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.receivedAt = const Value.absent(),
  });
  MailMessagesCompanion.insert({
    this.id = const Value.absent(),
    required int folderId,
    required int uid,
    this.messageIdHeader = const Value.absent(),
    this.inReplyTo = const Value.absent(),
    this.referencesHeader = const Value.absent(),
    this.subject = const Value.absent(),
    this.fromAddress = const Value.absent(),
    this.toAddresses = const Value.absent(),
    this.ccAddresses = const Value.absent(),
    this.bccAddresses = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.seen = const Value.absent(),
    this.flagged = const Value.absent(),
    this.answered = const Value.absent(),
    this.hasAttachments = const Value.absent(),
    this.bodyDownloaded = const Value.absent(),
    this.remoteContentAllowed = const Value.absent(),
    this.snippet = const Value.absent(),
    this.bodyText = const Value.absent(),
    this.bodyHtml = const Value.absent(),
    this.trashed = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.receivedAt = const Value.absent(),
  }) : folderId = Value(folderId),
       uid = Value(uid);
  static Insertable<MailMessage> custom({
    Expression<int>? id,
    Expression<int>? folderId,
    Expression<int>? uid,
    Expression<String>? messageIdHeader,
    Expression<String>? inReplyTo,
    Expression<String>? referencesHeader,
    Expression<String>? subject,
    Expression<String>? fromAddress,
    Expression<String>? toAddresses,
    Expression<String>? ccAddresses,
    Expression<String>? bccAddresses,
    Expression<DateTime>? sentAt,
    Expression<bool>? seen,
    Expression<bool>? flagged,
    Expression<bool>? answered,
    Expression<bool>? hasAttachments,
    Expression<bool>? bodyDownloaded,
    Expression<bool>? remoteContentAllowed,
    Expression<String>? snippet,
    Expression<String>? bodyText,
    Expression<String>? bodyHtml,
    Expression<bool>? trashed,
    Expression<DateTime>? trashedAt,
    Expression<DateTime>? receivedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (uid != null) 'uid': uid,
      if (messageIdHeader != null) 'message_id_header': messageIdHeader,
      if (inReplyTo != null) 'in_reply_to': inReplyTo,
      if (referencesHeader != null) 'references_header': referencesHeader,
      if (subject != null) 'subject': subject,
      if (fromAddress != null) 'from_address': fromAddress,
      if (toAddresses != null) 'to_addresses': toAddresses,
      if (ccAddresses != null) 'cc_addresses': ccAddresses,
      if (bccAddresses != null) 'bcc_addresses': bccAddresses,
      if (sentAt != null) 'sent_at': sentAt,
      if (seen != null) 'seen': seen,
      if (flagged != null) 'flagged': flagged,
      if (answered != null) 'answered': answered,
      if (hasAttachments != null) 'has_attachments': hasAttachments,
      if (bodyDownloaded != null) 'body_downloaded': bodyDownloaded,
      if (remoteContentAllowed != null)
        'remote_content_allowed': remoteContentAllowed,
      if (snippet != null) 'snippet': snippet,
      if (bodyText != null) 'body_text': bodyText,
      if (bodyHtml != null) 'body_html': bodyHtml,
      if (trashed != null) 'trashed': trashed,
      if (trashedAt != null) 'trashed_at': trashedAt,
      if (receivedAt != null) 'received_at': receivedAt,
    });
  }

  MailMessagesCompanion copyWith({
    Value<int>? id,
    Value<int>? folderId,
    Value<int>? uid,
    Value<String?>? messageIdHeader,
    Value<String?>? inReplyTo,
    Value<String?>? referencesHeader,
    Value<String?>? subject,
    Value<String?>? fromAddress,
    Value<String?>? toAddresses,
    Value<String?>? ccAddresses,
    Value<String?>? bccAddresses,
    Value<DateTime?>? sentAt,
    Value<bool>? seen,
    Value<bool>? flagged,
    Value<bool>? answered,
    Value<bool>? hasAttachments,
    Value<bool>? bodyDownloaded,
    Value<bool>? remoteContentAllowed,
    Value<String?>? snippet,
    Value<String?>? bodyText,
    Value<String?>? bodyHtml,
    Value<bool>? trashed,
    Value<DateTime?>? trashedAt,
    Value<DateTime>? receivedAt,
  }) {
    return MailMessagesCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      uid: uid ?? this.uid,
      messageIdHeader: messageIdHeader ?? this.messageIdHeader,
      inReplyTo: inReplyTo ?? this.inReplyTo,
      referencesHeader: referencesHeader ?? this.referencesHeader,
      subject: subject ?? this.subject,
      fromAddress: fromAddress ?? this.fromAddress,
      toAddresses: toAddresses ?? this.toAddresses,
      ccAddresses: ccAddresses ?? this.ccAddresses,
      bccAddresses: bccAddresses ?? this.bccAddresses,
      sentAt: sentAt ?? this.sentAt,
      seen: seen ?? this.seen,
      flagged: flagged ?? this.flagged,
      answered: answered ?? this.answered,
      hasAttachments: hasAttachments ?? this.hasAttachments,
      bodyDownloaded: bodyDownloaded ?? this.bodyDownloaded,
      remoteContentAllowed: remoteContentAllowed ?? this.remoteContentAllowed,
      snippet: snippet ?? this.snippet,
      bodyText: bodyText ?? this.bodyText,
      bodyHtml: bodyHtml ?? this.bodyHtml,
      trashed: trashed ?? this.trashed,
      trashedAt: trashedAt ?? this.trashedAt,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<int>(folderId.value);
    }
    if (uid.present) {
      map['uid'] = Variable<int>(uid.value);
    }
    if (messageIdHeader.present) {
      map['message_id_header'] = Variable<String>(messageIdHeader.value);
    }
    if (inReplyTo.present) {
      map['in_reply_to'] = Variable<String>(inReplyTo.value);
    }
    if (referencesHeader.present) {
      map['references_header'] = Variable<String>(referencesHeader.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (fromAddress.present) {
      map['from_address'] = Variable<String>(fromAddress.value);
    }
    if (toAddresses.present) {
      map['to_addresses'] = Variable<String>(toAddresses.value);
    }
    if (ccAddresses.present) {
      map['cc_addresses'] = Variable<String>(ccAddresses.value);
    }
    if (bccAddresses.present) {
      map['bcc_addresses'] = Variable<String>(bccAddresses.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (seen.present) {
      map['seen'] = Variable<bool>(seen.value);
    }
    if (flagged.present) {
      map['flagged'] = Variable<bool>(flagged.value);
    }
    if (answered.present) {
      map['answered'] = Variable<bool>(answered.value);
    }
    if (hasAttachments.present) {
      map['has_attachments'] = Variable<bool>(hasAttachments.value);
    }
    if (bodyDownloaded.present) {
      map['body_downloaded'] = Variable<bool>(bodyDownloaded.value);
    }
    if (remoteContentAllowed.present) {
      map['remote_content_allowed'] = Variable<bool>(
        remoteContentAllowed.value,
      );
    }
    if (snippet.present) {
      map['snippet'] = Variable<String>(snippet.value);
    }
    if (bodyText.present) {
      map['body_text'] = Variable<String>(bodyText.value);
    }
    if (bodyHtml.present) {
      map['body_html'] = Variable<String>(bodyHtml.value);
    }
    if (trashed.present) {
      map['trashed'] = Variable<bool>(trashed.value);
    }
    if (trashedAt.present) {
      map['trashed_at'] = Variable<DateTime>(trashedAt.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MailMessagesCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('uid: $uid, ')
          ..write('messageIdHeader: $messageIdHeader, ')
          ..write('inReplyTo: $inReplyTo, ')
          ..write('referencesHeader: $referencesHeader, ')
          ..write('subject: $subject, ')
          ..write('fromAddress: $fromAddress, ')
          ..write('toAddresses: $toAddresses, ')
          ..write('ccAddresses: $ccAddresses, ')
          ..write('bccAddresses: $bccAddresses, ')
          ..write('sentAt: $sentAt, ')
          ..write('seen: $seen, ')
          ..write('flagged: $flagged, ')
          ..write('answered: $answered, ')
          ..write('hasAttachments: $hasAttachments, ')
          ..write('bodyDownloaded: $bodyDownloaded, ')
          ..write('remoteContentAllowed: $remoteContentAllowed, ')
          ..write('snippet: $snippet, ')
          ..write('bodyText: $bodyText, ')
          ..write('bodyHtml: $bodyHtml, ')
          ..write('trashed: $trashed, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }
}

class $MailAttachmentsTable extends MailAttachments
    with TableInfo<$MailAttachmentsTable, MailAttachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MailAttachmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<int> messageId = GeneratedColumn<int>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mail_messages (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filenameMeta = const VerificationMeta(
    'filename',
  );
  @override
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
    'filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _downloadedMeta = const VerificationMeta(
    'downloaded',
  );
  @override
  late final GeneratedColumn<bool> downloaded = GeneratedColumn<bool>(
    'downloaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("downloaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    messageId,
    filename,
    mimeType,
    sizeBytes,
    contentId,
    localPath,
    downloaded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mail_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<MailAttachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('filename')) {
      context.handle(
        _filenameMeta,
        filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta),
      );
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('downloaded')) {
      context.handle(
        _downloadedMeta,
        downloaded.isAcceptableOrUnknown(data['downloaded']!, _downloadedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MailAttachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MailAttachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}message_id'],
      )!,
      filename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filename'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      ),
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      downloaded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}downloaded'],
      )!,
    );
  }

  @override
  $MailAttachmentsTable createAlias(String alias) {
    return $MailAttachmentsTable(attachedDatabase, alias);
  }
}

class MailAttachment extends DataClass implements Insertable<MailAttachment> {
  final int id;
  final int messageId;
  final String filename;
  final String mimeType;
  final int sizeBytes;
  final String? contentId;
  final String? localPath;
  final bool downloaded;
  const MailAttachment({
    required this.id,
    required this.messageId,
    required this.filename,
    required this.mimeType,
    required this.sizeBytes,
    this.contentId,
    this.localPath,
    required this.downloaded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message_id'] = Variable<int>(messageId);
    map['filename'] = Variable<String>(filename);
    map['mime_type'] = Variable<String>(mimeType);
    map['size_bytes'] = Variable<int>(sizeBytes);
    if (!nullToAbsent || contentId != null) {
      map['content_id'] = Variable<String>(contentId);
    }
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    map['downloaded'] = Variable<bool>(downloaded);
    return map;
  }

  MailAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return MailAttachmentsCompanion(
      id: Value(id),
      messageId: Value(messageId),
      filename: Value(filename),
      mimeType: Value(mimeType),
      sizeBytes: Value(sizeBytes),
      contentId: contentId == null && nullToAbsent
          ? const Value.absent()
          : Value(contentId),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      downloaded: Value(downloaded),
    );
  }

  factory MailAttachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MailAttachment(
      id: serializer.fromJson<int>(json['id']),
      messageId: serializer.fromJson<int>(json['messageId']),
      filename: serializer.fromJson<String>(json['filename']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      contentId: serializer.fromJson<String?>(json['contentId']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      downloaded: serializer.fromJson<bool>(json['downloaded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'messageId': serializer.toJson<int>(messageId),
      'filename': serializer.toJson<String>(filename),
      'mimeType': serializer.toJson<String>(mimeType),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'contentId': serializer.toJson<String?>(contentId),
      'localPath': serializer.toJson<String?>(localPath),
      'downloaded': serializer.toJson<bool>(downloaded),
    };
  }

  MailAttachment copyWith({
    int? id,
    int? messageId,
    String? filename,
    String? mimeType,
    int? sizeBytes,
    Value<String?> contentId = const Value.absent(),
    Value<String?> localPath = const Value.absent(),
    bool? downloaded,
  }) => MailAttachment(
    id: id ?? this.id,
    messageId: messageId ?? this.messageId,
    filename: filename ?? this.filename,
    mimeType: mimeType ?? this.mimeType,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    contentId: contentId.present ? contentId.value : this.contentId,
    localPath: localPath.present ? localPath.value : this.localPath,
    downloaded: downloaded ?? this.downloaded,
  );
  MailAttachment copyWithCompanion(MailAttachmentsCompanion data) {
    return MailAttachment(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      filename: data.filename.present ? data.filename.value : this.filename,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      downloaded: data.downloaded.present
          ? data.downloaded.value
          : this.downloaded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MailAttachment(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('filename: $filename, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('contentId: $contentId, ')
          ..write('localPath: $localPath, ')
          ..write('downloaded: $downloaded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    messageId,
    filename,
    mimeType,
    sizeBytes,
    contentId,
    localPath,
    downloaded,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MailAttachment &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.filename == this.filename &&
          other.mimeType == this.mimeType &&
          other.sizeBytes == this.sizeBytes &&
          other.contentId == this.contentId &&
          other.localPath == this.localPath &&
          other.downloaded == this.downloaded);
}

class MailAttachmentsCompanion extends UpdateCompanion<MailAttachment> {
  final Value<int> id;
  final Value<int> messageId;
  final Value<String> filename;
  final Value<String> mimeType;
  final Value<int> sizeBytes;
  final Value<String?> contentId;
  final Value<String?> localPath;
  final Value<bool> downloaded;
  const MailAttachmentsCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.filename = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.contentId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.downloaded = const Value.absent(),
  });
  MailAttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required int messageId,
    required String filename,
    required String mimeType,
    required int sizeBytes,
    this.contentId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.downloaded = const Value.absent(),
  }) : messageId = Value(messageId),
       filename = Value(filename),
       mimeType = Value(mimeType),
       sizeBytes = Value(sizeBytes);
  static Insertable<MailAttachment> custom({
    Expression<int>? id,
    Expression<int>? messageId,
    Expression<String>? filename,
    Expression<String>? mimeType,
    Expression<int>? sizeBytes,
    Expression<String>? contentId,
    Expression<String>? localPath,
    Expression<bool>? downloaded,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (filename != null) 'filename': filename,
      if (mimeType != null) 'mime_type': mimeType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (contentId != null) 'content_id': contentId,
      if (localPath != null) 'local_path': localPath,
      if (downloaded != null) 'downloaded': downloaded,
    });
  }

  MailAttachmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? messageId,
    Value<String>? filename,
    Value<String>? mimeType,
    Value<int>? sizeBytes,
    Value<String?>? contentId,
    Value<String?>? localPath,
    Value<bool>? downloaded,
  }) {
    return MailAttachmentsCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      filename: filename ?? this.filename,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      contentId: contentId ?? this.contentId,
      localPath: localPath ?? this.localPath,
      downloaded: downloaded ?? this.downloaded,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<int>(messageId.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (downloaded.present) {
      map['downloaded'] = Variable<bool>(downloaded.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MailAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('filename: $filename, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('contentId: $contentId, ')
          ..write('localPath: $localPath, ')
          ..write('downloaded: $downloaded')
          ..write(')'))
        .toString();
  }
}

class $PendingChangesTable extends PendingChanges
    with TableInfo<$PendingChangesTable, PendingChange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingChangesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _entityTableMeta = const VerificationMeta(
    'entityTable',
  );
  @override
  late final GeneratedColumn<String> entityTable = GeneratedColumn<String>(
    'entity_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseEtagMeta = const VerificationMeta(
    'baseEtag',
  );
  @override
  late final GeneratedColumn<String> baseEtag = GeneratedColumn<String>(
    'base_etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    entityTable,
    entityId,
    operation,
    baseEtag,
    payload,
    attempts,
    lastError,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_changes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingChange> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('entity_table')) {
      context.handle(
        _entityTableMeta,
        entityTable.isAcceptableOrUnknown(
          data['entity_table']!,
          _entityTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entityTableMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('base_etag')) {
      context.handle(
        _baseEtagMeta,
        baseEtag.isAcceptableOrUnknown(data['base_etag']!, _baseEtagMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingChange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingChange(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      entityTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_table'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      baseEtag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_etag'],
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingChangesTable createAlias(String alias) {
    return $PendingChangesTable(attachedDatabase, alias);
  }
}

class PendingChange extends DataClass implements Insertable<PendingChange> {
  final int id;
  final int accountId;
  final String entityTable;
  final int entityId;
  final String operation;
  final String? baseEtag;
  final String? payload;
  final int attempts;
  final String? lastError;
  final DateTime createdAt;
  const PendingChange({
    required this.id,
    required this.accountId,
    required this.entityTable,
    required this.entityId,
    required this.operation,
    this.baseEtag,
    this.payload,
    required this.attempts,
    this.lastError,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['entity_table'] = Variable<String>(entityTable);
    map['entity_id'] = Variable<int>(entityId);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || baseEtag != null) {
      map['base_etag'] = Variable<String>(baseEtag);
    }
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingChangesCompanion toCompanion(bool nullToAbsent) {
    return PendingChangesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      entityTable: Value(entityTable),
      entityId: Value(entityId),
      operation: Value(operation),
      baseEtag: baseEtag == null && nullToAbsent
          ? const Value.absent()
          : Value(baseEtag),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
    );
  }

  factory PendingChange.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingChange(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      entityTable: serializer.fromJson<String>(json['entityTable']),
      entityId: serializer.fromJson<int>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      baseEtag: serializer.fromJson<String?>(json['baseEtag']),
      payload: serializer.fromJson<String?>(json['payload']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'entityTable': serializer.toJson<String>(entityTable),
      'entityId': serializer.toJson<int>(entityId),
      'operation': serializer.toJson<String>(operation),
      'baseEtag': serializer.toJson<String?>(baseEtag),
      'payload': serializer.toJson<String?>(payload),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingChange copyWith({
    int? id,
    int? accountId,
    String? entityTable,
    int? entityId,
    String? operation,
    Value<String?> baseEtag = const Value.absent(),
    Value<String?> payload = const Value.absent(),
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
  }) => PendingChange(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    entityTable: entityTable ?? this.entityTable,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    baseEtag: baseEtag.present ? baseEtag.value : this.baseEtag,
    payload: payload.present ? payload.value : this.payload,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingChange copyWithCompanion(PendingChangesCompanion data) {
    return PendingChange(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      entityTable: data.entityTable.present
          ? data.entityTable.value
          : this.entityTable,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      baseEtag: data.baseEtag.present ? data.baseEtag.value : this.baseEtag,
      payload: data.payload.present ? data.payload.value : this.payload,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingChange(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('baseEtag: $baseEtag, ')
          ..write('payload: $payload, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    entityTable,
    entityId,
    operation,
    baseEtag,
    payload,
    attempts,
    lastError,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingChange &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.entityTable == this.entityTable &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.baseEtag == this.baseEtag &&
          other.payload == this.payload &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt);
}

class PendingChangesCompanion extends UpdateCompanion<PendingChange> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> entityTable;
  final Value<int> entityId;
  final Value<String> operation;
  final Value<String?> baseEtag;
  final Value<String?> payload;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  const PendingChangesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.entityTable = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.baseEtag = const Value.absent(),
    this.payload = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PendingChangesCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String entityTable,
    required int entityId,
    required String operation,
    this.baseEtag = const Value.absent(),
    this.payload = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : accountId = Value(accountId),
       entityTable = Value(entityTable),
       entityId = Value(entityId),
       operation = Value(operation);
  static Insertable<PendingChange> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? entityTable,
    Expression<int>? entityId,
    Expression<String>? operation,
    Expression<String>? baseEtag,
    Expression<String>? payload,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (entityTable != null) 'entity_table': entityTable,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (baseEtag != null) 'base_etag': baseEtag,
      if (payload != null) 'payload': payload,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingChangesCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<String>? entityTable,
    Value<int>? entityId,
    Value<String>? operation,
    Value<String?>? baseEtag,
    Value<String?>? payload,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
  }) {
    return PendingChangesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      entityTable: entityTable ?? this.entityTable,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      baseEtag: baseEtag ?? this.baseEtag,
      payload: payload ?? this.payload,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (entityTable.present) {
      map['entity_table'] = Variable<String>(entityTable.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (baseEtag.present) {
      map['base_etag'] = Variable<String>(baseEtag.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingChangesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('baseEtag: $baseEtag, ')
          ..write('payload: $payload, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SyncConflictsTable extends SyncConflicts
    with TableInfo<$SyncConflictsTable, SyncConflict> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncConflictsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _entityTableMeta = const VerificationMeta(
    'entityTable',
  );
  @override
  late final GeneratedColumn<String> entityTable = GeneratedColumn<String>(
    'entity_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPayloadMeta = const VerificationMeta(
    'localPayload',
  );
  @override
  late final GeneratedColumn<String> localPayload = GeneratedColumn<String>(
    'local_payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverPayloadMeta = const VerificationMeta(
    'serverPayload',
  );
  @override
  late final GeneratedColumn<String> serverPayload = GeneratedColumn<String>(
    'server_payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverEtagMeta = const VerificationMeta(
    'serverEtag',
  );
  @override
  late final GeneratedColumn<String> serverEtag = GeneratedColumn<String>(
    'server_etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resolutionMeta = const VerificationMeta(
    'resolution',
  );
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
    'resolution',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detectedAtMeta = const VerificationMeta(
    'detectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
    'detected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    entityTable,
    entityId,
    localPayload,
    serverPayload,
    serverEtag,
    resolution,
    detectedAt,
    resolvedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_conflicts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncConflict> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('entity_table')) {
      context.handle(
        _entityTableMeta,
        entityTable.isAcceptableOrUnknown(
          data['entity_table']!,
          _entityTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entityTableMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('local_payload')) {
      context.handle(
        _localPayloadMeta,
        localPayload.isAcceptableOrUnknown(
          data['local_payload']!,
          _localPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localPayloadMeta);
    }
    if (data.containsKey('server_payload')) {
      context.handle(
        _serverPayloadMeta,
        serverPayload.isAcceptableOrUnknown(
          data['server_payload']!,
          _serverPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverPayloadMeta);
    }
    if (data.containsKey('server_etag')) {
      context.handle(
        _serverEtagMeta,
        serverEtag.isAcceptableOrUnknown(data['server_etag']!, _serverEtagMeta),
      );
    }
    if (data.containsKey('resolution')) {
      context.handle(
        _resolutionMeta,
        resolution.isAcceptableOrUnknown(data['resolution']!, _resolutionMeta),
      );
    }
    if (data.containsKey('detected_at')) {
      context.handle(
        _detectedAtMeta,
        detectedAt.isAcceptableOrUnknown(data['detected_at']!, _detectedAtMeta),
      );
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncConflict map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncConflict(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      entityTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_table'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      )!,
      localPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_payload'],
      )!,
      serverPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_payload'],
      )!,
      serverEtag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_etag'],
      ),
      resolution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolution'],
      ),
      detectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}detected_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
    );
  }

  @override
  $SyncConflictsTable createAlias(String alias) {
    return $SyncConflictsTable(attachedDatabase, alias);
  }
}

class SyncConflict extends DataClass implements Insertable<SyncConflict> {
  final int id;
  final int accountId;
  final String entityTable;
  final int entityId;
  final String localPayload;
  final String serverPayload;
  final String? serverEtag;
  final String? resolution;
  final DateTime detectedAt;
  final DateTime? resolvedAt;
  const SyncConflict({
    required this.id,
    required this.accountId,
    required this.entityTable,
    required this.entityId,
    required this.localPayload,
    required this.serverPayload,
    this.serverEtag,
    this.resolution,
    required this.detectedAt,
    this.resolvedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['entity_table'] = Variable<String>(entityTable);
    map['entity_id'] = Variable<int>(entityId);
    map['local_payload'] = Variable<String>(localPayload);
    map['server_payload'] = Variable<String>(serverPayload);
    if (!nullToAbsent || serverEtag != null) {
      map['server_etag'] = Variable<String>(serverEtag);
    }
    if (!nullToAbsent || resolution != null) {
      map['resolution'] = Variable<String>(resolution);
    }
    map['detected_at'] = Variable<DateTime>(detectedAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    return map;
  }

  SyncConflictsCompanion toCompanion(bool nullToAbsent) {
    return SyncConflictsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      entityTable: Value(entityTable),
      entityId: Value(entityId),
      localPayload: Value(localPayload),
      serverPayload: Value(serverPayload),
      serverEtag: serverEtag == null && nullToAbsent
          ? const Value.absent()
          : Value(serverEtag),
      resolution: resolution == null && nullToAbsent
          ? const Value.absent()
          : Value(resolution),
      detectedAt: Value(detectedAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory SyncConflict.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncConflict(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      entityTable: serializer.fromJson<String>(json['entityTable']),
      entityId: serializer.fromJson<int>(json['entityId']),
      localPayload: serializer.fromJson<String>(json['localPayload']),
      serverPayload: serializer.fromJson<String>(json['serverPayload']),
      serverEtag: serializer.fromJson<String?>(json['serverEtag']),
      resolution: serializer.fromJson<String?>(json['resolution']),
      detectedAt: serializer.fromJson<DateTime>(json['detectedAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'entityTable': serializer.toJson<String>(entityTable),
      'entityId': serializer.toJson<int>(entityId),
      'localPayload': serializer.toJson<String>(localPayload),
      'serverPayload': serializer.toJson<String>(serverPayload),
      'serverEtag': serializer.toJson<String?>(serverEtag),
      'resolution': serializer.toJson<String?>(resolution),
      'detectedAt': serializer.toJson<DateTime>(detectedAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
    };
  }

  SyncConflict copyWith({
    int? id,
    int? accountId,
    String? entityTable,
    int? entityId,
    String? localPayload,
    String? serverPayload,
    Value<String?> serverEtag = const Value.absent(),
    Value<String?> resolution = const Value.absent(),
    DateTime? detectedAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
  }) => SyncConflict(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    entityTable: entityTable ?? this.entityTable,
    entityId: entityId ?? this.entityId,
    localPayload: localPayload ?? this.localPayload,
    serverPayload: serverPayload ?? this.serverPayload,
    serverEtag: serverEtag.present ? serverEtag.value : this.serverEtag,
    resolution: resolution.present ? resolution.value : this.resolution,
    detectedAt: detectedAt ?? this.detectedAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
  );
  SyncConflict copyWithCompanion(SyncConflictsCompanion data) {
    return SyncConflict(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      entityTable: data.entityTable.present
          ? data.entityTable.value
          : this.entityTable,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      localPayload: data.localPayload.present
          ? data.localPayload.value
          : this.localPayload,
      serverPayload: data.serverPayload.present
          ? data.serverPayload.value
          : this.serverPayload,
      serverEtag: data.serverEtag.present
          ? data.serverEtag.value
          : this.serverEtag,
      resolution: data.resolution.present
          ? data.resolution.value
          : this.resolution,
      detectedAt: data.detectedAt.present
          ? data.detectedAt.value
          : this.detectedAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflict(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('localPayload: $localPayload, ')
          ..write('serverPayload: $serverPayload, ')
          ..write('serverEtag: $serverEtag, ')
          ..write('resolution: $resolution, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    entityTable,
    entityId,
    localPayload,
    serverPayload,
    serverEtag,
    resolution,
    detectedAt,
    resolvedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncConflict &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.entityTable == this.entityTable &&
          other.entityId == this.entityId &&
          other.localPayload == this.localPayload &&
          other.serverPayload == this.serverPayload &&
          other.serverEtag == this.serverEtag &&
          other.resolution == this.resolution &&
          other.detectedAt == this.detectedAt &&
          other.resolvedAt == this.resolvedAt);
}

class SyncConflictsCompanion extends UpdateCompanion<SyncConflict> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> entityTable;
  final Value<int> entityId;
  final Value<String> localPayload;
  final Value<String> serverPayload;
  final Value<String?> serverEtag;
  final Value<String?> resolution;
  final Value<DateTime> detectedAt;
  final Value<DateTime?> resolvedAt;
  const SyncConflictsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.entityTable = const Value.absent(),
    this.entityId = const Value.absent(),
    this.localPayload = const Value.absent(),
    this.serverPayload = const Value.absent(),
    this.serverEtag = const Value.absent(),
    this.resolution = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
  });
  SyncConflictsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String entityTable,
    required int entityId,
    required String localPayload,
    required String serverPayload,
    this.serverEtag = const Value.absent(),
    this.resolution = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
  }) : accountId = Value(accountId),
       entityTable = Value(entityTable),
       entityId = Value(entityId),
       localPayload = Value(localPayload),
       serverPayload = Value(serverPayload);
  static Insertable<SyncConflict> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? entityTable,
    Expression<int>? entityId,
    Expression<String>? localPayload,
    Expression<String>? serverPayload,
    Expression<String>? serverEtag,
    Expression<String>? resolution,
    Expression<DateTime>? detectedAt,
    Expression<DateTime>? resolvedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (entityTable != null) 'entity_table': entityTable,
      if (entityId != null) 'entity_id': entityId,
      if (localPayload != null) 'local_payload': localPayload,
      if (serverPayload != null) 'server_payload': serverPayload,
      if (serverEtag != null) 'server_etag': serverEtag,
      if (resolution != null) 'resolution': resolution,
      if (detectedAt != null) 'detected_at': detectedAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
    });
  }

  SyncConflictsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<String>? entityTable,
    Value<int>? entityId,
    Value<String>? localPayload,
    Value<String>? serverPayload,
    Value<String?>? serverEtag,
    Value<String?>? resolution,
    Value<DateTime>? detectedAt,
    Value<DateTime?>? resolvedAt,
  }) {
    return SyncConflictsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      entityTable: entityTable ?? this.entityTable,
      entityId: entityId ?? this.entityId,
      localPayload: localPayload ?? this.localPayload,
      serverPayload: serverPayload ?? this.serverPayload,
      serverEtag: serverEtag ?? this.serverEtag,
      resolution: resolution ?? this.resolution,
      detectedAt: detectedAt ?? this.detectedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (entityTable.present) {
      map['entity_table'] = Variable<String>(entityTable.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (localPayload.present) {
      map['local_payload'] = Variable<String>(localPayload.value);
    }
    if (serverPayload.present) {
      map['server_payload'] = Variable<String>(serverPayload.value);
    }
    if (serverEtag.present) {
      map['server_etag'] = Variable<String>(serverEtag.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('localPayload: $localPayload, ')
          ..write('serverPayload: $serverPayload, ')
          ..write('serverEtag: $serverEtag, ')
          ..write('resolution: $resolution, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$CourrierDatabase extends GeneratedDatabase {
  _$CourrierDatabase(QueryExecutor e) : super(e);
  $CourrierDatabaseManager get managers => $CourrierDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CollectionsTable collections = $CollectionsTable(this);
  late final $CalendarEventsTable calendarEvents = $CalendarEventsTable(this);
  late final $EventRemindersTable eventReminders = $EventRemindersTable(this);
  late final $EventRecurrenceOverridesTable eventRecurrenceOverrides =
      $EventRecurrenceOverridesTable(this);
  late final $ContactCardsTable contactCards = $ContactCardsTable(this);
  late final $ContactGroupsTable contactGroups = $ContactGroupsTable(this);
  late final $ContactGroupMembersTable contactGroupMembers =
      $ContactGroupMembersTable(this);
  late final $TodoItemsTable todoItems = $TodoItemsTable(this);
  late final $NoteItemsTable noteItems = $NoteItemsTable(this);
  late final $FeedSubscriptionsTable feedSubscriptions =
      $FeedSubscriptionsTable(this);
  late final $FeedItemsTable feedItems = $FeedItemsTable(this);
  late final $MailFoldersTable mailFolders = $MailFoldersTable(this);
  late final $MailMessagesTable mailMessages = $MailMessagesTable(this);
  late final $MailAttachmentsTable mailAttachments = $MailAttachmentsTable(
    this,
  );
  late final $PendingChangesTable pendingChanges = $PendingChangesTable(this);
  late final $SyncConflictsTable syncConflicts = $SyncConflictsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    collections,
    calendarEvents,
    eventReminders,
    eventRecurrenceOverrides,
    contactCards,
    contactGroups,
    contactGroupMembers,
    todoItems,
    noteItems,
    feedSubscriptions,
    feedItems,
    mailFolders,
    mailMessages,
    mailAttachments,
    pendingChanges,
    syncConflicts,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('collections', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'collections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('calendar_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'calendar_events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('event_reminders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'calendar_events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('event_recurrence_overrides', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'collections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('contact_cards', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'collections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('contact_groups', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contact_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('contact_group_members', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'contact_cards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('contact_group_members', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'collections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('todo_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'collections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('note_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('feed_subscriptions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'feed_subscriptions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('feed_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mail_folders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'mail_folders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mail_messages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'mail_messages',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mail_attachments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pending_changes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sync_conflicts', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      required String kind,
      required String displayName,
      Value<String?> baseUrl,
      Value<String?> username,
      Value<bool> enabled,
      Value<DateTime> createdAt,
      Value<String?> secretsRef,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      Value<String> kind,
      Value<String> displayName,
      Value<String?> baseUrl,
      Value<String?> username,
      Value<bool> enabled,
      Value<DateTime> createdAt,
      Value<String?> secretsRef,
    });

final class $$AccountsTableReferences
    extends BaseReferences<_$CourrierDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CollectionsTable, List<Collection>>
  _collectionsRefsTable(_$CourrierDatabase db) => MultiTypedResultKey.fromTable(
    db.collections,
    aliasName: 'accounts__id__collections__account_id',
  );

  $$CollectionsTableProcessedTableManager get collectionsRefs {
    final manager = $$CollectionsTableTableManager(
      $_db,
      $_db.collections,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_collectionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FeedSubscriptionsTable, List<FeedSubscription>>
  _feedSubscriptionsRefsTable(_$CourrierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.feedSubscriptions,
        aliasName: 'accounts__id__feed_subscriptions__account_id',
      );

  $$FeedSubscriptionsTableProcessedTableManager get feedSubscriptionsRefs {
    final manager = $$FeedSubscriptionsTableTableManager(
      $_db,
      $_db.feedSubscriptions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _feedSubscriptionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MailFoldersTable, List<MailFolder>>
  _mailFoldersRefsTable(_$CourrierDatabase db) => MultiTypedResultKey.fromTable(
    db.mailFolders,
    aliasName: 'accounts__id__mail_folders__account_id',
  );

  $$MailFoldersTableProcessedTableManager get mailFoldersRefs {
    final manager = $$MailFoldersTableTableManager(
      $_db,
      $_db.mailFolders,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mailFoldersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PendingChangesTable, List<PendingChange>>
  _pendingChangesRefsTable(_$CourrierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.pendingChanges,
        aliasName: 'accounts__id__pending_changes__account_id',
      );

  $$PendingChangesTableProcessedTableManager get pendingChangesRefs {
    final manager = $$PendingChangesTableTableManager(
      $_db,
      $_db.pendingChanges,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pendingChangesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SyncConflictsTable, List<SyncConflict>>
  _syncConflictsRefsTable(_$CourrierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.syncConflicts,
        aliasName: 'accounts__id__sync_conflicts__account_id',
      );

  $$SyncConflictsTableProcessedTableManager get syncConflictsRefs {
    final manager = $$SyncConflictsTableTableManager(
      $_db,
      $_db.syncConflicts,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_syncConflictsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$CourrierDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secretsRef => $composableBuilder(
    column: $table.secretsRef,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> collectionsRefs(
    Expression<bool> Function($$CollectionsTableFilterComposer f) f,
  ) {
    final $$CollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableFilterComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> feedSubscriptionsRefs(
    Expression<bool> Function($$FeedSubscriptionsTableFilterComposer f) f,
  ) {
    final $$FeedSubscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feedSubscriptions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedSubscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.feedSubscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mailFoldersRefs(
    Expression<bool> Function($$MailFoldersTableFilterComposer f) f,
  ) {
    final $$MailFoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mailFolders,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MailFoldersTableFilterComposer(
            $db: $db,
            $table: $db.mailFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pendingChangesRefs(
    Expression<bool> Function($$PendingChangesTableFilterComposer f) f,
  ) {
    final $$PendingChangesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pendingChanges,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PendingChangesTableFilterComposer(
            $db: $db,
            $table: $db.pendingChanges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> syncConflictsRefs(
    Expression<bool> Function($$SyncConflictsTableFilterComposer f) f,
  ) {
    final $$SyncConflictsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncConflicts,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncConflictsTableFilterComposer(
            $db: $db,
            $table: $db.syncConflicts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$CourrierDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secretsRef => $composableBuilder(
    column: $table.secretsRef,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get secretsRef => $composableBuilder(
    column: $table.secretsRef,
    builder: (column) => column,
  );

  Expression<T> collectionsRefs<T extends Object>(
    Expression<T> Function($$CollectionsTableAnnotationComposer a) f,
  ) {
    final $$CollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> feedSubscriptionsRefs<T extends Object>(
    Expression<T> Function($$FeedSubscriptionsTableAnnotationComposer a) f,
  ) {
    final $$FeedSubscriptionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.feedSubscriptions,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FeedSubscriptionsTableAnnotationComposer(
                $db: $db,
                $table: $db.feedSubscriptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> mailFoldersRefs<T extends Object>(
    Expression<T> Function($$MailFoldersTableAnnotationComposer a) f,
  ) {
    final $$MailFoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mailFolders,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MailFoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.mailFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pendingChangesRefs<T extends Object>(
    Expression<T> Function($$PendingChangesTableAnnotationComposer a) f,
  ) {
    final $$PendingChangesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pendingChanges,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PendingChangesTableAnnotationComposer(
            $db: $db,
            $table: $db.pendingChanges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> syncConflictsRefs<T extends Object>(
    Expression<T> Function($$SyncConflictsTableAnnotationComposer a) f,
  ) {
    final $$SyncConflictsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncConflicts,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncConflictsTableAnnotationComposer(
            $db: $db,
            $table: $db.syncConflicts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({
            bool collectionsRefs,
            bool feedSubscriptionsRefs,
            bool mailFoldersRefs,
            bool pendingChangesRefs,
            bool syncConflictsRefs,
          })
        > {
  $$AccountsTableTableManager(_$CourrierDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> baseUrl = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> secretsRef = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                kind: kind,
                displayName: displayName,
                baseUrl: baseUrl,
                username: username,
                enabled: enabled,
                createdAt: createdAt,
                secretsRef: secretsRef,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                required String displayName,
                Value<String?> baseUrl = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> secretsRef = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                kind: kind,
                displayName: displayName,
                baseUrl: baseUrl,
                username: username,
                enabled: enabled,
                createdAt: createdAt,
                secretsRef: secretsRef,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                collectionsRefs = false,
                feedSubscriptionsRefs = false,
                mailFoldersRefs = false,
                pendingChangesRefs = false,
                syncConflictsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (collectionsRefs) db.collections,
                    if (feedSubscriptionsRefs) db.feedSubscriptions,
                    if (mailFoldersRefs) db.mailFolders,
                    if (pendingChangesRefs) db.pendingChanges,
                    if (syncConflictsRefs) db.syncConflicts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (collectionsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          Collection
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._collectionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).collectionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (feedSubscriptionsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          FeedSubscription
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._feedSubscriptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).feedSubscriptionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mailFoldersRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          MailFolder
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._mailFoldersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).mailFoldersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pendingChangesRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          PendingChange
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._pendingChangesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).pendingChangesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (syncConflictsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          SyncConflict
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._syncConflictsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).syncConflictsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({
        bool collectionsRefs,
        bool feedSubscriptionsRefs,
        bool mailFoldersRefs,
        bool pendingChangesRefs,
        bool syncConflictsRefs,
      })
    >;
typedef $$CollectionsTableCreateCompanionBuilder =
    CollectionsCompanion Function({
      Value<int> id,
      required int accountId,
      required String kind,
      Value<String?> remoteHref,
      required String displayName,
      Value<String?> color,
      Value<String?> ctag,
      Value<String?> syncToken,
      Value<int?> windowSize,
      Value<bool> enabled,
      Value<DateTime?> lastSyncedAt,
    });
typedef $$CollectionsTableUpdateCompanionBuilder =
    CollectionsCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<String> kind,
      Value<String?> remoteHref,
      Value<String> displayName,
      Value<String?> color,
      Value<String?> ctag,
      Value<String?> syncToken,
      Value<int?> windowSize,
      Value<bool> enabled,
      Value<DateTime?> lastSyncedAt,
    });

final class $$CollectionsTableReferences
    extends BaseReferences<_$CourrierDatabase, $CollectionsTable, Collection> {
  $$CollectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$CourrierDatabase db) =>
      db.accounts.createAlias('collections__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CalendarEventsTable, List<CalendarEvent>>
  _calendarEventsRefsTable(_$CourrierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.calendarEvents,
        aliasName: 'collections__id__calendar_events__collection_id',
      );

  $$CalendarEventsTableProcessedTableManager get calendarEventsRefs {
    final manager = $$CalendarEventsTableTableManager(
      $_db,
      $_db.calendarEvents,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_calendarEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContactCardsTable, List<ContactCard>>
  _contactCardsRefsTable(_$CourrierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.contactCards,
        aliasName: 'collections__id__contact_cards__collection_id',
      );

  $$ContactCardsTableProcessedTableManager get contactCardsRefs {
    final manager = $$ContactCardsTableTableManager(
      $_db,
      $_db.contactCards,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_contactCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContactGroupsTable, List<ContactGroup>>
  _contactGroupsRefsTable(_$CourrierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.contactGroups,
        aliasName: 'collections__id__contact_groups__collection_id',
      );

  $$ContactGroupsTableProcessedTableManager get contactGroupsRefs {
    final manager = $$ContactGroupsTableTableManager(
      $_db,
      $_db.contactGroups,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_contactGroupsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TodoItemsTable, List<TodoItem>>
  _todoItemsRefsTable(_$CourrierDatabase db) => MultiTypedResultKey.fromTable(
    db.todoItems,
    aliasName: 'collections__id__todo_items__collection_id',
  );

  $$TodoItemsTableProcessedTableManager get todoItemsRefs {
    final manager = $$TodoItemsTableTableManager(
      $_db,
      $_db.todoItems,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_todoItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NoteItemsTable, List<NoteItem>>
  _noteItemsRefsTable(_$CourrierDatabase db) => MultiTypedResultKey.fromTable(
    db.noteItems,
    aliasName: 'collections__id__note_items__collection_id',
  );

  $$NoteItemsTableProcessedTableManager get noteItemsRefs {
    final manager = $$NoteItemsTableTableManager(
      $_db,
      $_db.noteItems,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_noteItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CollectionsTableFilterComposer
    extends Composer<_$CourrierDatabase, $CollectionsTable> {
  $$CollectionsTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteHref => $composableBuilder(
    column: $table.remoteHref,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ctag => $composableBuilder(
    column: $table.ctag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncToken => $composableBuilder(
    column: $table.syncToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windowSize => $composableBuilder(
    column: $table.windowSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> calendarEventsRefs(
    Expression<bool> Function($$CalendarEventsTableFilterComposer f) f,
  ) {
    final $$CalendarEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.calendarEvents,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarEventsTableFilterComposer(
            $db: $db,
            $table: $db.calendarEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contactCardsRefs(
    Expression<bool> Function($$ContactCardsTableFilterComposer f) f,
  ) {
    final $$ContactCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contactCards,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactCardsTableFilterComposer(
            $db: $db,
            $table: $db.contactCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contactGroupsRefs(
    Expression<bool> Function($$ContactGroupsTableFilterComposer f) f,
  ) {
    final $$ContactGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contactGroups,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactGroupsTableFilterComposer(
            $db: $db,
            $table: $db.contactGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> todoItemsRefs(
    Expression<bool> Function($$TodoItemsTableFilterComposer f) f,
  ) {
    final $$TodoItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.todoItems,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoItemsTableFilterComposer(
            $db: $db,
            $table: $db.todoItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> noteItemsRefs(
    Expression<bool> Function($$NoteItemsTableFilterComposer f) f,
  ) {
    final $$NoteItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteItems,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteItemsTableFilterComposer(
            $db: $db,
            $table: $db.noteItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableOrderingComposer
    extends Composer<_$CourrierDatabase, $CollectionsTable> {
  $$CollectionsTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteHref => $composableBuilder(
    column: $table.remoteHref,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ctag => $composableBuilder(
    column: $table.ctag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncToken => $composableBuilder(
    column: $table.syncToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windowSize => $composableBuilder(
    column: $table.windowSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionsTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $CollectionsTable> {
  $$CollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get remoteHref => $composableBuilder(
    column: $table.remoteHref,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get ctag =>
      $composableBuilder(column: $table.ctag, builder: (column) => column);

  GeneratedColumn<String> get syncToken =>
      $composableBuilder(column: $table.syncToken, builder: (column) => column);

  GeneratedColumn<int> get windowSize => $composableBuilder(
    column: $table.windowSize,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> calendarEventsRefs<T extends Object>(
    Expression<T> Function($$CalendarEventsTableAnnotationComposer a) f,
  ) {
    final $$CalendarEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.calendarEvents,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.calendarEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contactCardsRefs<T extends Object>(
    Expression<T> Function($$ContactCardsTableAnnotationComposer a) f,
  ) {
    final $$ContactCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contactCards,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.contactCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contactGroupsRefs<T extends Object>(
    Expression<T> Function($$ContactGroupsTableAnnotationComposer a) f,
  ) {
    final $$ContactGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contactGroups,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.contactGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> todoItemsRefs<T extends Object>(
    Expression<T> Function($$TodoItemsTableAnnotationComposer a) f,
  ) {
    final $$TodoItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.todoItems,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.todoItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> noteItemsRefs<T extends Object>(
    Expression<T> Function($$NoteItemsTableAnnotationComposer a) f,
  ) {
    final $$NoteItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteItems,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.noteItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $CollectionsTable,
          Collection,
          $$CollectionsTableFilterComposer,
          $$CollectionsTableOrderingComposer,
          $$CollectionsTableAnnotationComposer,
          $$CollectionsTableCreateCompanionBuilder,
          $$CollectionsTableUpdateCompanionBuilder,
          (Collection, $$CollectionsTableReferences),
          Collection,
          PrefetchHooks Function({
            bool accountId,
            bool calendarEventsRefs,
            bool contactCardsRefs,
            bool contactGroupsRefs,
            bool todoItemsRefs,
            bool noteItemsRefs,
          })
        > {
  $$CollectionsTableTableManager(_$CourrierDatabase db, $CollectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> remoteHref = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> ctag = const Value.absent(),
                Value<String?> syncToken = const Value.absent(),
                Value<int?> windowSize = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => CollectionsCompanion(
                id: id,
                accountId: accountId,
                kind: kind,
                remoteHref: remoteHref,
                displayName: displayName,
                color: color,
                ctag: ctag,
                syncToken: syncToken,
                windowSize: windowSize,
                enabled: enabled,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required String kind,
                Value<String?> remoteHref = const Value.absent(),
                required String displayName,
                Value<String?> color = const Value.absent(),
                Value<String?> ctag = const Value.absent(),
                Value<String?> syncToken = const Value.absent(),
                Value<int?> windowSize = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => CollectionsCompanion.insert(
                id: id,
                accountId: accountId,
                kind: kind,
                remoteHref: remoteHref,
                displayName: displayName,
                color: color,
                ctag: ctag,
                syncToken: syncToken,
                windowSize: windowSize,
                enabled: enabled,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CollectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                calendarEventsRefs = false,
                contactCardsRefs = false,
                contactGroupsRefs = false,
                todoItemsRefs = false,
                noteItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (calendarEventsRefs) db.calendarEvents,
                    if (contactCardsRefs) db.contactCards,
                    if (contactGroupsRefs) db.contactGroups,
                    if (todoItemsRefs) db.todoItems,
                    if (noteItemsRefs) db.noteItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable:
                                        $$CollectionsTableReferences
                                            ._accountIdTable(db),
                                    referencedColumn:
                                        $$CollectionsTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (calendarEventsRefs)
                        await $_getPrefetchedData<
                          Collection,
                          $CollectionsTable,
                          CalendarEvent
                        >(
                          currentTable: table,
                          referencedTable: $$CollectionsTableReferences
                              ._calendarEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CollectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).calendarEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.collectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (contactCardsRefs)
                        await $_getPrefetchedData<
                          Collection,
                          $CollectionsTable,
                          ContactCard
                        >(
                          currentTable: table,
                          referencedTable: $$CollectionsTableReferences
                              ._contactCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CollectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).contactCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.collectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (contactGroupsRefs)
                        await $_getPrefetchedData<
                          Collection,
                          $CollectionsTable,
                          ContactGroup
                        >(
                          currentTable: table,
                          referencedTable: $$CollectionsTableReferences
                              ._contactGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CollectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).contactGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.collectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (todoItemsRefs)
                        await $_getPrefetchedData<
                          Collection,
                          $CollectionsTable,
                          TodoItem
                        >(
                          currentTable: table,
                          referencedTable: $$CollectionsTableReferences
                              ._todoItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CollectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).todoItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.collectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (noteItemsRefs)
                        await $_getPrefetchedData<
                          Collection,
                          $CollectionsTable,
                          NoteItem
                        >(
                          currentTable: table,
                          referencedTable: $$CollectionsTableReferences
                              ._noteItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CollectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).noteItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.collectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $CollectionsTable,
      Collection,
      $$CollectionsTableFilterComposer,
      $$CollectionsTableOrderingComposer,
      $$CollectionsTableAnnotationComposer,
      $$CollectionsTableCreateCompanionBuilder,
      $$CollectionsTableUpdateCompanionBuilder,
      (Collection, $$CollectionsTableReferences),
      Collection,
      PrefetchHooks Function({
        bool accountId,
        bool calendarEventsRefs,
        bool contactCardsRefs,
        bool contactGroupsRefs,
        bool todoItemsRefs,
        bool noteItemsRefs,
      })
    >;
typedef $$CalendarEventsTableCreateCompanionBuilder =
    CalendarEventsCompanion Function({
      Value<int> id,
      required int collectionId,
      required String uid,
      Value<String?> etag,
      Value<String?> summary,
      Value<String?> location,
      Value<String?> description,
      Value<DateTime?> dtstart,
      Value<DateTime?> dtend,
      Value<bool> allDay,
      Value<String?> rrule,
      Value<String?> organizer,
      Value<String?> attendeesJson,
      required String rawIcs,
      Value<DateTime> lastModified,
      Value<bool> deletedLocally,
    });
typedef $$CalendarEventsTableUpdateCompanionBuilder =
    CalendarEventsCompanion Function({
      Value<int> id,
      Value<int> collectionId,
      Value<String> uid,
      Value<String?> etag,
      Value<String?> summary,
      Value<String?> location,
      Value<String?> description,
      Value<DateTime?> dtstart,
      Value<DateTime?> dtend,
      Value<bool> allDay,
      Value<String?> rrule,
      Value<String?> organizer,
      Value<String?> attendeesJson,
      Value<String> rawIcs,
      Value<DateTime> lastModified,
      Value<bool> deletedLocally,
    });

final class $$CalendarEventsTableReferences
    extends
        BaseReferences<
          _$CourrierDatabase,
          $CalendarEventsTable,
          CalendarEvent
        > {
  $$CalendarEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CollectionsTable _collectionIdTable(_$CourrierDatabase db) => db
      .collections
      .createAlias('calendar_events__collection_id__collections__id');

  $$CollectionsTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<int>('collection_id')!;

    final manager = $$CollectionsTableTableManager(
      $_db,
      $_db.collections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EventRemindersTable, List<EventReminder>>
  _eventRemindersRefsTable(_$CourrierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.eventReminders,
        aliasName: 'calendar_events__id__event_reminders__event_id',
      );

  $$EventRemindersTableProcessedTableManager get eventRemindersRefs {
    final manager = $$EventRemindersTableTableManager(
      $_db,
      $_db.eventReminders,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventRemindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EventRecurrenceOverridesTable,
    List<EventRecurrenceOverride>
  >
  _eventRecurrenceOverridesRefsTable(_$CourrierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.eventRecurrenceOverrides,
        aliasName: 'calendar_events__id__event_recurrence_overrides__event_id',
      );

  $$EventRecurrenceOverridesTableProcessedTableManager
  get eventRecurrenceOverridesRefs {
    final manager = $$EventRecurrenceOverridesTableTableManager(
      $_db,
      $_db.eventRecurrenceOverrides,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _eventRecurrenceOverridesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CalendarEventsTableFilterComposer
    extends Composer<_$CourrierDatabase, $CalendarEventsTable> {
  $$CalendarEventsTableFilterComposer({
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

  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dtstart => $composableBuilder(
    column: $table.dtstart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dtend => $composableBuilder(
    column: $table.dtend,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allDay => $composableBuilder(
    column: $table.allDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rrule => $composableBuilder(
    column: $table.rrule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organizer => $composableBuilder(
    column: $table.organizer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attendeesJson => $composableBuilder(
    column: $table.attendeesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawIcs => $composableBuilder(
    column: $table.rawIcs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocally => $composableBuilder(
    column: $table.deletedLocally,
    builder: (column) => ColumnFilters(column),
  );

  $$CollectionsTableFilterComposer get collectionId {
    final $$CollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableFilterComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> eventRemindersRefs(
    Expression<bool> Function($$EventRemindersTableFilterComposer f) f,
  ) {
    final $$EventRemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventReminders,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventRemindersTableFilterComposer(
            $db: $db,
            $table: $db.eventReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventRecurrenceOverridesRefs(
    Expression<bool> Function($$EventRecurrenceOverridesTableFilterComposer f)
    f,
  ) {
    final $$EventRecurrenceOverridesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.eventRecurrenceOverrides,
          getReferencedColumn: (t) => t.eventId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EventRecurrenceOverridesTableFilterComposer(
                $db: $db,
                $table: $db.eventRecurrenceOverrides,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CalendarEventsTableOrderingComposer
    extends Composer<_$CourrierDatabase, $CalendarEventsTable> {
  $$CalendarEventsTableOrderingComposer({
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

  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dtstart => $composableBuilder(
    column: $table.dtstart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dtend => $composableBuilder(
    column: $table.dtend,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allDay => $composableBuilder(
    column: $table.allDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rrule => $composableBuilder(
    column: $table.rrule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organizer => $composableBuilder(
    column: $table.organizer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attendeesJson => $composableBuilder(
    column: $table.attendeesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawIcs => $composableBuilder(
    column: $table.rawIcs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocally => $composableBuilder(
    column: $table.deletedLocally,
    builder: (column) => ColumnOrderings(column),
  );

  $$CollectionsTableOrderingComposer get collectionId {
    final $$CollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalendarEventsTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $CalendarEventsTable> {
  $$CalendarEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dtstart =>
      $composableBuilder(column: $table.dtstart, builder: (column) => column);

  GeneratedColumn<DateTime> get dtend =>
      $composableBuilder(column: $table.dtend, builder: (column) => column);

  GeneratedColumn<bool> get allDay =>
      $composableBuilder(column: $table.allDay, builder: (column) => column);

  GeneratedColumn<String> get rrule =>
      $composableBuilder(column: $table.rrule, builder: (column) => column);

  GeneratedColumn<String> get organizer =>
      $composableBuilder(column: $table.organizer, builder: (column) => column);

  GeneratedColumn<String> get attendeesJson => $composableBuilder(
    column: $table.attendeesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawIcs =>
      $composableBuilder(column: $table.rawIcs, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deletedLocally => $composableBuilder(
    column: $table.deletedLocally,
    builder: (column) => column,
  );

  $$CollectionsTableAnnotationComposer get collectionId {
    final $$CollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> eventRemindersRefs<T extends Object>(
    Expression<T> Function($$EventRemindersTableAnnotationComposer a) f,
  ) {
    final $$EventRemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventReminders,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventRemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.eventReminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventRecurrenceOverridesRefs<T extends Object>(
    Expression<T> Function($$EventRecurrenceOverridesTableAnnotationComposer a)
    f,
  ) {
    final $$EventRecurrenceOverridesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.eventRecurrenceOverrides,
          getReferencedColumn: (t) => t.eventId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EventRecurrenceOverridesTableAnnotationComposer(
                $db: $db,
                $table: $db.eventRecurrenceOverrides,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CalendarEventsTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $CalendarEventsTable,
          CalendarEvent,
          $$CalendarEventsTableFilterComposer,
          $$CalendarEventsTableOrderingComposer,
          $$CalendarEventsTableAnnotationComposer,
          $$CalendarEventsTableCreateCompanionBuilder,
          $$CalendarEventsTableUpdateCompanionBuilder,
          (CalendarEvent, $$CalendarEventsTableReferences),
          CalendarEvent,
          PrefetchHooks Function({
            bool collectionId,
            bool eventRemindersRefs,
            bool eventRecurrenceOverridesRefs,
          })
        > {
  $$CalendarEventsTableTableManager(
    _$CourrierDatabase db,
    $CalendarEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> collectionId = const Value.absent(),
                Value<String> uid = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dtstart = const Value.absent(),
                Value<DateTime?> dtend = const Value.absent(),
                Value<bool> allDay = const Value.absent(),
                Value<String?> rrule = const Value.absent(),
                Value<String?> organizer = const Value.absent(),
                Value<String?> attendeesJson = const Value.absent(),
                Value<String> rawIcs = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<bool> deletedLocally = const Value.absent(),
              }) => CalendarEventsCompanion(
                id: id,
                collectionId: collectionId,
                uid: uid,
                etag: etag,
                summary: summary,
                location: location,
                description: description,
                dtstart: dtstart,
                dtend: dtend,
                allDay: allDay,
                rrule: rrule,
                organizer: organizer,
                attendeesJson: attendeesJson,
                rawIcs: rawIcs,
                lastModified: lastModified,
                deletedLocally: deletedLocally,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int collectionId,
                required String uid,
                Value<String?> etag = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dtstart = const Value.absent(),
                Value<DateTime?> dtend = const Value.absent(),
                Value<bool> allDay = const Value.absent(),
                Value<String?> rrule = const Value.absent(),
                Value<String?> organizer = const Value.absent(),
                Value<String?> attendeesJson = const Value.absent(),
                required String rawIcs,
                Value<DateTime> lastModified = const Value.absent(),
                Value<bool> deletedLocally = const Value.absent(),
              }) => CalendarEventsCompanion.insert(
                id: id,
                collectionId: collectionId,
                uid: uid,
                etag: etag,
                summary: summary,
                location: location,
                description: description,
                dtstart: dtstart,
                dtend: dtend,
                allDay: allDay,
                rrule: rrule,
                organizer: organizer,
                attendeesJson: attendeesJson,
                rawIcs: rawIcs,
                lastModified: lastModified,
                deletedLocally: deletedLocally,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CalendarEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                collectionId = false,
                eventRemindersRefs = false,
                eventRecurrenceOverridesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (eventRemindersRefs) db.eventReminders,
                    if (eventRecurrenceOverridesRefs)
                      db.eventRecurrenceOverrides,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (collectionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.collectionId,
                                    referencedTable:
                                        $$CalendarEventsTableReferences
                                            ._collectionIdTable(db),
                                    referencedColumn:
                                        $$CalendarEventsTableReferences
                                            ._collectionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (eventRemindersRefs)
                        await $_getPrefetchedData<
                          CalendarEvent,
                          $CalendarEventsTable,
                          EventReminder
                        >(
                          currentTable: table,
                          referencedTable: $$CalendarEventsTableReferences
                              ._eventRemindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CalendarEventsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventRemindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.eventId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (eventRecurrenceOverridesRefs)
                        await $_getPrefetchedData<
                          CalendarEvent,
                          $CalendarEventsTable,
                          EventRecurrenceOverride
                        >(
                          currentTable: table,
                          referencedTable: $$CalendarEventsTableReferences
                              ._eventRecurrenceOverridesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CalendarEventsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventRecurrenceOverridesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.eventId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CalendarEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $CalendarEventsTable,
      CalendarEvent,
      $$CalendarEventsTableFilterComposer,
      $$CalendarEventsTableOrderingComposer,
      $$CalendarEventsTableAnnotationComposer,
      $$CalendarEventsTableCreateCompanionBuilder,
      $$CalendarEventsTableUpdateCompanionBuilder,
      (CalendarEvent, $$CalendarEventsTableReferences),
      CalendarEvent,
      PrefetchHooks Function({
        bool collectionId,
        bool eventRemindersRefs,
        bool eventRecurrenceOverridesRefs,
      })
    >;
typedef $$EventRemindersTableCreateCompanionBuilder =
    EventRemindersCompanion Function({
      Value<int> id,
      required int eventId,
      Value<int?> minutesBeforeStart,
      Value<DateTime?> absoluteTrigger,
      Value<String> action,
      Value<String?> label,
    });
typedef $$EventRemindersTableUpdateCompanionBuilder =
    EventRemindersCompanion Function({
      Value<int> id,
      Value<int> eventId,
      Value<int?> minutesBeforeStart,
      Value<DateTime?> absoluteTrigger,
      Value<String> action,
      Value<String?> label,
    });

final class $$EventRemindersTableReferences
    extends
        BaseReferences<
          _$CourrierDatabase,
          $EventRemindersTable,
          EventReminder
        > {
  $$EventRemindersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CalendarEventsTable _eventIdTable(_$CourrierDatabase db) => db
      .calendarEvents
      .createAlias('event_reminders__event_id__calendar_events__id');

  $$CalendarEventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$CalendarEventsTableTableManager(
      $_db,
      $_db.calendarEvents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventRemindersTableFilterComposer
    extends Composer<_$CourrierDatabase, $EventRemindersTable> {
  $$EventRemindersTableFilterComposer({
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

  ColumnFilters<int> get minutesBeforeStart => $composableBuilder(
    column: $table.minutesBeforeStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get absoluteTrigger => $composableBuilder(
    column: $table.absoluteTrigger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  $$CalendarEventsTableFilterComposer get eventId {
    final $$CalendarEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.calendarEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarEventsTableFilterComposer(
            $db: $db,
            $table: $db.calendarEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventRemindersTableOrderingComposer
    extends Composer<_$CourrierDatabase, $EventRemindersTable> {
  $$EventRemindersTableOrderingComposer({
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

  ColumnOrderings<int> get minutesBeforeStart => $composableBuilder(
    column: $table.minutesBeforeStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get absoluteTrigger => $composableBuilder(
    column: $table.absoluteTrigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  $$CalendarEventsTableOrderingComposer get eventId {
    final $$CalendarEventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.calendarEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarEventsTableOrderingComposer(
            $db: $db,
            $table: $db.calendarEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventRemindersTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $EventRemindersTable> {
  $$EventRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get minutesBeforeStart => $composableBuilder(
    column: $table.minutesBeforeStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get absoluteTrigger => $composableBuilder(
    column: $table.absoluteTrigger,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  $$CalendarEventsTableAnnotationComposer get eventId {
    final $$CalendarEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.calendarEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.calendarEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventRemindersTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $EventRemindersTable,
          EventReminder,
          $$EventRemindersTableFilterComposer,
          $$EventRemindersTableOrderingComposer,
          $$EventRemindersTableAnnotationComposer,
          $$EventRemindersTableCreateCompanionBuilder,
          $$EventRemindersTableUpdateCompanionBuilder,
          (EventReminder, $$EventRemindersTableReferences),
          EventReminder,
          PrefetchHooks Function({bool eventId})
        > {
  $$EventRemindersTableTableManager(
    _$CourrierDatabase db,
    $EventRemindersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> eventId = const Value.absent(),
                Value<int?> minutesBeforeStart = const Value.absent(),
                Value<DateTime?> absoluteTrigger = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> label = const Value.absent(),
              }) => EventRemindersCompanion(
                id: id,
                eventId: eventId,
                minutesBeforeStart: minutesBeforeStart,
                absoluteTrigger: absoluteTrigger,
                action: action,
                label: label,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int eventId,
                Value<int?> minutesBeforeStart = const Value.absent(),
                Value<DateTime?> absoluteTrigger = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> label = const Value.absent(),
              }) => EventRemindersCompanion.insert(
                id: id,
                eventId: eventId,
                minutesBeforeStart: minutesBeforeStart,
                absoluteTrigger: absoluteTrigger,
                action: action,
                label: label,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EventRemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (eventId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.eventId,
                                referencedTable: $$EventRemindersTableReferences
                                    ._eventIdTable(db),
                                referencedColumn:
                                    $$EventRemindersTableReferences
                                        ._eventIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EventRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $EventRemindersTable,
      EventReminder,
      $$EventRemindersTableFilterComposer,
      $$EventRemindersTableOrderingComposer,
      $$EventRemindersTableAnnotationComposer,
      $$EventRemindersTableCreateCompanionBuilder,
      $$EventRemindersTableUpdateCompanionBuilder,
      (EventReminder, $$EventRemindersTableReferences),
      EventReminder,
      PrefetchHooks Function({bool eventId})
    >;
typedef $$EventRecurrenceOverridesTableCreateCompanionBuilder =
    EventRecurrenceOverridesCompanion Function({
      Value<int> id,
      required int eventId,
      required String kind,
      required String value,
    });
typedef $$EventRecurrenceOverridesTableUpdateCompanionBuilder =
    EventRecurrenceOverridesCompanion Function({
      Value<int> id,
      Value<int> eventId,
      Value<String> kind,
      Value<String> value,
    });

final class $$EventRecurrenceOverridesTableReferences
    extends
        BaseReferences<
          _$CourrierDatabase,
          $EventRecurrenceOverridesTable,
          EventRecurrenceOverride
        > {
  $$EventRecurrenceOverridesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CalendarEventsTable _eventIdTable(_$CourrierDatabase db) => db
      .calendarEvents
      .createAlias('event_recurrence_overrides__event_id__calendar_events__id');

  $$CalendarEventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$CalendarEventsTableTableManager(
      $_db,
      $_db.calendarEvents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventRecurrenceOverridesTableFilterComposer
    extends Composer<_$CourrierDatabase, $EventRecurrenceOverridesTable> {
  $$EventRecurrenceOverridesTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$CalendarEventsTableFilterComposer get eventId {
    final $$CalendarEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.calendarEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarEventsTableFilterComposer(
            $db: $db,
            $table: $db.calendarEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventRecurrenceOverridesTableOrderingComposer
    extends Composer<_$CourrierDatabase, $EventRecurrenceOverridesTable> {
  $$EventRecurrenceOverridesTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$CalendarEventsTableOrderingComposer get eventId {
    final $$CalendarEventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.calendarEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarEventsTableOrderingComposer(
            $db: $db,
            $table: $db.calendarEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventRecurrenceOverridesTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $EventRecurrenceOverridesTable> {
  $$EventRecurrenceOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$CalendarEventsTableAnnotationComposer get eventId {
    final $$CalendarEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.calendarEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.calendarEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventRecurrenceOverridesTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $EventRecurrenceOverridesTable,
          EventRecurrenceOverride,
          $$EventRecurrenceOverridesTableFilterComposer,
          $$EventRecurrenceOverridesTableOrderingComposer,
          $$EventRecurrenceOverridesTableAnnotationComposer,
          $$EventRecurrenceOverridesTableCreateCompanionBuilder,
          $$EventRecurrenceOverridesTableUpdateCompanionBuilder,
          (EventRecurrenceOverride, $$EventRecurrenceOverridesTableReferences),
          EventRecurrenceOverride,
          PrefetchHooks Function({bool eventId})
        > {
  $$EventRecurrenceOverridesTableTableManager(
    _$CourrierDatabase db,
    $EventRecurrenceOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventRecurrenceOverridesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EventRecurrenceOverridesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EventRecurrenceOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> eventId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => EventRecurrenceOverridesCompanion(
                id: id,
                eventId: eventId,
                kind: kind,
                value: value,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int eventId,
                required String kind,
                required String value,
              }) => EventRecurrenceOverridesCompanion.insert(
                id: id,
                eventId: eventId,
                kind: kind,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EventRecurrenceOverridesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (eventId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.eventId,
                                referencedTable:
                                    $$EventRecurrenceOverridesTableReferences
                                        ._eventIdTable(db),
                                referencedColumn:
                                    $$EventRecurrenceOverridesTableReferences
                                        ._eventIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EventRecurrenceOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $EventRecurrenceOverridesTable,
      EventRecurrenceOverride,
      $$EventRecurrenceOverridesTableFilterComposer,
      $$EventRecurrenceOverridesTableOrderingComposer,
      $$EventRecurrenceOverridesTableAnnotationComposer,
      $$EventRecurrenceOverridesTableCreateCompanionBuilder,
      $$EventRecurrenceOverridesTableUpdateCompanionBuilder,
      (EventRecurrenceOverride, $$EventRecurrenceOverridesTableReferences),
      EventRecurrenceOverride,
      PrefetchHooks Function({bool eventId})
    >;
typedef $$ContactCardsTableCreateCompanionBuilder =
    ContactCardsCompanion Function({
      Value<int> id,
      required int collectionId,
      required String uid,
      Value<String?> etag,
      Value<String?> formattedName,
      Value<String?> givenName,
      Value<String?> familyName,
      Value<String?> organization,
      Value<String?> primaryEmail,
      Value<String?> primaryPhone,
      required String rawVcard,
      Value<String?> photoRef,
      Value<DateTime> lastModified,
      Value<bool> deletedLocally,
    });
typedef $$ContactCardsTableUpdateCompanionBuilder =
    ContactCardsCompanion Function({
      Value<int> id,
      Value<int> collectionId,
      Value<String> uid,
      Value<String?> etag,
      Value<String?> formattedName,
      Value<String?> givenName,
      Value<String?> familyName,
      Value<String?> organization,
      Value<String?> primaryEmail,
      Value<String?> primaryPhone,
      Value<String> rawVcard,
      Value<String?> photoRef,
      Value<DateTime> lastModified,
      Value<bool> deletedLocally,
    });

final class $$ContactCardsTableReferences
    extends
        BaseReferences<_$CourrierDatabase, $ContactCardsTable, ContactCard> {
  $$ContactCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CollectionsTable _collectionIdTable(_$CourrierDatabase db) => db
      .collections
      .createAlias('contact_cards__collection_id__collections__id');

  $$CollectionsTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<int>('collection_id')!;

    final manager = $$CollectionsTableTableManager(
      $_db,
      $_db.collections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ContactGroupMembersTable,
    List<ContactGroupMember>
  >
  _contactGroupMembersRefsTable(_$CourrierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.contactGroupMembers,
        aliasName: 'contact_cards__id__contact_group_members__contact_id',
      );

  $$ContactGroupMembersTableProcessedTableManager get contactGroupMembersRefs {
    final manager = $$ContactGroupMembersTableTableManager(
      $_db,
      $_db.contactGroupMembers,
    ).filter((f) => f.contactId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _contactGroupMembersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ContactCardsTableFilterComposer
    extends Composer<_$CourrierDatabase, $ContactCardsTable> {
  $$ContactCardsTableFilterComposer({
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

  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formattedName => $composableBuilder(
    column: $table.formattedName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get givenName => $composableBuilder(
    column: $table.givenName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyName => $composableBuilder(
    column: $table.familyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organization => $composableBuilder(
    column: $table.organization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryEmail => $composableBuilder(
    column: $table.primaryEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryPhone => $composableBuilder(
    column: $table.primaryPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawVcard => $composableBuilder(
    column: $table.rawVcard,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoRef => $composableBuilder(
    column: $table.photoRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocally => $composableBuilder(
    column: $table.deletedLocally,
    builder: (column) => ColumnFilters(column),
  );

  $$CollectionsTableFilterComposer get collectionId {
    final $$CollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableFilterComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> contactGroupMembersRefs(
    Expression<bool> Function($$ContactGroupMembersTableFilterComposer f) f,
  ) {
    final $$ContactGroupMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contactGroupMembers,
      getReferencedColumn: (t) => t.contactId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactGroupMembersTableFilterComposer(
            $db: $db,
            $table: $db.contactGroupMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContactCardsTableOrderingComposer
    extends Composer<_$CourrierDatabase, $ContactCardsTable> {
  $$ContactCardsTableOrderingComposer({
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

  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formattedName => $composableBuilder(
    column: $table.formattedName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get givenName => $composableBuilder(
    column: $table.givenName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyName => $composableBuilder(
    column: $table.familyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organization => $composableBuilder(
    column: $table.organization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryEmail => $composableBuilder(
    column: $table.primaryEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryPhone => $composableBuilder(
    column: $table.primaryPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawVcard => $composableBuilder(
    column: $table.rawVcard,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoRef => $composableBuilder(
    column: $table.photoRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocally => $composableBuilder(
    column: $table.deletedLocally,
    builder: (column) => ColumnOrderings(column),
  );

  $$CollectionsTableOrderingComposer get collectionId {
    final $$CollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactCardsTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $ContactCardsTable> {
  $$ContactCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<String> get formattedName => $composableBuilder(
    column: $table.formattedName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get givenName =>
      $composableBuilder(column: $table.givenName, builder: (column) => column);

  GeneratedColumn<String> get familyName => $composableBuilder(
    column: $table.familyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get organization => $composableBuilder(
    column: $table.organization,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryEmail => $composableBuilder(
    column: $table.primaryEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryPhone => $composableBuilder(
    column: $table.primaryPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawVcard =>
      $composableBuilder(column: $table.rawVcard, builder: (column) => column);

  GeneratedColumn<String> get photoRef =>
      $composableBuilder(column: $table.photoRef, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deletedLocally => $composableBuilder(
    column: $table.deletedLocally,
    builder: (column) => column,
  );

  $$CollectionsTableAnnotationComposer get collectionId {
    final $$CollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> contactGroupMembersRefs<T extends Object>(
    Expression<T> Function($$ContactGroupMembersTableAnnotationComposer a) f,
  ) {
    final $$ContactGroupMembersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.contactGroupMembers,
          getReferencedColumn: (t) => t.contactId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ContactGroupMembersTableAnnotationComposer(
                $db: $db,
                $table: $db.contactGroupMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ContactCardsTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $ContactCardsTable,
          ContactCard,
          $$ContactCardsTableFilterComposer,
          $$ContactCardsTableOrderingComposer,
          $$ContactCardsTableAnnotationComposer,
          $$ContactCardsTableCreateCompanionBuilder,
          $$ContactCardsTableUpdateCompanionBuilder,
          (ContactCard, $$ContactCardsTableReferences),
          ContactCard,
          PrefetchHooks Function({
            bool collectionId,
            bool contactGroupMembersRefs,
          })
        > {
  $$ContactCardsTableTableManager(
    _$CourrierDatabase db,
    $ContactCardsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> collectionId = const Value.absent(),
                Value<String> uid = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<String?> formattedName = const Value.absent(),
                Value<String?> givenName = const Value.absent(),
                Value<String?> familyName = const Value.absent(),
                Value<String?> organization = const Value.absent(),
                Value<String?> primaryEmail = const Value.absent(),
                Value<String?> primaryPhone = const Value.absent(),
                Value<String> rawVcard = const Value.absent(),
                Value<String?> photoRef = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<bool> deletedLocally = const Value.absent(),
              }) => ContactCardsCompanion(
                id: id,
                collectionId: collectionId,
                uid: uid,
                etag: etag,
                formattedName: formattedName,
                givenName: givenName,
                familyName: familyName,
                organization: organization,
                primaryEmail: primaryEmail,
                primaryPhone: primaryPhone,
                rawVcard: rawVcard,
                photoRef: photoRef,
                lastModified: lastModified,
                deletedLocally: deletedLocally,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int collectionId,
                required String uid,
                Value<String?> etag = const Value.absent(),
                Value<String?> formattedName = const Value.absent(),
                Value<String?> givenName = const Value.absent(),
                Value<String?> familyName = const Value.absent(),
                Value<String?> organization = const Value.absent(),
                Value<String?> primaryEmail = const Value.absent(),
                Value<String?> primaryPhone = const Value.absent(),
                required String rawVcard,
                Value<String?> photoRef = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<bool> deletedLocally = const Value.absent(),
              }) => ContactCardsCompanion.insert(
                id: id,
                collectionId: collectionId,
                uid: uid,
                etag: etag,
                formattedName: formattedName,
                givenName: givenName,
                familyName: familyName,
                organization: organization,
                primaryEmail: primaryEmail,
                primaryPhone: primaryPhone,
                rawVcard: rawVcard,
                photoRef: photoRef,
                lastModified: lastModified,
                deletedLocally: deletedLocally,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContactCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({collectionId = false, contactGroupMembersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (contactGroupMembersRefs) db.contactGroupMembers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (collectionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.collectionId,
                                    referencedTable:
                                        $$ContactCardsTableReferences
                                            ._collectionIdTable(db),
                                    referencedColumn:
                                        $$ContactCardsTableReferences
                                            ._collectionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (contactGroupMembersRefs)
                        await $_getPrefetchedData<
                          ContactCard,
                          $ContactCardsTable,
                          ContactGroupMember
                        >(
                          currentTable: table,
                          referencedTable: $$ContactCardsTableReferences
                              ._contactGroupMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContactCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).contactGroupMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contactId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ContactCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $ContactCardsTable,
      ContactCard,
      $$ContactCardsTableFilterComposer,
      $$ContactCardsTableOrderingComposer,
      $$ContactCardsTableAnnotationComposer,
      $$ContactCardsTableCreateCompanionBuilder,
      $$ContactCardsTableUpdateCompanionBuilder,
      (ContactCard, $$ContactCardsTableReferences),
      ContactCard,
      PrefetchHooks Function({bool collectionId, bool contactGroupMembersRefs})
    >;
typedef $$ContactGroupsTableCreateCompanionBuilder =
    ContactGroupsCompanion Function({
      Value<int> id,
      required int collectionId,
      required String name,
    });
typedef $$ContactGroupsTableUpdateCompanionBuilder =
    ContactGroupsCompanion Function({
      Value<int> id,
      Value<int> collectionId,
      Value<String> name,
    });

final class $$ContactGroupsTableReferences
    extends
        BaseReferences<_$CourrierDatabase, $ContactGroupsTable, ContactGroup> {
  $$ContactGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CollectionsTable _collectionIdTable(_$CourrierDatabase db) => db
      .collections
      .createAlias('contact_groups__collection_id__collections__id');

  $$CollectionsTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<int>('collection_id')!;

    final manager = $$CollectionsTableTableManager(
      $_db,
      $_db.collections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ContactGroupMembersTable,
    List<ContactGroupMember>
  >
  _contactGroupMembersRefsTable(_$CourrierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.contactGroupMembers,
        aliasName: 'contact_groups__id__contact_group_members__group_id',
      );

  $$ContactGroupMembersTableProcessedTableManager get contactGroupMembersRefs {
    final manager = $$ContactGroupMembersTableTableManager(
      $_db,
      $_db.contactGroupMembers,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _contactGroupMembersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ContactGroupsTableFilterComposer
    extends Composer<_$CourrierDatabase, $ContactGroupsTable> {
  $$ContactGroupsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$CollectionsTableFilterComposer get collectionId {
    final $$CollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableFilterComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> contactGroupMembersRefs(
    Expression<bool> Function($$ContactGroupMembersTableFilterComposer f) f,
  ) {
    final $$ContactGroupMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contactGroupMembers,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactGroupMembersTableFilterComposer(
            $db: $db,
            $table: $db.contactGroupMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContactGroupsTableOrderingComposer
    extends Composer<_$CourrierDatabase, $ContactGroupsTable> {
  $$ContactGroupsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$CollectionsTableOrderingComposer get collectionId {
    final $$CollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactGroupsTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $ContactGroupsTable> {
  $$ContactGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$CollectionsTableAnnotationComposer get collectionId {
    final $$CollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> contactGroupMembersRefs<T extends Object>(
    Expression<T> Function($$ContactGroupMembersTableAnnotationComposer a) f,
  ) {
    final $$ContactGroupMembersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.contactGroupMembers,
          getReferencedColumn: (t) => t.groupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ContactGroupMembersTableAnnotationComposer(
                $db: $db,
                $table: $db.contactGroupMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ContactGroupsTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $ContactGroupsTable,
          ContactGroup,
          $$ContactGroupsTableFilterComposer,
          $$ContactGroupsTableOrderingComposer,
          $$ContactGroupsTableAnnotationComposer,
          $$ContactGroupsTableCreateCompanionBuilder,
          $$ContactGroupsTableUpdateCompanionBuilder,
          (ContactGroup, $$ContactGroupsTableReferences),
          ContactGroup,
          PrefetchHooks Function({
            bool collectionId,
            bool contactGroupMembersRefs,
          })
        > {
  $$ContactGroupsTableTableManager(
    _$CourrierDatabase db,
    $ContactGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> collectionId = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => ContactGroupsCompanion(
                id: id,
                collectionId: collectionId,
                name: name,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int collectionId,
                required String name,
              }) => ContactGroupsCompanion.insert(
                id: id,
                collectionId: collectionId,
                name: name,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContactGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({collectionId = false, contactGroupMembersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (contactGroupMembersRefs) db.contactGroupMembers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (collectionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.collectionId,
                                    referencedTable:
                                        $$ContactGroupsTableReferences
                                            ._collectionIdTable(db),
                                    referencedColumn:
                                        $$ContactGroupsTableReferences
                                            ._collectionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (contactGroupMembersRefs)
                        await $_getPrefetchedData<
                          ContactGroup,
                          $ContactGroupsTable,
                          ContactGroupMember
                        >(
                          currentTable: table,
                          referencedTable: $$ContactGroupsTableReferences
                              ._contactGroupMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContactGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).contactGroupMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ContactGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $ContactGroupsTable,
      ContactGroup,
      $$ContactGroupsTableFilterComposer,
      $$ContactGroupsTableOrderingComposer,
      $$ContactGroupsTableAnnotationComposer,
      $$ContactGroupsTableCreateCompanionBuilder,
      $$ContactGroupsTableUpdateCompanionBuilder,
      (ContactGroup, $$ContactGroupsTableReferences),
      ContactGroup,
      PrefetchHooks Function({bool collectionId, bool contactGroupMembersRefs})
    >;
typedef $$ContactGroupMembersTableCreateCompanionBuilder =
    ContactGroupMembersCompanion Function({
      Value<int> id,
      required int groupId,
      required int contactId,
    });
typedef $$ContactGroupMembersTableUpdateCompanionBuilder =
    ContactGroupMembersCompanion Function({
      Value<int> id,
      Value<int> groupId,
      Value<int> contactId,
    });

final class $$ContactGroupMembersTableReferences
    extends
        BaseReferences<
          _$CourrierDatabase,
          $ContactGroupMembersTable,
          ContactGroupMember
        > {
  $$ContactGroupMembersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContactGroupsTable _groupIdTable(_$CourrierDatabase db) => db
      .contactGroups
      .createAlias('contact_group_members__group_id__contact_groups__id');

  $$ContactGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$ContactGroupsTableTableManager(
      $_db,
      $_db.contactGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ContactCardsTable _contactIdTable(_$CourrierDatabase db) => db
      .contactCards
      .createAlias('contact_group_members__contact_id__contact_cards__id');

  $$ContactCardsTableProcessedTableManager get contactId {
    final $_column = $_itemColumn<int>('contact_id')!;

    final manager = $$ContactCardsTableTableManager(
      $_db,
      $_db.contactCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contactIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContactGroupMembersTableFilterComposer
    extends Composer<_$CourrierDatabase, $ContactGroupMembersTable> {
  $$ContactGroupMembersTableFilterComposer({
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

  $$ContactGroupsTableFilterComposer get groupId {
    final $$ContactGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.contactGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactGroupsTableFilterComposer(
            $db: $db,
            $table: $db.contactGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ContactCardsTableFilterComposer get contactId {
    final $$ContactCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contactId,
      referencedTable: $db.contactCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactCardsTableFilterComposer(
            $db: $db,
            $table: $db.contactCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactGroupMembersTableOrderingComposer
    extends Composer<_$CourrierDatabase, $ContactGroupMembersTable> {
  $$ContactGroupMembersTableOrderingComposer({
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

  $$ContactGroupsTableOrderingComposer get groupId {
    final $$ContactGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.contactGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.contactGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ContactCardsTableOrderingComposer get contactId {
    final $$ContactCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contactId,
      referencedTable: $db.contactCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactCardsTableOrderingComposer(
            $db: $db,
            $table: $db.contactCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactGroupMembersTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $ContactGroupMembersTable> {
  $$ContactGroupMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$ContactGroupsTableAnnotationComposer get groupId {
    final $$ContactGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.contactGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.contactGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ContactCardsTableAnnotationComposer get contactId {
    final $$ContactCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contactId,
      referencedTable: $db.contactCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.contactCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactGroupMembersTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $ContactGroupMembersTable,
          ContactGroupMember,
          $$ContactGroupMembersTableFilterComposer,
          $$ContactGroupMembersTableOrderingComposer,
          $$ContactGroupMembersTableAnnotationComposer,
          $$ContactGroupMembersTableCreateCompanionBuilder,
          $$ContactGroupMembersTableUpdateCompanionBuilder,
          (ContactGroupMember, $$ContactGroupMembersTableReferences),
          ContactGroupMember,
          PrefetchHooks Function({bool groupId, bool contactId})
        > {
  $$ContactGroupMembersTableTableManager(
    _$CourrierDatabase db,
    $ContactGroupMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactGroupMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactGroupMembersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ContactGroupMembersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> groupId = const Value.absent(),
                Value<int> contactId = const Value.absent(),
              }) => ContactGroupMembersCompanion(
                id: id,
                groupId: groupId,
                contactId: contactId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int groupId,
                required int contactId,
              }) => ContactGroupMembersCompanion.insert(
                id: id,
                groupId: groupId,
                contactId: contactId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContactGroupMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, contactId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable:
                                    $$ContactGroupMembersTableReferences
                                        ._groupIdTable(db),
                                referencedColumn:
                                    $$ContactGroupMembersTableReferences
                                        ._groupIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (contactId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.contactId,
                                referencedTable:
                                    $$ContactGroupMembersTableReferences
                                        ._contactIdTable(db),
                                referencedColumn:
                                    $$ContactGroupMembersTableReferences
                                        ._contactIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ContactGroupMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $ContactGroupMembersTable,
      ContactGroupMember,
      $$ContactGroupMembersTableFilterComposer,
      $$ContactGroupMembersTableOrderingComposer,
      $$ContactGroupMembersTableAnnotationComposer,
      $$ContactGroupMembersTableCreateCompanionBuilder,
      $$ContactGroupMembersTableUpdateCompanionBuilder,
      (ContactGroupMember, $$ContactGroupMembersTableReferences),
      ContactGroupMember,
      PrefetchHooks Function({bool groupId, bool contactId})
    >;
typedef $$TodoItemsTableCreateCompanionBuilder =
    TodoItemsCompanion Function({
      Value<int> id,
      required int collectionId,
      required String uid,
      Value<String?> etag,
      Value<String?> summary,
      Value<String?> description,
      Value<DateTime?> due,
      Value<DateTime?> completed,
      Value<int?> percentComplete,
      Value<int?> priority,
      Value<String?> rrule,
      Value<bool> repeatAfterCompletion,
      Value<String?> parentUid,
      required String rawIcs,
      Value<DateTime> lastModified,
      Value<bool> deletedLocally,
    });
typedef $$TodoItemsTableUpdateCompanionBuilder =
    TodoItemsCompanion Function({
      Value<int> id,
      Value<int> collectionId,
      Value<String> uid,
      Value<String?> etag,
      Value<String?> summary,
      Value<String?> description,
      Value<DateTime?> due,
      Value<DateTime?> completed,
      Value<int?> percentComplete,
      Value<int?> priority,
      Value<String?> rrule,
      Value<bool> repeatAfterCompletion,
      Value<String?> parentUid,
      Value<String> rawIcs,
      Value<DateTime> lastModified,
      Value<bool> deletedLocally,
    });

final class $$TodoItemsTableReferences
    extends BaseReferences<_$CourrierDatabase, $TodoItemsTable, TodoItem> {
  $$TodoItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CollectionsTable _collectionIdTable(_$CourrierDatabase db) =>
      db.collections.createAlias('todo_items__collection_id__collections__id');

  $$CollectionsTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<int>('collection_id')!;

    final manager = $$CollectionsTableTableManager(
      $_db,
      $_db.collections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TodoItemsTableFilterComposer
    extends Composer<_$CourrierDatabase, $TodoItemsTable> {
  $$TodoItemsTableFilterComposer({
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

  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get percentComplete => $composableBuilder(
    column: $table.percentComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rrule => $composableBuilder(
    column: $table.rrule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get repeatAfterCompletion => $composableBuilder(
    column: $table.repeatAfterCompletion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentUid => $composableBuilder(
    column: $table.parentUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawIcs => $composableBuilder(
    column: $table.rawIcs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocally => $composableBuilder(
    column: $table.deletedLocally,
    builder: (column) => ColumnFilters(column),
  );

  $$CollectionsTableFilterComposer get collectionId {
    final $$CollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableFilterComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoItemsTableOrderingComposer
    extends Composer<_$CourrierDatabase, $TodoItemsTable> {
  $$TodoItemsTableOrderingComposer({
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

  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get percentComplete => $composableBuilder(
    column: $table.percentComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rrule => $composableBuilder(
    column: $table.rrule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get repeatAfterCompletion => $composableBuilder(
    column: $table.repeatAfterCompletion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentUid => $composableBuilder(
    column: $table.parentUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawIcs => $composableBuilder(
    column: $table.rawIcs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocally => $composableBuilder(
    column: $table.deletedLocally,
    builder: (column) => ColumnOrderings(column),
  );

  $$CollectionsTableOrderingComposer get collectionId {
    final $$CollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoItemsTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $TodoItemsTable> {
  $$TodoItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<DateTime> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get percentComplete => $composableBuilder(
    column: $table.percentComplete,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get rrule =>
      $composableBuilder(column: $table.rrule, builder: (column) => column);

  GeneratedColumn<bool> get repeatAfterCompletion => $composableBuilder(
    column: $table.repeatAfterCompletion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parentUid =>
      $composableBuilder(column: $table.parentUid, builder: (column) => column);

  GeneratedColumn<String> get rawIcs =>
      $composableBuilder(column: $table.rawIcs, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deletedLocally => $composableBuilder(
    column: $table.deletedLocally,
    builder: (column) => column,
  );

  $$CollectionsTableAnnotationComposer get collectionId {
    final $$CollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoItemsTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $TodoItemsTable,
          TodoItem,
          $$TodoItemsTableFilterComposer,
          $$TodoItemsTableOrderingComposer,
          $$TodoItemsTableAnnotationComposer,
          $$TodoItemsTableCreateCompanionBuilder,
          $$TodoItemsTableUpdateCompanionBuilder,
          (TodoItem, $$TodoItemsTableReferences),
          TodoItem,
          PrefetchHooks Function({bool collectionId})
        > {
  $$TodoItemsTableTableManager(_$CourrierDatabase db, $TodoItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> collectionId = const Value.absent(),
                Value<String> uid = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> due = const Value.absent(),
                Value<DateTime?> completed = const Value.absent(),
                Value<int?> percentComplete = const Value.absent(),
                Value<int?> priority = const Value.absent(),
                Value<String?> rrule = const Value.absent(),
                Value<bool> repeatAfterCompletion = const Value.absent(),
                Value<String?> parentUid = const Value.absent(),
                Value<String> rawIcs = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<bool> deletedLocally = const Value.absent(),
              }) => TodoItemsCompanion(
                id: id,
                collectionId: collectionId,
                uid: uid,
                etag: etag,
                summary: summary,
                description: description,
                due: due,
                completed: completed,
                percentComplete: percentComplete,
                priority: priority,
                rrule: rrule,
                repeatAfterCompletion: repeatAfterCompletion,
                parentUid: parentUid,
                rawIcs: rawIcs,
                lastModified: lastModified,
                deletedLocally: deletedLocally,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int collectionId,
                required String uid,
                Value<String?> etag = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> due = const Value.absent(),
                Value<DateTime?> completed = const Value.absent(),
                Value<int?> percentComplete = const Value.absent(),
                Value<int?> priority = const Value.absent(),
                Value<String?> rrule = const Value.absent(),
                Value<bool> repeatAfterCompletion = const Value.absent(),
                Value<String?> parentUid = const Value.absent(),
                required String rawIcs,
                Value<DateTime> lastModified = const Value.absent(),
                Value<bool> deletedLocally = const Value.absent(),
              }) => TodoItemsCompanion.insert(
                id: id,
                collectionId: collectionId,
                uid: uid,
                etag: etag,
                summary: summary,
                description: description,
                due: due,
                completed: completed,
                percentComplete: percentComplete,
                priority: priority,
                rrule: rrule,
                repeatAfterCompletion: repeatAfterCompletion,
                parentUid: parentUid,
                rawIcs: rawIcs,
                lastModified: lastModified,
                deletedLocally: deletedLocally,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TodoItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({collectionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (collectionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.collectionId,
                                referencedTable: $$TodoItemsTableReferences
                                    ._collectionIdTable(db),
                                referencedColumn: $$TodoItemsTableReferences
                                    ._collectionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TodoItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $TodoItemsTable,
      TodoItem,
      $$TodoItemsTableFilterComposer,
      $$TodoItemsTableOrderingComposer,
      $$TodoItemsTableAnnotationComposer,
      $$TodoItemsTableCreateCompanionBuilder,
      $$TodoItemsTableUpdateCompanionBuilder,
      (TodoItem, $$TodoItemsTableReferences),
      TodoItem,
      PrefetchHooks Function({bool collectionId})
    >;
typedef $$NoteItemsTableCreateCompanionBuilder =
    NoteItemsCompanion Function({
      Value<int> id,
      required int collectionId,
      Value<String?> remoteId,
      Value<String?> etag,
      required String title,
      Value<String?> category,
      required String content,
      Value<String> kind,
      Value<bool> favorite,
      Value<bool> locked,
      Value<DateTime> modified,
      Value<bool> deletedLocally,
    });
typedef $$NoteItemsTableUpdateCompanionBuilder =
    NoteItemsCompanion Function({
      Value<int> id,
      Value<int> collectionId,
      Value<String?> remoteId,
      Value<String?> etag,
      Value<String> title,
      Value<String?> category,
      Value<String> content,
      Value<String> kind,
      Value<bool> favorite,
      Value<bool> locked,
      Value<DateTime> modified,
      Value<bool> deletedLocally,
    });

final class $$NoteItemsTableReferences
    extends BaseReferences<_$CourrierDatabase, $NoteItemsTable, NoteItem> {
  $$NoteItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CollectionsTable _collectionIdTable(_$CourrierDatabase db) =>
      db.collections.createAlias('note_items__collection_id__collections__id');

  $$CollectionsTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<int>('collection_id')!;

    final manager = $$CollectionsTableTableManager(
      $_db,
      $_db.collections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NoteItemsTableFilterComposer
    extends Composer<_$CourrierDatabase, $NoteItemsTable> {
  $$NoteItemsTableFilterComposer({
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

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get locked => $composableBuilder(
    column: $table.locked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocally => $composableBuilder(
    column: $table.deletedLocally,
    builder: (column) => ColumnFilters(column),
  );

  $$CollectionsTableFilterComposer get collectionId {
    final $$CollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableFilterComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NoteItemsTableOrderingComposer
    extends Composer<_$CourrierDatabase, $NoteItemsTable> {
  $$NoteItemsTableOrderingComposer({
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

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get locked => $composableBuilder(
    column: $table.locked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocally => $composableBuilder(
    column: $table.deletedLocally,
    builder: (column) => ColumnOrderings(column),
  );

  $$CollectionsTableOrderingComposer get collectionId {
    final $$CollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NoteItemsTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $NoteItemsTable> {
  $$NoteItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<bool> get locked =>
      $composableBuilder(column: $table.locked, builder: (column) => column);

  GeneratedColumn<DateTime> get modified =>
      $composableBuilder(column: $table.modified, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocally => $composableBuilder(
    column: $table.deletedLocally,
    builder: (column) => column,
  );

  $$CollectionsTableAnnotationComposer get collectionId {
    final $$CollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NoteItemsTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $NoteItemsTable,
          NoteItem,
          $$NoteItemsTableFilterComposer,
          $$NoteItemsTableOrderingComposer,
          $$NoteItemsTableAnnotationComposer,
          $$NoteItemsTableCreateCompanionBuilder,
          $$NoteItemsTableUpdateCompanionBuilder,
          (NoteItem, $$NoteItemsTableReferences),
          NoteItem,
          PrefetchHooks Function({bool collectionId})
        > {
  $$NoteItemsTableTableManager(_$CourrierDatabase db, $NoteItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> collectionId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<bool> locked = const Value.absent(),
                Value<DateTime> modified = const Value.absent(),
                Value<bool> deletedLocally = const Value.absent(),
              }) => NoteItemsCompanion(
                id: id,
                collectionId: collectionId,
                remoteId: remoteId,
                etag: etag,
                title: title,
                category: category,
                content: content,
                kind: kind,
                favorite: favorite,
                locked: locked,
                modified: modified,
                deletedLocally: deletedLocally,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int collectionId,
                Value<String?> remoteId = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                required String title,
                Value<String?> category = const Value.absent(),
                required String content,
                Value<String> kind = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<bool> locked = const Value.absent(),
                Value<DateTime> modified = const Value.absent(),
                Value<bool> deletedLocally = const Value.absent(),
              }) => NoteItemsCompanion.insert(
                id: id,
                collectionId: collectionId,
                remoteId: remoteId,
                etag: etag,
                title: title,
                category: category,
                content: content,
                kind: kind,
                favorite: favorite,
                locked: locked,
                modified: modified,
                deletedLocally: deletedLocally,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NoteItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({collectionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (collectionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.collectionId,
                                referencedTable: $$NoteItemsTableReferences
                                    ._collectionIdTable(db),
                                referencedColumn: $$NoteItemsTableReferences
                                    ._collectionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NoteItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $NoteItemsTable,
      NoteItem,
      $$NoteItemsTableFilterComposer,
      $$NoteItemsTableOrderingComposer,
      $$NoteItemsTableAnnotationComposer,
      $$NoteItemsTableCreateCompanionBuilder,
      $$NoteItemsTableUpdateCompanionBuilder,
      (NoteItem, $$NoteItemsTableReferences),
      NoteItem,
      PrefetchHooks Function({bool collectionId})
    >;
typedef $$FeedSubscriptionsTableCreateCompanionBuilder =
    FeedSubscriptionsCompanion Function({
      Value<int> id,
      required int accountId,
      required String url,
      required String title,
      Value<String?> folder,
      Value<int> refreshIntervalMinutes,
      Value<DateTime?> lastFetched,
    });
typedef $$FeedSubscriptionsTableUpdateCompanionBuilder =
    FeedSubscriptionsCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<String> url,
      Value<String> title,
      Value<String?> folder,
      Value<int> refreshIntervalMinutes,
      Value<DateTime?> lastFetched,
    });

final class $$FeedSubscriptionsTableReferences
    extends
        BaseReferences<
          _$CourrierDatabase,
          $FeedSubscriptionsTable,
          FeedSubscription
        > {
  $$FeedSubscriptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$CourrierDatabase db) =>
      db.accounts.createAlias('feed_subscriptions__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FeedItemsTable, List<FeedItem>>
  _feedItemsRefsTable(_$CourrierDatabase db) => MultiTypedResultKey.fromTable(
    db.feedItems,
    aliasName: 'feed_subscriptions__id__feed_items__feed_id',
  );

  $$FeedItemsTableProcessedTableManager get feedItemsRefs {
    final manager = $$FeedItemsTableTableManager(
      $_db,
      $_db.feedItems,
    ).filter((f) => f.feedId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_feedItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FeedSubscriptionsTableFilterComposer
    extends Composer<_$CourrierDatabase, $FeedSubscriptionsTable> {
  $$FeedSubscriptionsTableFilterComposer({
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

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folder => $composableBuilder(
    column: $table.folder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get refreshIntervalMinutes => $composableBuilder(
    column: $table.refreshIntervalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> feedItemsRefs(
    Expression<bool> Function($$FeedItemsTableFilterComposer f) f,
  ) {
    final $$FeedItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feedItems,
      getReferencedColumn: (t) => t.feedId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedItemsTableFilterComposer(
            $db: $db,
            $table: $db.feedItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FeedSubscriptionsTableOrderingComposer
    extends Composer<_$CourrierDatabase, $FeedSubscriptionsTable> {
  $$FeedSubscriptionsTableOrderingComposer({
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

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folder => $composableBuilder(
    column: $table.folder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get refreshIntervalMinutes => $composableBuilder(
    column: $table.refreshIntervalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedSubscriptionsTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $FeedSubscriptionsTable> {
  $$FeedSubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get folder =>
      $composableBuilder(column: $table.folder, builder: (column) => column);

  GeneratedColumn<int> get refreshIntervalMinutes => $composableBuilder(
    column: $table.refreshIntervalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> feedItemsRefs<T extends Object>(
    Expression<T> Function($$FeedItemsTableAnnotationComposer a) f,
  ) {
    final $$FeedItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feedItems,
      getReferencedColumn: (t) => t.feedId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.feedItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FeedSubscriptionsTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $FeedSubscriptionsTable,
          FeedSubscription,
          $$FeedSubscriptionsTableFilterComposer,
          $$FeedSubscriptionsTableOrderingComposer,
          $$FeedSubscriptionsTableAnnotationComposer,
          $$FeedSubscriptionsTableCreateCompanionBuilder,
          $$FeedSubscriptionsTableUpdateCompanionBuilder,
          (FeedSubscription, $$FeedSubscriptionsTableReferences),
          FeedSubscription,
          PrefetchHooks Function({bool accountId, bool feedItemsRefs})
        > {
  $$FeedSubscriptionsTableTableManager(
    _$CourrierDatabase db,
    $FeedSubscriptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedSubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedSubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedSubscriptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> folder = const Value.absent(),
                Value<int> refreshIntervalMinutes = const Value.absent(),
                Value<DateTime?> lastFetched = const Value.absent(),
              }) => FeedSubscriptionsCompanion(
                id: id,
                accountId: accountId,
                url: url,
                title: title,
                folder: folder,
                refreshIntervalMinutes: refreshIntervalMinutes,
                lastFetched: lastFetched,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required String url,
                required String title,
                Value<String?> folder = const Value.absent(),
                Value<int> refreshIntervalMinutes = const Value.absent(),
                Value<DateTime?> lastFetched = const Value.absent(),
              }) => FeedSubscriptionsCompanion.insert(
                id: id,
                accountId: accountId,
                url: url,
                title: title,
                folder: folder,
                refreshIntervalMinutes: refreshIntervalMinutes,
                lastFetched: lastFetched,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FeedSubscriptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false, feedItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (feedItemsRefs) db.feedItems],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable:
                                    $$FeedSubscriptionsTableReferences
                                        ._accountIdTable(db),
                                referencedColumn:
                                    $$FeedSubscriptionsTableReferences
                                        ._accountIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (feedItemsRefs)
                    await $_getPrefetchedData<
                      FeedSubscription,
                      $FeedSubscriptionsTable,
                      FeedItem
                    >(
                      currentTable: table,
                      referencedTable: $$FeedSubscriptionsTableReferences
                          ._feedItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FeedSubscriptionsTableReferences(
                            db,
                            table,
                            p0,
                          ).feedItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.feedId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FeedSubscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $FeedSubscriptionsTable,
      FeedSubscription,
      $$FeedSubscriptionsTableFilterComposer,
      $$FeedSubscriptionsTableOrderingComposer,
      $$FeedSubscriptionsTableAnnotationComposer,
      $$FeedSubscriptionsTableCreateCompanionBuilder,
      $$FeedSubscriptionsTableUpdateCompanionBuilder,
      (FeedSubscription, $$FeedSubscriptionsTableReferences),
      FeedSubscription,
      PrefetchHooks Function({bool accountId, bool feedItemsRefs})
    >;
typedef $$FeedItemsTableCreateCompanionBuilder =
    FeedItemsCompanion Function({
      Value<int> id,
      required int feedId,
      required String guid,
      required String title,
      Value<String?> link,
      Value<String?> author,
      Value<String?> content,
      Value<DateTime?> publishedAt,
      Value<bool> read,
      Value<bool> starred,
    });
typedef $$FeedItemsTableUpdateCompanionBuilder =
    FeedItemsCompanion Function({
      Value<int> id,
      Value<int> feedId,
      Value<String> guid,
      Value<String> title,
      Value<String?> link,
      Value<String?> author,
      Value<String?> content,
      Value<DateTime?> publishedAt,
      Value<bool> read,
      Value<bool> starred,
    });

final class $$FeedItemsTableReferences
    extends BaseReferences<_$CourrierDatabase, $FeedItemsTable, FeedItem> {
  $$FeedItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FeedSubscriptionsTable _feedIdTable(_$CourrierDatabase db) => db
      .feedSubscriptions
      .createAlias('feed_items__feed_id__feed_subscriptions__id');

  $$FeedSubscriptionsTableProcessedTableManager get feedId {
    final $_column = $_itemColumn<int>('feed_id')!;

    final manager = $$FeedSubscriptionsTableTableManager(
      $_db,
      $_db.feedSubscriptions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_feedIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FeedItemsTableFilterComposer
    extends Composer<_$CourrierDatabase, $FeedItemsTable> {
  $$FeedItemsTableFilterComposer({
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

  ColumnFilters<String> get guid => $composableBuilder(
    column: $table.guid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get starred => $composableBuilder(
    column: $table.starred,
    builder: (column) => ColumnFilters(column),
  );

  $$FeedSubscriptionsTableFilterComposer get feedId {
    final $$FeedSubscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.feedId,
      referencedTable: $db.feedSubscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedSubscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.feedSubscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedItemsTableOrderingComposer
    extends Composer<_$CourrierDatabase, $FeedItemsTable> {
  $$FeedItemsTableOrderingComposer({
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

  ColumnOrderings<String> get guid => $composableBuilder(
    column: $table.guid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get starred => $composableBuilder(
    column: $table.starred,
    builder: (column) => ColumnOrderings(column),
  );

  $$FeedSubscriptionsTableOrderingComposer get feedId {
    final $$FeedSubscriptionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.feedId,
      referencedTable: $db.feedSubscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedSubscriptionsTableOrderingComposer(
            $db: $db,
            $table: $db.feedSubscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedItemsTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $FeedItemsTable> {
  $$FeedItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get guid =>
      $composableBuilder(column: $table.guid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get link =>
      $composableBuilder(column: $table.link, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get read =>
      $composableBuilder(column: $table.read, builder: (column) => column);

  GeneratedColumn<bool> get starred =>
      $composableBuilder(column: $table.starred, builder: (column) => column);

  $$FeedSubscriptionsTableAnnotationComposer get feedId {
    final $$FeedSubscriptionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.feedId,
          referencedTable: $db.feedSubscriptions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FeedSubscriptionsTableAnnotationComposer(
                $db: $db,
                $table: $db.feedSubscriptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$FeedItemsTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $FeedItemsTable,
          FeedItem,
          $$FeedItemsTableFilterComposer,
          $$FeedItemsTableOrderingComposer,
          $$FeedItemsTableAnnotationComposer,
          $$FeedItemsTableCreateCompanionBuilder,
          $$FeedItemsTableUpdateCompanionBuilder,
          (FeedItem, $$FeedItemsTableReferences),
          FeedItem,
          PrefetchHooks Function({bool feedId})
        > {
  $$FeedItemsTableTableManager(_$CourrierDatabase db, $FeedItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> feedId = const Value.absent(),
                Value<String> guid = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<bool> read = const Value.absent(),
                Value<bool> starred = const Value.absent(),
              }) => FeedItemsCompanion(
                id: id,
                feedId: feedId,
                guid: guid,
                title: title,
                link: link,
                author: author,
                content: content,
                publishedAt: publishedAt,
                read: read,
                starred: starred,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int feedId,
                required String guid,
                required String title,
                Value<String?> link = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<bool> read = const Value.absent(),
                Value<bool> starred = const Value.absent(),
              }) => FeedItemsCompanion.insert(
                id: id,
                feedId: feedId,
                guid: guid,
                title: title,
                link: link,
                author: author,
                content: content,
                publishedAt: publishedAt,
                read: read,
                starred: starred,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FeedItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({feedId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (feedId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.feedId,
                                referencedTable: $$FeedItemsTableReferences
                                    ._feedIdTable(db),
                                referencedColumn: $$FeedItemsTableReferences
                                    ._feedIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FeedItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $FeedItemsTable,
      FeedItem,
      $$FeedItemsTableFilterComposer,
      $$FeedItemsTableOrderingComposer,
      $$FeedItemsTableAnnotationComposer,
      $$FeedItemsTableCreateCompanionBuilder,
      $$FeedItemsTableUpdateCompanionBuilder,
      (FeedItem, $$FeedItemsTableReferences),
      FeedItem,
      PrefetchHooks Function({bool feedId})
    >;
typedef $$MailFoldersTableCreateCompanionBuilder =
    MailFoldersCompanion Function({
      Value<int> id,
      required int accountId,
      required String name,
      Value<String?> specialUse,
      Value<String?> delimiter,
      Value<int?> uidValidity,
      Value<int?> uidNext,
      Value<int?> highestModseq,
      Value<DateTime?> lastSyncedAt,
    });
typedef $$MailFoldersTableUpdateCompanionBuilder =
    MailFoldersCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<String> name,
      Value<String?> specialUse,
      Value<String?> delimiter,
      Value<int?> uidValidity,
      Value<int?> uidNext,
      Value<int?> highestModseq,
      Value<DateTime?> lastSyncedAt,
    });

final class $$MailFoldersTableReferences
    extends BaseReferences<_$CourrierDatabase, $MailFoldersTable, MailFolder> {
  $$MailFoldersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$CourrierDatabase db) =>
      db.accounts.createAlias('mail_folders__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MailMessagesTable, List<MailMessage>>
  _mailMessagesRefsTable(_$CourrierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.mailMessages,
        aliasName: 'mail_folders__id__mail_messages__folder_id',
      );

  $$MailMessagesTableProcessedTableManager get mailMessagesRefs {
    final manager = $$MailMessagesTableTableManager(
      $_db,
      $_db.mailMessages,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mailMessagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MailFoldersTableFilterComposer
    extends Composer<_$CourrierDatabase, $MailFoldersTable> {
  $$MailFoldersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialUse => $composableBuilder(
    column: $table.specialUse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get delimiter => $composableBuilder(
    column: $table.delimiter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uidValidity => $composableBuilder(
    column: $table.uidValidity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uidNext => $composableBuilder(
    column: $table.uidNext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get highestModseq => $composableBuilder(
    column: $table.highestModseq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mailMessagesRefs(
    Expression<bool> Function($$MailMessagesTableFilterComposer f) f,
  ) {
    final $$MailMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mailMessages,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MailMessagesTableFilterComposer(
            $db: $db,
            $table: $db.mailMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MailFoldersTableOrderingComposer
    extends Composer<_$CourrierDatabase, $MailFoldersTable> {
  $$MailFoldersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialUse => $composableBuilder(
    column: $table.specialUse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get delimiter => $composableBuilder(
    column: $table.delimiter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uidValidity => $composableBuilder(
    column: $table.uidValidity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uidNext => $composableBuilder(
    column: $table.uidNext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get highestModseq => $composableBuilder(
    column: $table.highestModseq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MailFoldersTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $MailFoldersTable> {
  $$MailFoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get specialUse => $composableBuilder(
    column: $table.specialUse,
    builder: (column) => column,
  );

  GeneratedColumn<String> get delimiter =>
      $composableBuilder(column: $table.delimiter, builder: (column) => column);

  GeneratedColumn<int> get uidValidity => $composableBuilder(
    column: $table.uidValidity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get uidNext =>
      $composableBuilder(column: $table.uidNext, builder: (column) => column);

  GeneratedColumn<int> get highestModseq => $composableBuilder(
    column: $table.highestModseq,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mailMessagesRefs<T extends Object>(
    Expression<T> Function($$MailMessagesTableAnnotationComposer a) f,
  ) {
    final $$MailMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mailMessages,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MailMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.mailMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MailFoldersTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $MailFoldersTable,
          MailFolder,
          $$MailFoldersTableFilterComposer,
          $$MailFoldersTableOrderingComposer,
          $$MailFoldersTableAnnotationComposer,
          $$MailFoldersTableCreateCompanionBuilder,
          $$MailFoldersTableUpdateCompanionBuilder,
          (MailFolder, $$MailFoldersTableReferences),
          MailFolder,
          PrefetchHooks Function({bool accountId, bool mailMessagesRefs})
        > {
  $$MailFoldersTableTableManager(_$CourrierDatabase db, $MailFoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MailFoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MailFoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MailFoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> specialUse = const Value.absent(),
                Value<String?> delimiter = const Value.absent(),
                Value<int?> uidValidity = const Value.absent(),
                Value<int?> uidNext = const Value.absent(),
                Value<int?> highestModseq = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => MailFoldersCompanion(
                id: id,
                accountId: accountId,
                name: name,
                specialUse: specialUse,
                delimiter: delimiter,
                uidValidity: uidValidity,
                uidNext: uidNext,
                highestModseq: highestModseq,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required String name,
                Value<String?> specialUse = const Value.absent(),
                Value<String?> delimiter = const Value.absent(),
                Value<int?> uidValidity = const Value.absent(),
                Value<int?> uidNext = const Value.absent(),
                Value<int?> highestModseq = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => MailFoldersCompanion.insert(
                id: id,
                accountId: accountId,
                name: name,
                specialUse: specialUse,
                delimiter: delimiter,
                uidValidity: uidValidity,
                uidNext: uidNext,
                highestModseq: highestModseq,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MailFoldersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({accountId = false, mailMessagesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mailMessagesRefs) db.mailMessages,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable:
                                        $$MailFoldersTableReferences
                                            ._accountIdTable(db),
                                    referencedColumn:
                                        $$MailFoldersTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mailMessagesRefs)
                        await $_getPrefetchedData<
                          MailFolder,
                          $MailFoldersTable,
                          MailMessage
                        >(
                          currentTable: table,
                          referencedTable: $$MailFoldersTableReferences
                              ._mailMessagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MailFoldersTableReferences(
                                db,
                                table,
                                p0,
                              ).mailMessagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.folderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MailFoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $MailFoldersTable,
      MailFolder,
      $$MailFoldersTableFilterComposer,
      $$MailFoldersTableOrderingComposer,
      $$MailFoldersTableAnnotationComposer,
      $$MailFoldersTableCreateCompanionBuilder,
      $$MailFoldersTableUpdateCompanionBuilder,
      (MailFolder, $$MailFoldersTableReferences),
      MailFolder,
      PrefetchHooks Function({bool accountId, bool mailMessagesRefs})
    >;
typedef $$MailMessagesTableCreateCompanionBuilder =
    MailMessagesCompanion Function({
      Value<int> id,
      required int folderId,
      required int uid,
      Value<String?> messageIdHeader,
      Value<String?> inReplyTo,
      Value<String?> referencesHeader,
      Value<String?> subject,
      Value<String?> fromAddress,
      Value<String?> toAddresses,
      Value<String?> ccAddresses,
      Value<String?> bccAddresses,
      Value<DateTime?> sentAt,
      Value<bool> seen,
      Value<bool> flagged,
      Value<bool> answered,
      Value<bool> hasAttachments,
      Value<bool> bodyDownloaded,
      Value<bool> remoteContentAllowed,
      Value<String?> snippet,
      Value<String?> bodyText,
      Value<String?> bodyHtml,
      Value<bool> trashed,
      Value<DateTime?> trashedAt,
      Value<DateTime> receivedAt,
    });
typedef $$MailMessagesTableUpdateCompanionBuilder =
    MailMessagesCompanion Function({
      Value<int> id,
      Value<int> folderId,
      Value<int> uid,
      Value<String?> messageIdHeader,
      Value<String?> inReplyTo,
      Value<String?> referencesHeader,
      Value<String?> subject,
      Value<String?> fromAddress,
      Value<String?> toAddresses,
      Value<String?> ccAddresses,
      Value<String?> bccAddresses,
      Value<DateTime?> sentAt,
      Value<bool> seen,
      Value<bool> flagged,
      Value<bool> answered,
      Value<bool> hasAttachments,
      Value<bool> bodyDownloaded,
      Value<bool> remoteContentAllowed,
      Value<String?> snippet,
      Value<String?> bodyText,
      Value<String?> bodyHtml,
      Value<bool> trashed,
      Value<DateTime?> trashedAt,
      Value<DateTime> receivedAt,
    });

final class $$MailMessagesTableReferences
    extends
        BaseReferences<_$CourrierDatabase, $MailMessagesTable, MailMessage> {
  $$MailMessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MailFoldersTable _folderIdTable(_$CourrierDatabase db) =>
      db.mailFolders.createAlias('mail_messages__folder_id__mail_folders__id');

  $$MailFoldersTableProcessedTableManager get folderId {
    final $_column = $_itemColumn<int>('folder_id')!;

    final manager = $$MailFoldersTableTableManager(
      $_db,
      $_db.mailFolders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MailAttachmentsTable, List<MailAttachment>>
  _mailAttachmentsRefsTable(_$CourrierDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.mailAttachments,
        aliasName: 'mail_messages__id__mail_attachments__message_id',
      );

  $$MailAttachmentsTableProcessedTableManager get mailAttachmentsRefs {
    final manager = $$MailAttachmentsTableTableManager(
      $_db,
      $_db.mailAttachments,
    ).filter((f) => f.messageId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _mailAttachmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MailMessagesTableFilterComposer
    extends Composer<_$CourrierDatabase, $MailMessagesTable> {
  $$MailMessagesTableFilterComposer({
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

  ColumnFilters<int> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageIdHeader => $composableBuilder(
    column: $table.messageIdHeader,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inReplyTo => $composableBuilder(
    column: $table.inReplyTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referencesHeader => $composableBuilder(
    column: $table.referencesHeader,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromAddress => $composableBuilder(
    column: $table.fromAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toAddresses => $composableBuilder(
    column: $table.toAddresses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ccAddresses => $composableBuilder(
    column: $table.ccAddresses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bccAddresses => $composableBuilder(
    column: $table.bccAddresses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get seen => $composableBuilder(
    column: $table.seen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get flagged => $composableBuilder(
    column: $table.flagged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get answered => $composableBuilder(
    column: $table.answered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasAttachments => $composableBuilder(
    column: $table.hasAttachments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bodyDownloaded => $composableBuilder(
    column: $table.bodyDownloaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remoteContentAllowed => $composableBuilder(
    column: $table.remoteContentAllowed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snippet => $composableBuilder(
    column: $table.snippet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyText => $composableBuilder(
    column: $table.bodyText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyHtml => $composableBuilder(
    column: $table.bodyHtml,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get trashed => $composableBuilder(
    column: $table.trashed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MailFoldersTableFilterComposer get folderId {
    final $$MailFoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.mailFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MailFoldersTableFilterComposer(
            $db: $db,
            $table: $db.mailFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mailAttachmentsRefs(
    Expression<bool> Function($$MailAttachmentsTableFilterComposer f) f,
  ) {
    final $$MailAttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mailAttachments,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MailAttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.mailAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MailMessagesTableOrderingComposer
    extends Composer<_$CourrierDatabase, $MailMessagesTable> {
  $$MailMessagesTableOrderingComposer({
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

  ColumnOrderings<int> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageIdHeader => $composableBuilder(
    column: $table.messageIdHeader,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inReplyTo => $composableBuilder(
    column: $table.inReplyTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referencesHeader => $composableBuilder(
    column: $table.referencesHeader,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromAddress => $composableBuilder(
    column: $table.fromAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toAddresses => $composableBuilder(
    column: $table.toAddresses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ccAddresses => $composableBuilder(
    column: $table.ccAddresses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bccAddresses => $composableBuilder(
    column: $table.bccAddresses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get seen => $composableBuilder(
    column: $table.seen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get flagged => $composableBuilder(
    column: $table.flagged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get answered => $composableBuilder(
    column: $table.answered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasAttachments => $composableBuilder(
    column: $table.hasAttachments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bodyDownloaded => $composableBuilder(
    column: $table.bodyDownloaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remoteContentAllowed => $composableBuilder(
    column: $table.remoteContentAllowed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snippet => $composableBuilder(
    column: $table.snippet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyText => $composableBuilder(
    column: $table.bodyText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyHtml => $composableBuilder(
    column: $table.bodyHtml,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get trashed => $composableBuilder(
    column: $table.trashed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MailFoldersTableOrderingComposer get folderId {
    final $$MailFoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.mailFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MailFoldersTableOrderingComposer(
            $db: $db,
            $table: $db.mailFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MailMessagesTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $MailMessagesTable> {
  $$MailMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get messageIdHeader => $composableBuilder(
    column: $table.messageIdHeader,
    builder: (column) => column,
  );

  GeneratedColumn<String> get inReplyTo =>
      $composableBuilder(column: $table.inReplyTo, builder: (column) => column);

  GeneratedColumn<String> get referencesHeader => $composableBuilder(
    column: $table.referencesHeader,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get fromAddress => $composableBuilder(
    column: $table.fromAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toAddresses => $composableBuilder(
    column: $table.toAddresses,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ccAddresses => $composableBuilder(
    column: $table.ccAddresses,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bccAddresses => $composableBuilder(
    column: $table.bccAddresses,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<bool> get seen =>
      $composableBuilder(column: $table.seen, builder: (column) => column);

  GeneratedColumn<bool> get flagged =>
      $composableBuilder(column: $table.flagged, builder: (column) => column);

  GeneratedColumn<bool> get answered =>
      $composableBuilder(column: $table.answered, builder: (column) => column);

  GeneratedColumn<bool> get hasAttachments => $composableBuilder(
    column: $table.hasAttachments,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get bodyDownloaded => $composableBuilder(
    column: $table.bodyDownloaded,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get remoteContentAllowed => $composableBuilder(
    column: $table.remoteContentAllowed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get snippet =>
      $composableBuilder(column: $table.snippet, builder: (column) => column);

  GeneratedColumn<String> get bodyText =>
      $composableBuilder(column: $table.bodyText, builder: (column) => column);

  GeneratedColumn<String> get bodyHtml =>
      $composableBuilder(column: $table.bodyHtml, builder: (column) => column);

  GeneratedColumn<bool> get trashed =>
      $composableBuilder(column: $table.trashed, builder: (column) => column);

  GeneratedColumn<DateTime> get trashedAt =>
      $composableBuilder(column: $table.trashedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  $$MailFoldersTableAnnotationComposer get folderId {
    final $$MailFoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.mailFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MailFoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.mailFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mailAttachmentsRefs<T extends Object>(
    Expression<T> Function($$MailAttachmentsTableAnnotationComposer a) f,
  ) {
    final $$MailAttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mailAttachments,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MailAttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.mailAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MailMessagesTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $MailMessagesTable,
          MailMessage,
          $$MailMessagesTableFilterComposer,
          $$MailMessagesTableOrderingComposer,
          $$MailMessagesTableAnnotationComposer,
          $$MailMessagesTableCreateCompanionBuilder,
          $$MailMessagesTableUpdateCompanionBuilder,
          (MailMessage, $$MailMessagesTableReferences),
          MailMessage,
          PrefetchHooks Function({bool folderId, bool mailAttachmentsRefs})
        > {
  $$MailMessagesTableTableManager(
    _$CourrierDatabase db,
    $MailMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MailMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MailMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MailMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> folderId = const Value.absent(),
                Value<int> uid = const Value.absent(),
                Value<String?> messageIdHeader = const Value.absent(),
                Value<String?> inReplyTo = const Value.absent(),
                Value<String?> referencesHeader = const Value.absent(),
                Value<String?> subject = const Value.absent(),
                Value<String?> fromAddress = const Value.absent(),
                Value<String?> toAddresses = const Value.absent(),
                Value<String?> ccAddresses = const Value.absent(),
                Value<String?> bccAddresses = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
                Value<bool> seen = const Value.absent(),
                Value<bool> flagged = const Value.absent(),
                Value<bool> answered = const Value.absent(),
                Value<bool> hasAttachments = const Value.absent(),
                Value<bool> bodyDownloaded = const Value.absent(),
                Value<bool> remoteContentAllowed = const Value.absent(),
                Value<String?> snippet = const Value.absent(),
                Value<String?> bodyText = const Value.absent(),
                Value<String?> bodyHtml = const Value.absent(),
                Value<bool> trashed = const Value.absent(),
                Value<DateTime?> trashedAt = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
              }) => MailMessagesCompanion(
                id: id,
                folderId: folderId,
                uid: uid,
                messageIdHeader: messageIdHeader,
                inReplyTo: inReplyTo,
                referencesHeader: referencesHeader,
                subject: subject,
                fromAddress: fromAddress,
                toAddresses: toAddresses,
                ccAddresses: ccAddresses,
                bccAddresses: bccAddresses,
                sentAt: sentAt,
                seen: seen,
                flagged: flagged,
                answered: answered,
                hasAttachments: hasAttachments,
                bodyDownloaded: bodyDownloaded,
                remoteContentAllowed: remoteContentAllowed,
                snippet: snippet,
                bodyText: bodyText,
                bodyHtml: bodyHtml,
                trashed: trashed,
                trashedAt: trashedAt,
                receivedAt: receivedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int folderId,
                required int uid,
                Value<String?> messageIdHeader = const Value.absent(),
                Value<String?> inReplyTo = const Value.absent(),
                Value<String?> referencesHeader = const Value.absent(),
                Value<String?> subject = const Value.absent(),
                Value<String?> fromAddress = const Value.absent(),
                Value<String?> toAddresses = const Value.absent(),
                Value<String?> ccAddresses = const Value.absent(),
                Value<String?> bccAddresses = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
                Value<bool> seen = const Value.absent(),
                Value<bool> flagged = const Value.absent(),
                Value<bool> answered = const Value.absent(),
                Value<bool> hasAttachments = const Value.absent(),
                Value<bool> bodyDownloaded = const Value.absent(),
                Value<bool> remoteContentAllowed = const Value.absent(),
                Value<String?> snippet = const Value.absent(),
                Value<String?> bodyText = const Value.absent(),
                Value<String?> bodyHtml = const Value.absent(),
                Value<bool> trashed = const Value.absent(),
                Value<DateTime?> trashedAt = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
              }) => MailMessagesCompanion.insert(
                id: id,
                folderId: folderId,
                uid: uid,
                messageIdHeader: messageIdHeader,
                inReplyTo: inReplyTo,
                referencesHeader: referencesHeader,
                subject: subject,
                fromAddress: fromAddress,
                toAddresses: toAddresses,
                ccAddresses: ccAddresses,
                bccAddresses: bccAddresses,
                sentAt: sentAt,
                seen: seen,
                flagged: flagged,
                answered: answered,
                hasAttachments: hasAttachments,
                bodyDownloaded: bodyDownloaded,
                remoteContentAllowed: remoteContentAllowed,
                snippet: snippet,
                bodyText: bodyText,
                bodyHtml: bodyHtml,
                trashed: trashed,
                trashedAt: trashedAt,
                receivedAt: receivedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MailMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({folderId = false, mailAttachmentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mailAttachmentsRefs) db.mailAttachments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (folderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.folderId,
                                    referencedTable:
                                        $$MailMessagesTableReferences
                                            ._folderIdTable(db),
                                    referencedColumn:
                                        $$MailMessagesTableReferences
                                            ._folderIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mailAttachmentsRefs)
                        await $_getPrefetchedData<
                          MailMessage,
                          $MailMessagesTable,
                          MailAttachment
                        >(
                          currentTable: table,
                          referencedTable: $$MailMessagesTableReferences
                              ._mailAttachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MailMessagesTableReferences(
                                db,
                                table,
                                p0,
                              ).mailAttachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.messageId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MailMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $MailMessagesTable,
      MailMessage,
      $$MailMessagesTableFilterComposer,
      $$MailMessagesTableOrderingComposer,
      $$MailMessagesTableAnnotationComposer,
      $$MailMessagesTableCreateCompanionBuilder,
      $$MailMessagesTableUpdateCompanionBuilder,
      (MailMessage, $$MailMessagesTableReferences),
      MailMessage,
      PrefetchHooks Function({bool folderId, bool mailAttachmentsRefs})
    >;
typedef $$MailAttachmentsTableCreateCompanionBuilder =
    MailAttachmentsCompanion Function({
      Value<int> id,
      required int messageId,
      required String filename,
      required String mimeType,
      required int sizeBytes,
      Value<String?> contentId,
      Value<String?> localPath,
      Value<bool> downloaded,
    });
typedef $$MailAttachmentsTableUpdateCompanionBuilder =
    MailAttachmentsCompanion Function({
      Value<int> id,
      Value<int> messageId,
      Value<String> filename,
      Value<String> mimeType,
      Value<int> sizeBytes,
      Value<String?> contentId,
      Value<String?> localPath,
      Value<bool> downloaded,
    });

final class $$MailAttachmentsTableReferences
    extends
        BaseReferences<
          _$CourrierDatabase,
          $MailAttachmentsTable,
          MailAttachment
        > {
  $$MailAttachmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MailMessagesTable _messageIdTable(_$CourrierDatabase db) => db
      .mailMessages
      .createAlias('mail_attachments__message_id__mail_messages__id');

  $$MailMessagesTableProcessedTableManager get messageId {
    final $_column = $_itemColumn<int>('message_id')!;

    final manager = $$MailMessagesTableTableManager(
      $_db,
      $_db.mailMessages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_messageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MailAttachmentsTableFilterComposer
    extends Composer<_$CourrierDatabase, $MailAttachmentsTable> {
  $$MailAttachmentsTableFilterComposer({
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

  ColumnFilters<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get downloaded => $composableBuilder(
    column: $table.downloaded,
    builder: (column) => ColumnFilters(column),
  );

  $$MailMessagesTableFilterComposer get messageId {
    final $$MailMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.mailMessages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MailMessagesTableFilterComposer(
            $db: $db,
            $table: $db.mailMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MailAttachmentsTableOrderingComposer
    extends Composer<_$CourrierDatabase, $MailAttachmentsTable> {
  $$MailAttachmentsTableOrderingComposer({
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

  ColumnOrderings<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get downloaded => $composableBuilder(
    column: $table.downloaded,
    builder: (column) => ColumnOrderings(column),
  );

  $$MailMessagesTableOrderingComposer get messageId {
    final $$MailMessagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.mailMessages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MailMessagesTableOrderingComposer(
            $db: $db,
            $table: $db.mailMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MailAttachmentsTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $MailAttachmentsTable> {
  $$MailAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<bool> get downloaded => $composableBuilder(
    column: $table.downloaded,
    builder: (column) => column,
  );

  $$MailMessagesTableAnnotationComposer get messageId {
    final $$MailMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.mailMessages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MailMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.mailMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MailAttachmentsTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $MailAttachmentsTable,
          MailAttachment,
          $$MailAttachmentsTableFilterComposer,
          $$MailAttachmentsTableOrderingComposer,
          $$MailAttachmentsTableAnnotationComposer,
          $$MailAttachmentsTableCreateCompanionBuilder,
          $$MailAttachmentsTableUpdateCompanionBuilder,
          (MailAttachment, $$MailAttachmentsTableReferences),
          MailAttachment,
          PrefetchHooks Function({bool messageId})
        > {
  $$MailAttachmentsTableTableManager(
    _$CourrierDatabase db,
    $MailAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MailAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MailAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MailAttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> messageId = const Value.absent(),
                Value<String> filename = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String?> contentId = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<bool> downloaded = const Value.absent(),
              }) => MailAttachmentsCompanion(
                id: id,
                messageId: messageId,
                filename: filename,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                contentId: contentId,
                localPath: localPath,
                downloaded: downloaded,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int messageId,
                required String filename,
                required String mimeType,
                required int sizeBytes,
                Value<String?> contentId = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<bool> downloaded = const Value.absent(),
              }) => MailAttachmentsCompanion.insert(
                id: id,
                messageId: messageId,
                filename: filename,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                contentId: contentId,
                localPath: localPath,
                downloaded: downloaded,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MailAttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({messageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (messageId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.messageId,
                                referencedTable:
                                    $$MailAttachmentsTableReferences
                                        ._messageIdTable(db),
                                referencedColumn:
                                    $$MailAttachmentsTableReferences
                                        ._messageIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MailAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $MailAttachmentsTable,
      MailAttachment,
      $$MailAttachmentsTableFilterComposer,
      $$MailAttachmentsTableOrderingComposer,
      $$MailAttachmentsTableAnnotationComposer,
      $$MailAttachmentsTableCreateCompanionBuilder,
      $$MailAttachmentsTableUpdateCompanionBuilder,
      (MailAttachment, $$MailAttachmentsTableReferences),
      MailAttachment,
      PrefetchHooks Function({bool messageId})
    >;
typedef $$PendingChangesTableCreateCompanionBuilder =
    PendingChangesCompanion Function({
      Value<int> id,
      required int accountId,
      required String entityTable,
      required int entityId,
      required String operation,
      Value<String?> baseEtag,
      Value<String?> payload,
      Value<int> attempts,
      Value<String?> lastError,
      Value<DateTime> createdAt,
    });
typedef $$PendingChangesTableUpdateCompanionBuilder =
    PendingChangesCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<String> entityTable,
      Value<int> entityId,
      Value<String> operation,
      Value<String?> baseEtag,
      Value<String?> payload,
      Value<int> attempts,
      Value<String?> lastError,
      Value<DateTime> createdAt,
    });

final class $$PendingChangesTableReferences
    extends
        BaseReferences<
          _$CourrierDatabase,
          $PendingChangesTable,
          PendingChange
        > {
  $$PendingChangesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$CourrierDatabase db) =>
      db.accounts.createAlias('pending_changes__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PendingChangesTableFilterComposer
    extends Composer<_$CourrierDatabase, $PendingChangesTable> {
  $$PendingChangesTableFilterComposer({
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

  ColumnFilters<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseEtag => $composableBuilder(
    column: $table.baseEtag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PendingChangesTableOrderingComposer
    extends Composer<_$CourrierDatabase, $PendingChangesTable> {
  $$PendingChangesTableOrderingComposer({
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

  ColumnOrderings<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseEtag => $composableBuilder(
    column: $table.baseEtag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PendingChangesTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $PendingChangesTable> {
  $$PendingChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get baseEtag =>
      $composableBuilder(column: $table.baseEtag, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PendingChangesTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $PendingChangesTable,
          PendingChange,
          $$PendingChangesTableFilterComposer,
          $$PendingChangesTableOrderingComposer,
          $$PendingChangesTableAnnotationComposer,
          $$PendingChangesTableCreateCompanionBuilder,
          $$PendingChangesTableUpdateCompanionBuilder,
          (PendingChange, $$PendingChangesTableReferences),
          PendingChange,
          PrefetchHooks Function({bool accountId})
        > {
  $$PendingChangesTableTableManager(
    _$CourrierDatabase db,
    $PendingChangesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingChangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingChangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingChangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> entityTable = const Value.absent(),
                Value<int> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String?> baseEtag = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingChangesCompanion(
                id: id,
                accountId: accountId,
                entityTable: entityTable,
                entityId: entityId,
                operation: operation,
                baseEtag: baseEtag,
                payload: payload,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required String entityTable,
                required int entityId,
                required String operation,
                Value<String?> baseEtag = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingChangesCompanion.insert(
                id: id,
                accountId: accountId,
                entityTable: entityTable,
                entityId: entityId,
                operation: operation,
                baseEtag: baseEtag,
                payload: payload,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PendingChangesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$PendingChangesTableReferences
                                    ._accountIdTable(db),
                                referencedColumn:
                                    $$PendingChangesTableReferences
                                        ._accountIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PendingChangesTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $PendingChangesTable,
      PendingChange,
      $$PendingChangesTableFilterComposer,
      $$PendingChangesTableOrderingComposer,
      $$PendingChangesTableAnnotationComposer,
      $$PendingChangesTableCreateCompanionBuilder,
      $$PendingChangesTableUpdateCompanionBuilder,
      (PendingChange, $$PendingChangesTableReferences),
      PendingChange,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$SyncConflictsTableCreateCompanionBuilder =
    SyncConflictsCompanion Function({
      Value<int> id,
      required int accountId,
      required String entityTable,
      required int entityId,
      required String localPayload,
      required String serverPayload,
      Value<String?> serverEtag,
      Value<String?> resolution,
      Value<DateTime> detectedAt,
      Value<DateTime?> resolvedAt,
    });
typedef $$SyncConflictsTableUpdateCompanionBuilder =
    SyncConflictsCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<String> entityTable,
      Value<int> entityId,
      Value<String> localPayload,
      Value<String> serverPayload,
      Value<String?> serverEtag,
      Value<String?> resolution,
      Value<DateTime> detectedAt,
      Value<DateTime?> resolvedAt,
    });

final class $$SyncConflictsTableReferences
    extends
        BaseReferences<_$CourrierDatabase, $SyncConflictsTable, SyncConflict> {
  $$SyncConflictsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$CourrierDatabase db) =>
      db.accounts.createAlias('sync_conflicts__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SyncConflictsTableFilterComposer
    extends Composer<_$CourrierDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableFilterComposer({
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

  ColumnFilters<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPayload => $composableBuilder(
    column: $table.localPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverPayload => $composableBuilder(
    column: $table.serverPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverEtag => $composableBuilder(
    column: $table.serverEtag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncConflictsTableOrderingComposer
    extends Composer<_$CourrierDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableOrderingComposer({
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

  ColumnOrderings<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPayload => $composableBuilder(
    column: $table.localPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverPayload => $composableBuilder(
    column: $table.serverPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverEtag => $composableBuilder(
    column: $table.serverEtag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncConflictsTableAnnotationComposer
    extends Composer<_$CourrierDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get localPayload => $composableBuilder(
    column: $table.localPayload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverPayload => $composableBuilder(
    column: $table.serverPayload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverEtag => $composableBuilder(
    column: $table.serverEtag,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncConflictsTableTableManager
    extends
        RootTableManager<
          _$CourrierDatabase,
          $SyncConflictsTable,
          SyncConflict,
          $$SyncConflictsTableFilterComposer,
          $$SyncConflictsTableOrderingComposer,
          $$SyncConflictsTableAnnotationComposer,
          $$SyncConflictsTableCreateCompanionBuilder,
          $$SyncConflictsTableUpdateCompanionBuilder,
          (SyncConflict, $$SyncConflictsTableReferences),
          SyncConflict,
          PrefetchHooks Function({bool accountId})
        > {
  $$SyncConflictsTableTableManager(
    _$CourrierDatabase db,
    $SyncConflictsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncConflictsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncConflictsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncConflictsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> entityTable = const Value.absent(),
                Value<int> entityId = const Value.absent(),
                Value<String> localPayload = const Value.absent(),
                Value<String> serverPayload = const Value.absent(),
                Value<String?> serverEtag = const Value.absent(),
                Value<String?> resolution = const Value.absent(),
                Value<DateTime> detectedAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
              }) => SyncConflictsCompanion(
                id: id,
                accountId: accountId,
                entityTable: entityTable,
                entityId: entityId,
                localPayload: localPayload,
                serverPayload: serverPayload,
                serverEtag: serverEtag,
                resolution: resolution,
                detectedAt: detectedAt,
                resolvedAt: resolvedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required String entityTable,
                required int entityId,
                required String localPayload,
                required String serverPayload,
                Value<String?> serverEtag = const Value.absent(),
                Value<String?> resolution = const Value.absent(),
                Value<DateTime> detectedAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
              }) => SyncConflictsCompanion.insert(
                id: id,
                accountId: accountId,
                entityTable: entityTable,
                entityId: entityId,
                localPayload: localPayload,
                serverPayload: serverPayload,
                serverEtag: serverEtag,
                resolution: resolution,
                detectedAt: detectedAt,
                resolvedAt: resolvedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SyncConflictsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$SyncConflictsTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$SyncConflictsTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SyncConflictsTableProcessedTableManager =
    ProcessedTableManager<
      _$CourrierDatabase,
      $SyncConflictsTable,
      SyncConflict,
      $$SyncConflictsTableFilterComposer,
      $$SyncConflictsTableOrderingComposer,
      $$SyncConflictsTableAnnotationComposer,
      $$SyncConflictsTableCreateCompanionBuilder,
      $$SyncConflictsTableUpdateCompanionBuilder,
      (SyncConflict, $$SyncConflictsTableReferences),
      SyncConflict,
      PrefetchHooks Function({bool accountId})
    >;

class $CourrierDatabaseManager {
  final _$CourrierDatabase _db;
  $CourrierDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CollectionsTableTableManager get collections =>
      $$CollectionsTableTableManager(_db, _db.collections);
  $$CalendarEventsTableTableManager get calendarEvents =>
      $$CalendarEventsTableTableManager(_db, _db.calendarEvents);
  $$EventRemindersTableTableManager get eventReminders =>
      $$EventRemindersTableTableManager(_db, _db.eventReminders);
  $$EventRecurrenceOverridesTableTableManager get eventRecurrenceOverrides =>
      $$EventRecurrenceOverridesTableTableManager(
        _db,
        _db.eventRecurrenceOverrides,
      );
  $$ContactCardsTableTableManager get contactCards =>
      $$ContactCardsTableTableManager(_db, _db.contactCards);
  $$ContactGroupsTableTableManager get contactGroups =>
      $$ContactGroupsTableTableManager(_db, _db.contactGroups);
  $$ContactGroupMembersTableTableManager get contactGroupMembers =>
      $$ContactGroupMembersTableTableManager(_db, _db.contactGroupMembers);
  $$TodoItemsTableTableManager get todoItems =>
      $$TodoItemsTableTableManager(_db, _db.todoItems);
  $$NoteItemsTableTableManager get noteItems =>
      $$NoteItemsTableTableManager(_db, _db.noteItems);
  $$FeedSubscriptionsTableTableManager get feedSubscriptions =>
      $$FeedSubscriptionsTableTableManager(_db, _db.feedSubscriptions);
  $$FeedItemsTableTableManager get feedItems =>
      $$FeedItemsTableTableManager(_db, _db.feedItems);
  $$MailFoldersTableTableManager get mailFolders =>
      $$MailFoldersTableTableManager(_db, _db.mailFolders);
  $$MailMessagesTableTableManager get mailMessages =>
      $$MailMessagesTableTableManager(_db, _db.mailMessages);
  $$MailAttachmentsTableTableManager get mailAttachments =>
      $$MailAttachmentsTableTableManager(_db, _db.mailAttachments);
  $$PendingChangesTableTableManager get pendingChanges =>
      $$PendingChangesTableTableManager(_db, _db.pendingChanges);
  $$SyncConflictsTableTableManager get syncConflicts =>
      $$SyncConflictsTableTableManager(_db, _db.syncConflicts);
}
