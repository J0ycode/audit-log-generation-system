import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/audit_report.dart';
import '../theme/app_theme.dart';
import 'action_badge.dart';

/// Searchable, paginated activity table. Tapping a row opens its details.
class AuditTable extends StatefulWidget {
  final List<AuditRecord> records;
  final ValueChanged<AuditRecord> onOpen;

  const AuditTable({super.key, required this.records, required this.onOpen});

  @override
  State<AuditTable> createState() => _AuditTableState();
}

class _AuditTableState extends State<AuditTable> {
  static const _pageSizes = [10, 15, 25, 50];
  static final _date = DateFormat('dd MMM yyyy');
  static final _time = DateFormat('hh:mm a');

  String _query = '';
  int _page = 0;
  int _perPage = 15;

  @override
  void didUpdateWidget(AuditTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.records, widget.records)) _page = 0;
  }

  List<AuditRecord> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.records;
    return widget.records.where((r) => r.searchText.contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final rows = _filtered;
    final pageCount = (rows.length / _perPage).ceil();
    final page = pageCount == 0 ? 0 : _page.clamp(0, pageCount - 1);
    final start = page * _perPage;
    final end = (start + _perPage).clamp(0, rows.length);
    final visible = rows.sublist(start, end);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Activity log',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('${rows.length} entries · select a row to see full details',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  ],
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, size: 20),
                      hintText: 'Search user, table or change...',
                    ),
                    onChanged: (v) => setState(() {
                      _query = v;
                      _page = 0;
                    }),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          if (visible.isEmpty)
            const _EmptyRows()
          else
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: _buildTable(visible, start),
                ),
              ),
            ),
          const Divider(),
          _buildFooter(rows.length, start, end, page, pageCount),
        ],
      ),
    );
  }

  Widget _buildTable(List<AuditRecord> visible, int start) {
    const header = TextStyle(
        color: AppColors.textMuted, fontWeight: FontWeight.w600, fontSize: 12.5, letterSpacing: 0.3);
    return DataTable(
      showCheckboxColumn: false,
      headingRowHeight: 44,
      headingRowColor: const WidgetStatePropertyAll(AppColors.surfaceMuted),
      headingTextStyle: header,
      dataRowMinHeight: 56,
      dataRowMaxHeight: 68,
      horizontalMargin: 20,
      columnSpacing: 28,
      dividerThickness: 1,
      dataRowColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.hovered) ? AppColors.surfaceMuted : null,
      ),
      columns: const [
        DataColumn(label: Text('#'), numeric: true),
        DataColumn(label: Text('DATE & TIME')),
        DataColumn(label: Text('ACTION')),
        DataColumn(label: Text('TABLE')),
        DataColumn(label: Text('RECORD')),
        DataColumn(label: Text('USER')),
        DataColumn(label: Text('CHANGES')),
      ],
      rows: [
        for (final (i, r) in visible.indexed)
          DataRow(
            onSelectChanged: (_) => widget.onOpen(r),
            cells: [
              DataCell(Text('${start + i + 1}',
                  style: tabularFigures.copyWith(color: AppColors.textMuted))),
              DataCell(Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_date.format(r.timestamp),
                      style: tabularFigures.copyWith(fontWeight: FontWeight.w500)),
                  Text(_time.format(r.timestamp),
                      style: tabularFigures.copyWith(color: AppColors.textMuted, fontSize: 12.5)),
                ],
              )),
              DataCell(ActionBadge(r.action)),
              DataCell(Text(tableLabel(r.table))),
              DataCell(Text('#${r.recordId}', style: tabularFigures)),
              DataCell(UserChip(r.user)),
              DataCell(ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Text(r.changes,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13.5, height: 1.4)),
              )),
            ],
          ),
      ],
    );
  }

  Widget _buildFooter(int total, int start, int end, int page, int pageCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 4,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rows per page',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: _perPage,
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(8),
                items: [
                  for (final n in _pageSizes) DropdownMenuItem(value: n, child: Text('$n')),
                ],
                onChanged: (v) => setState(() {
                  _perPage = v ?? _perPage;
                  _page = 0;
                }),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(total == 0 ? '0 of 0' : '${start + 1}–$end of $total',
                  style: tabularFigures.copyWith(color: AppColors.textMuted, fontSize: 13)),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Previous page',
                onPressed: page > 0 ? () => setState(() => _page = page - 1) : null,
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                tooltip: 'Next page',
                onPressed: page < pageCount - 1 ? () => setState(() => _page = page + 1) : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserChip extends StatelessWidget {
  final String user;
  const UserChip(this.user, {super.key});

  String get _initials {
    final parts = user.split(RegExp(r'[.\s_]+')).where((p) => p.isNotEmpty).toList();
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.background,
            child: Text(_initials,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
          const SizedBox(width: 8),
          Text(user),
        ],
      );
}

class _EmptyRows extends StatelessWidget {
  const _EmptyRows();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 56),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 40, color: AppColors.textMuted),
            SizedBox(height: 12),
            Text('No matching activity',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            SizedBox(height: 4),
            Text('Try a different search term, date range or filter.',
                style: TextStyle(color: AppColors.textMuted)),
          ],
        ),
      );
}
