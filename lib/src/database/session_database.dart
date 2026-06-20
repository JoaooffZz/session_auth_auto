import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/auth_token.dart';

part 'session_database.g.dart';

class SessionTokens extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get accessToken => text()();
  TextColumn get refreshToken => text().nullable()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  DateTimeColumn get lastRefreshedAt => dateTime().nullable()();
  DateTimeColumn get nextScheduledRefreshAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class SessionUsers extends Table {
  TextColumn get id => text()();
  TextColumn get metadataJson => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class RefreshLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get triggeredBy => text()();
  BoolColumn get success => boolean()();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get attemptedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [SessionTokens, SessionUsers, RefreshLogs])
class SessionDatabase extends _$SessionDatabase {
  SessionDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  static SessionDatabase create({required String databaseName}) {
    return SessionDatabase(LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, databaseName));
      return NativeDatabase(file);
    }));
  }

  // --- Operações de Token ---

  Future<AuthToken?> getActiveToken() async {
    final query = select(sessionTokens)..where((t) => t.id.equals(1));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return AuthToken(
      accessToken: row.accessToken,
      refreshToken: row.refreshToken,
      expiresAt: row.expiresAt,
      lastRefreshedAt: row.lastRefreshedAt,
      nextScheduledRefreshAt: row.nextScheduledRefreshAt,
    );
  }

  Future<void> saveToken(AuthToken token) async {
    await into(sessionTokens).insertOnConflictUpdate(
      SessionTokensCompanion(
        id: const Value(1),
        accessToken: Value(token.accessToken),
        refreshToken: Value(token.refreshToken),
        expiresAt: Value(token.expiresAt),
        lastRefreshedAt: Value(token.lastRefreshedAt),
        nextScheduledRefreshAt: Value(token.nextScheduledRefreshAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteToken() async {
    await (delete(sessionTokens)..where((t) => t.id.equals(1))).go();
  }

  // --- Operações de Usuário ---

  Future<Map<String, String>?> getUserMetadata(String userId) async {
    final query = select(sessionUsers)..where((u) => u.id.equals(userId));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    try {
      final Map<String, dynamic> decoded = json.decode(row.metadataJson) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUserMetadata(String userId, Map<String, String> metadata) async {
    final jsonStr = json.encode(metadata);
    await into(sessionUsers).insertOnConflictUpdate(
      SessionUsersCompanion(
        id: Value(userId),
        metadataJson: Value(jsonStr),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteUserMetadata(String userId) async {
    await (delete(sessionUsers)..where((u) => u.id.equals(userId))).go();
  }

  // --- Operações de Log ---

  Future<void> insertRefreshLog(String triggeredBy, bool success, String? errorMessage, {int maxLogEntries = 50}) async {
    await into(refreshLogs).insert(
      RefreshLogsCompanion.insert(
        triggeredBy: triggeredBy,
        success: success,
        errorMessage: Value(errorMessage),
        attemptedAt: Value(DateTime.now()),
      ),
    );
    await pruneLogs(maxLogEntries);
  }

  Future<void> pruneLogs(int maxLogEntries) async {
    final countQuery = select(refreshLogs);
    final logs = await countQuery.get();
    if (logs.length > maxLogEntries) {
      // Ordena pela data/hora da tentativa
      logs.sort((a, b) => a.attemptedAt.compareTo(b.attemptedAt));
      final logsToDeleteCount = logs.length - maxLogEntries;
      for (var i = 0; i < logsToDeleteCount; i++) {
        await (delete(refreshLogs)..where((l) => l.id.equals(logs[i].id))).go();
      }
    }
  }

  Future<List<RefreshLog>> getRefreshLogs() async {
    final query = select(refreshLogs)..orderBy([(t) => OrderingTerm.desc(t.attemptedAt)]);
    return await query.get();
  }
}
