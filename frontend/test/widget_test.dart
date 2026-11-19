import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:audit_dashboard/screens/dashboard_screen.dart';
import 'package:audit_dashboard/services/api_service.dart';
import 'package:audit_dashboard/theme/app_theme.dart';

final _report = {
  'title': 'Audit Log Report',
  'start_date': '2026-11-01',
  'end_date': '2026-11-18',
  'filters': {'table': null, 'action': null},
  'generated_at': '2026-11-18 10:00:00',
  'summary': {
    'total': 3,
    'by_action': {'INSERT': 1, 'UPDATE': 1, 'DELETE': 1},
    'by_table': {'loans': 2, 'customers': 1},
    'by_user': {'admin': 2, 'ravi.kumar': 1},
  },
  'records': [
    {
      'id': 1, 'timestamp': '2026-11-02 09:15:00', 'table': 'customers', 'record_id': 1,
      'action': 'INSERT', 'user': 'admin', 'changes': 'Created: name=Test User',
      'old_data': null, 'new_data': {'id': 1, 'name': 'Test User'},
    },
    {
      'id': 2, 'timestamp': '2026-11-03 11:20:00', 'table': 'loans', 'record_id': 4,
      'action': 'UPDATE', 'user': 'ravi.kumar', 'changes': 'status: Pending -> Approved',
      'old_data': {'id': 4, 'status': 'Pending'}, 'new_data': {'id': 4, 'status': 'Approved'},
    },
    {
      'id': 3, 'timestamp': '2026-11-04 16:45:00', 'table': 'loans', 'record_id': 7,
      'action': 'DELETE', 'user': 'admin', 'changes': 'Deleted: status=Pending',
      'old_data': {'id': 7, 'status': 'Pending'}, 'new_data': null,
    },
  ],
};

ApiService _fakeApi() => ApiService(
      client: MockClient((request) async {
        if (request.url.path == '/api/health') return http.Response('{"status":"ok"}', 200);
        return http.Response(jsonEncode(_report), 200);
      }),
    );

Future<void> _pump(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.light(useGoogleFonts: false),
    home: DashboardScreen(api: _fakeApi()),
  ));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Desktop layout shows sidebar, KPIs and records', (tester) async {
    await _pump(tester, const Size(1440, 1400));

    expect(find.text('AuditTrail'), findsOneWidget);
    expect(find.text('API connected'), findsOneWidget);
    expect(find.text('Audit Log Reports'), findsWidgets);
    expect(find.text('Total activity'), findsOneWidget);
    expect(find.text('status: Pending -> Approved'), findsOneWidget);
    expect(find.text('3 entries · select a row to see full details'), findsOneWidget);
  });

  testWidgets('Search filters the activity table', (tester) async {
    await _pump(tester, const Size(1440, 1400));

    await tester.enterText(find.byType(TextField), 'ravi');
    await tester.pumpAndSettle();

    expect(find.text('1 entries · select a row to see full details'), findsOneWidget);
  });

  testWidgets('Selecting a row opens the before/after details', (tester) async {
    await _pump(tester, const Size(1440, 1400));

    await tester.tap(find.text('status: Pending -> Approved'));
    await tester.pumpAndSettle();

    expect(find.text('BEFORE'), findsOneWidget);
    expect(find.text('Approved'), findsOneWidget);
  });

  testWidgets('Phone layout renders without overflow', (tester) async {
    await _pump(tester, const Size(390, 2600));

    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.text('Total activity'), findsOneWidget);
  });
}
