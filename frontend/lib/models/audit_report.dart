class AuditRecord {
  final int id;
  final DateTime timestamp;
  final String table;
  final int recordId;
  final String action;
  final String user;
  final String changes;
  final Map<String, dynamic>? oldData;
  final Map<String, dynamic>? newData;

  const AuditRecord({
    required this.id,
    required this.timestamp,
    required this.table,
    required this.recordId,
    required this.action,
    required this.user,
    required this.changes,
    this.oldData,
    this.newData,
  });

  factory AuditRecord.fromJson(Map<String, dynamic> json) => AuditRecord(
        id: json['id'] as int,
        timestamp: DateTime.parse(json['timestamp'] as String),
        table: json['table'] as String,
        recordId: json['record_id'] as int,
        action: json['action'] as String,
        user: json['user'] as String,
        changes: json['changes'] as String,
        oldData: json['old_data'] as Map<String, dynamic>?,
        newData: json['new_data'] as Map<String, dynamic>?,
      );

  /// Lower-case text used for client-side search.
  String get searchText =>
      '$table $action $user $changes #$recordId'.toLowerCase();
}

class AuditReport {
  final DateTime startDate;
  final DateTime endDate;
  final String generatedAt;
  final int total;
  final Map<String, int> byAction;
  final Map<String, int> byTable;
  final Map<String, int> byUser;
  final List<AuditRecord> records;

  const AuditReport({
    required this.startDate,
    required this.endDate,
    required this.generatedAt,
    required this.total,
    required this.byAction,
    required this.byTable,
    required this.byUser,
    required this.records,
  });

  static Map<String, int> _counts(dynamic json) =>
      (json as Map<String, dynamic>).map((k, v) => MapEntry(k, v as int));

  factory AuditReport.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>;
    return AuditReport(
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      generatedAt: json['generated_at'] as String,
      total: summary['total'] as int,
      byAction: _counts(summary['by_action']),
      byTable: _counts(summary['by_table']),
      byUser: _counts(summary['by_user']),
      records: (json['records'] as List)
          .map((e) => AuditRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
