import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ActionBadge extends StatelessWidget {
  final String action;

  const ActionBadge(this.action, {super.key});

  @override
  Widget build(BuildContext context) {
    final style = ActionStyle.of(action);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 14, color: style.color),
          const SizedBox(width: 4),
          Text(
            style.label,
            style: TextStyle(color: style.color, fontWeight: FontWeight.w600, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
