import 'package:flutter/material.dart';

import '../config.dart';
import '../theme/app_theme.dart';

class AppSidebar extends StatelessWidget {
  /// null while the health check is still running.
  final bool? apiOnline;
  final VoidCallback onOpenDocs;

  const AppSidebar({super.key, required this.apiOnline, required this.onOpenDocs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      color: AppColors.sidebar,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.verified_user_outlined, color: AppColors.sidebar, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AuditTrail',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                        Text('Loan Operations',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.sidebarMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const _SectionLabel('REPORTS'),
            const _NavItem(icon: Icons.fact_check_outlined, label: 'Audit Log Reports', selected: true),
            const SizedBox(height: 16),
            const _SectionLabel('DEVELOPER'),
            _NavItem(
              icon: Icons.api_outlined,
              label: 'API Documentation',
              trailing: Icons.open_in_new,
              onTap: onOpenDocs,
            ),
            const Spacer(),
            _ApiStatus(online: apiOnline),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: Text(text,
            style: const TextStyle(
                color: AppColors.sidebarMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1)),
      );
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final IconData? trailing;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : AppColors.sidebarText;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected ? AppColors.sidebarActive : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(8),
          hoverColor: Colors.white.withValues(alpha: 0.06),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: selected
                ? const BoxDecoration(
                    border: Border(left: BorderSide(color: AppColors.accent, width: 3)))
                : null,
            child: Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w500)),
                ),
                if (trailing != null) Icon(trailing, size: 14, color: AppColors.sidebarMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ApiStatus extends StatelessWidget {
  final bool? online;
  const _ApiStatus({required this.online});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (online) {
      null => (AppColors.sidebarMuted, 'Checking API...'),
      true => (AppColors.accent, 'API connected'),
      false => (const Color(0xFFF87171), 'API unreachable'),
    };
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.sidebarActive,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.sidebarText, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(apiBaseUrl,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.sidebarMuted, fontSize: 12)),
        ],
      ),
    );
  }
}
