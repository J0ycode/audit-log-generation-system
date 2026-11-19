import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../config.dart';
import '../models/audit_report.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  Map<String, String> _query(DateTimeRange range, String? table, String? action) => {
        'start_date': _dateFormat.format(range.start),
        'end_date': _dateFormat.format(range.end),
        if (table != null) 'table': table,
        if (action != null) 'action': action,
      };

  Future<bool> isHealthy() async {
    try {
      final res = await _client.get(Uri.parse('$apiBaseUrl/api/health'));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<AuditReport> fetchReport(DateTimeRange range, {String? table, String? action}) async {
    final uri = Uri.parse('$apiBaseUrl/api/report')
        .replace(queryParameters: _query(range, table, action));
    final http.Response response;
    try {
      response = await _client.get(uri);
    } catch (_) {
      throw ApiException('Cannot reach the server at $apiBaseUrl. Make sure the backend is running.');
    }
    if (response.statusCode != 200) {
      throw ApiException(_errorDetail(response));
    }
    return AuditReport.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  String _errorDetail(http.Response response) {
    try {
      final detail = (jsonDecode(response.body) as Map<String, dynamic>)['detail'];
      if (detail is String) return detail;
    } on FormatException {
      // Body is not JSON; fall through to the generic message.
    }
    return 'The server returned an error (HTTP ${response.statusCode}).';
  }

  Uri downloadUri(DateTimeRange range, String format, {String? table, String? action}) =>
      Uri.parse('$apiBaseUrl/api/report/download')
          .replace(queryParameters: {..._query(range, table, action), 'format': format});

  Uri get docsUri => Uri.parse('$apiBaseUrl/docs');
}
