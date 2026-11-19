import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';

final _number = NumberFormat.decimalPattern();

class KpiCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final String caption;

  /// Fraction of the total (0-1); draws a share bar when set.
  final double? share;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.caption,
    this.share,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(label,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _number.format(value),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.merge(tabularFigures)
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(caption, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: share ?? 1,
                minHeight: 6,
                color: color,
                backgroundColor: color.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ranked horizontal bars showing how activity splits across a dimension.
class BreakdownCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Map<String, int> data;
  final String Function(String)? labelOf;

  const BreakdownCard({
    super.key,
    required this.title,
    required this.icon,
    required this.data,
    this.labelOf,
  });

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final total = data.values.fold<int>(0, (a, b) => a + b);
    final max = entries.isEmpty ? 1 : entries.first.value;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            if (entries.isEmpty)
              const Text('No activity', style: TextStyle(color: AppColors.textMuted))
            else
              for (final e in entries) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(labelOf?.call(e.key) ?? e.key,
                          overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13.5)),
                    ),
                    Text('${e.value}',
                        style: tabularFigures.copyWith(fontWeight: FontWeight.w600, fontSize: 13.5)),
                    SizedBox(
                      width: 48,
                      child: Text(
                        '${(e.value * 100 / total).round()}%',
                        textAlign: TextAlign.right,
                        style: tabularFigures.copyWith(color: AppColors.textMuted, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: e.value / max,
                    minHeight: 6,
                    color: AppColors.primary,
                    backgroundColor: AppColors.background,
                  ),
                ),
                const SizedBox(height: 12),
              ],
          ],
        ),
      ),
    );
  }
}
