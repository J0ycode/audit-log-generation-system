import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';

const _tables = ['customers', 'loans', 'payments'];
const _actions = ['INSERT', 'UPDATE', 'DELETE'];

class DatePreset {
  final String label;
  final DateTimeRange Function(DateTime today) build;
  const DatePreset(this.label, this.build);
}

final datePresets = [
  DatePreset('Today', (t) => DateTimeRange(start: t, end: t)),
  DatePreset('Last 7 days',
      (t) => DateTimeRange(start: t.subtract(const Duration(days: 6)), end: t)),
  DatePreset('Last 30 days',
      (t) => DateTimeRange(start: t.subtract(const Duration(days: 29)), end: t)),
  DatePreset('This month', (t) => DateTimeRange(start: DateTime(t.year, t.month), end: t)),
];

class FilterBar extends StatelessWidget {
  final DateTimeRange range;
  final String? table;
  final String? action;
  final bool loading;
  final VoidCallback onPickRange;
  final ValueChanged<DateTimeRange> onPreset;
  final ValueChanged<String?> onTableChanged;
  final ValueChanged<String?> onActionChanged;
  final VoidCallback onGenerate;
  final VoidCallback onReset;

  const FilterBar({
    super.key,
    required this.range,
    required this.table,
    required this.action,
    required this.loading,
    required this.onPickRange,
    required this.onPreset,
    required this.onTableChanged,
    required this.onActionChanged,
    required this.onGenerate,
    required this.onReset,
  });

  static final _fmt = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                _Labeled(
                  label: 'Date range',
                  child: SizedBox(
                    width: 300,
                    child: Semantics(
                      button: true,
                      label: 'Select date range',
                      child: InkWell(
                        onTap: onPickRange,
                        borderRadius: BorderRadius.circular(8),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                            suffixIcon: Icon(Icons.expand_more, size: 20),
                          ),
                          child: Text('${_fmt.format(range.start)}  –  ${_fmt.format(range.end)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tabularFigures),
                        ),
                      ),
                    ),
                  ),
                ),
                _Labeled(
                  label: 'Table',
                  child: _Dropdown(
                    value: table,
                    options: _tables,
                    display: tableLabel,
                    allLabel: 'All tables',
                    onChanged: onTableChanged,
                  ),
                ),
                _Labeled(
                  label: 'Action',
                  child: _Dropdown(
                    value: action,
                    options: _actions,
                    display: (a) => ActionStyle.of(a).label,
                    allLabel: 'All actions',
                    onChanged: onActionChanged,
                  ),
                ),
                FilledButton.icon(
                  onPressed: loading ? null : onGenerate,
                  icon: loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.assessment_outlined, size: 18),
                  label: Text(loading ? 'Generating...' : 'Generate Report'),
                ),
                TextButton.icon(
                  onPressed: loading ? null : onReset,
                  icon: const Icon(Icons.restart_alt, size: 18),
                  label: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Quick select:',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                for (final preset in datePresets)
                  _PresetChip(
                    label: preset.label,
                    selected: _sameRange(preset.build(today), range),
                    onTap: () => onPreset(preset.build(today)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static bool _sameRange(DateTimeRange a, DateTimeRange b) =>
      DateUtils.isSameDay(a.start, b.start) && DateUtils.isSameDay(a.end, b.end);
}

class _Labeled extends StatelessWidget {
  final String label;
  final Widget child;
  const _Labeled({required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          child,
        ],
      );
}

class _Dropdown extends StatelessWidget {
  final String? value;
  final List<String> options;
  final String Function(String) display;
  final String allLabel;
  final ValueChanged<String?> onChanged;

  const _Dropdown({
    required this.value,
    required this.options,
    required this.display,
    required this.allLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 180,
        child: DropdownButtonFormField<String?>(
          // Key on the value so an external reset rebuilds the field.
          key: ValueKey(value),
          initialValue: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(8),
          items: [
            DropdownMenuItem(value: null, child: Text(allLabel)),
            ...options.map((o) => DropdownMenuItem(value: o, child: Text(display(o)))),
          ],
          onChanged: onChanged,
        ),
      );
}

class _PresetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PresetChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: selected ? Colors.white : AppColors.text,
        ),
      );
}
