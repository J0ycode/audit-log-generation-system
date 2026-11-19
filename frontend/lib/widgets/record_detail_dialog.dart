import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/audit_report.dart';
import '../theme/app_theme.dart';
import 'action_badge.dart';
import 'audit_table.dart';

/// Shows the before/after values of one audit entry, highlighting changed fields.
Future<void> showRecordDetails(BuildContext context, AuditRecord record) {
  return showDialog<void>(
    context: context,
    builder: (_) => _RecordDetailDialog(record),
  );
}

class _RecordDetailDialog extends StatelessWidget {
  final AuditRecord record;
  const _RecordDetailDialog(this.record);

  static final _fmt = DateFormat('dd MMM yyyy, hh:mm:ss a');

  @override
  Widget build(BuildContext context) {
    final oldData = record.oldData ?? const {};
    final newData = record.newData ?? const {};
    final fields = {...oldData.keys, ...newData.keys}.toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ActionBadge(record.action),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('${tableLabel(record.table)} #${record.recordId}',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 24,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  UserChip(record.user),
                  _Meta(icon: Icons.schedule, text: _fmt.format(record.timestamp)),
                  _Meta(icon: Icons.tag, text: 'Audit entry ${record.id}'),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  child: _FieldTable(fields: fields, oldData: oldData, newData: newData),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Meta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: AppColors.textMuted, fontSize: 13.5)),
        ],
      );
}

class _FieldTable extends StatelessWidget {
  final List<String> fields;
  final Map<String, dynamic> oldData;
  final Map<String, dynamic> newData;

  const _FieldTable({required this.fields, required this.oldData, required this.newData});

  String _show(Map<String, dynamic> data, String key) =>
      data.containsKey(key) ? '${data[key]}' : '—';

  @override
  Widget build(BuildContext context) {
    const head = TextStyle(
        color: AppColors.textMuted, fontWeight: FontWeight.w600, fontSize: 12.5, letterSpacing: 0.3);
    Widget cell(String text, {TextStyle? style}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(text, style: style),
        );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {0: FlexColumnWidth(1.1), 1: FlexColumnWidth(2), 2: FlexColumnWidth(2)},
        border: const TableBorder(horizontalInside: BorderSide(color: AppColors.border)),
        children: [
          TableRow(
            decoration: const BoxDecoration(color: AppColors.surfaceMuted),
            children: [cell('FIELD', style: head), cell('BEFORE', style: head), cell('AFTER', style: head)],
          ),
          for (final f in fields)
            () {
              final before = _show(oldData, f);
              final after = _show(newData, f);
              final changed = oldData.isNotEmpty && newData.isNotEmpty && before != after;
              return TableRow(
                decoration: changed
                    ? BoxDecoration(color: AppColors.update.withValues(alpha: 0.08))
                    : null,
                children: [
                  cell(f, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                  cell(before, style: const TextStyle(color: AppColors.textMuted, fontSize: 13.5)),
                  cell(after,
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: changed ? FontWeight.w700 : FontWeight.w400)),
                ],
              );
            }(),
        ],
      ),
    );
  }
}
