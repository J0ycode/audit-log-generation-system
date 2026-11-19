import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/audit_report.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/audit_table.dart';
import '../widgets/filter_bar.dart';
import '../widgets/record_detail_dialog.dart';
import '../widgets/stat_cards.dart';

class DashboardScreen extends StatefulWidget {
  final ApiService? api;

  const DashboardScreen({super.key, this.api});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _sidebarBreakpoint = 1100.0;
  static final _dateFmt = DateFormat('dd MMM yyyy');

  late final ApiService _api = widget.api ?? ApiService();

  DateTimeRange _range = _defaultRange();
  String? _table;
  String? _action;
  AuditReport? _report;
  String? _error;
  bool _loading = false;
  bool? _apiOnline;

  static DateTimeRange _defaultRange() {
    final today = DateUtils.dateOnly(DateTime.now());
    return DateTimeRange(start: today.subtract(const Duration(days: 29)), end: today);
  }

  @override
  void initState() {
    super.initState();
    _checkHealth();
    _generate();
  }

  Future<void> _checkHealth() async {
    final ok = await _api.isHealthy();
    if (mounted) setState(() => _apiOnline = ok);
  }

  Future<void> _generate() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final report = await _api.fetchReport(_range, table: _table, action: _action);
      if (mounted) setState(() => _report = report);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e) {
      if (mounted) setState(() => _error = 'Could not read the report: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _range,
      helpText: 'Select report period',
      builder: (context, child) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440, maxHeight: 640),
          child: child,
        ),
      ),
    );
    if (picked != null) {
      setState(() => _range = picked);
      _generate();
    }
  }

  void _applyPreset(DateTimeRange range) {
    setState(() => _range = range);
    _generate();
  }

  void _reset() {
    setState(() {
      _range = _defaultRange();
      _table = null;
      _action = null;
    });
    _generate();
  }

  Future<void> _open(Uri uri, String failure) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure)));
    }
  }

  void _download(String format) => _open(
        _api.downloadUri(_range, format, table: _table, action: _action),
        'Could not start the ${format.toUpperCase()} download.',
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= _sidebarBreakpoint;
      final sidebar = AppSidebar(
        apiOnline: _apiOnline,
        onOpenDocs: () => _open(_api.docsUri, 'Could not open the API documentation.'),
      );
      return Scaffold(
        drawer: wide ? null : Drawer(width: 248, backgroundColor: AppColors.sidebar, child: sidebar),
        appBar: wide
            ? null
            : AppBar(
                backgroundColor: AppColors.sidebar,
                foregroundColor: Colors.white,
                title: const Text('AuditTrail', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (wide) sidebar,
            Expanded(child: _buildContent(constraints.maxWidth - (wide ? 248 : 0))),
          ],
        ),
      );
    });
  }

  Widget _buildContent(double width) {
    final pad = width < 600 ? 16.0 : 32.0;
    final contentWidth = (width - pad * 2).clamp(0.0, 1440.0);
    return Column(
      children: [
        SizedBox(
          height: 3,
          child: _loading ? const LinearProgressIndicator(color: AppColors.accent) : null,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(pad),
            child: Center(
              child: SizedBox(
                width: contentWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(contentWidth),
                    const SizedBox(height: 24),
                    FilterBar(
                      range: _range,
                      table: _table,
                      action: _action,
                      loading: _loading,
                      onPickRange: _pickRange,
                      onPreset: _applyPreset,
                      onTableChanged: (v) => setState(() => _table = v),
                      onActionChanged: (v) => setState(() => _action = v),
                      onGenerate: _generate,
                      onReset: _reset,
                    ),
                    const SizedBox(height: 24),
                    if (_error != null) ...[
                      _ErrorBanner(message: _error!, onRetry: _generate),
                      const SizedBox(height: 24),
                    ],
                    if (_report != null)
                      AnimatedOpacity(
                        opacity: _loading ? 0.5 : 1,
                        duration: const Duration(milliseconds: 200),
                        child: _buildReport(_report!, contentWidth),
                      )
                    else if (_loading)
                      const _LoadingPlaceholder(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(double width) {
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Audit Log Reports',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        const Text(
          'Every insert, update and delete across customer, loan and payment records.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14.5),
        ),
      ],
    );
    final canDownload = _report != null && !_loading;
    final actions = Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        OutlinedButton.icon(
          onPressed: canDownload ? () => _download('csv') : null,
          icon: const Icon(Icons.table_view_outlined, size: 18),
          label: const Text('Export CSV'),
        ),
        FilledButton.icon(
          onPressed: canDownload ? () => _download('pdf') : null,
          icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
          label: const Text('Download PDF'),
        ),
      ],
    );
    if (width < 760) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title, const SizedBox(height: 16), actions],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [Expanded(child: title), const SizedBox(width: 16), actions],
    );
  }

  Widget _buildReport(AuditReport report, double width) {
    final total = report.total;
    double share(String action) => total == 0 ? 0 : (report.byAction[action] ?? 0) / total;
    String pct(String action) => '${(share(action) * 100).round()}% of activity';

    final kpis = [
      KpiCard(
        label: 'Total activity',
        value: total,
        icon: Icons.history,
        color: AppColors.info,
        caption: '${report.byTable.length} tables · ${report.byUser.length} users',
      ),
      for (final action in const ['INSERT', 'UPDATE', 'DELETE'])
        KpiCard(
          label: switch (action) {
            'INSERT' => 'Records created',
            'UPDATE' => 'Records updated',
            _ => 'Records deleted',
          },
          value: report.byAction[action] ?? 0,
          icon: ActionStyle.of(action).icon,
          color: ActionStyle.of(action).color,
          caption: pct(action),
          share: share(action),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(Icons.event_note_outlined, size: 16, color: AppColors.textMuted),
            Text(
              'Report period ${_dateFmt.format(report.startDate)} – ${_dateFmt.format(report.endDate)}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
            ),
            Text('·  Generated ${report.generatedAt}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 13.5)),
          ],
        ),
        const SizedBox(height: 12),
        _Grid(columns: width >= 1000 ? 4 : (width >= 560 ? 2 : 1), children: kpis),
        const SizedBox(height: 16),
        _Grid(
          columns: width >= 860 ? 2 : 1,
          children: [
            BreakdownCard(
              title: 'Activity by table',
              icon: Icons.table_chart_outlined,
              data: report.byTable,
              labelOf: tableLabel,
            ),
            BreakdownCard(
              title: 'Activity by user',
              icon: Icons.people_outline,
              data: report.byUser,
            ),
          ],
        ),
        const SizedBox(height: 16),
        AuditTable(
          records: report.records,
          onOpen: (r) => showRecordDetails(context, r),
        ),
      ],
    );
  }
}

/// Equal-height grid rows for cards.
class _Grid extends StatelessWidget {
  final int columns;
  final List<Widget> children;
  static const _gap = 16.0;

  const _Grid({required this.columns, required this.children});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final chunk = children.sublist(i, (i + columns).clamp(0, children.length));
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var j = 0; j < columns; j++) ...[
              if (j > 0) const SizedBox(width: _gap),
              Expanded(child: j < chunk.length ? chunk[j] : const SizedBox.shrink()),
            ],
          ],
        ),
      ));
    }
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: _gap),
          rows[i],
        ],
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.delete.withValues(alpha: 0.06),
          border: Border.all(color: AppColors.delete.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.delete),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: AppColors.delete)),
            ),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) => const Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 64),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Generating report...', style: TextStyle(color: AppColors.textMuted)),
            ],
          ),
        ),
      );
}
