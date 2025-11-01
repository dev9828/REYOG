import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class PriceTiles extends StatelessWidget {
  const PriceTiles({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _FeatureTile(title: '24K 999 Gold', subtitle: 'BIS Hallmarked', icon: Icons.check_circle)),
        SizedBox(width: 12),
        Expanded(child: _FeatureTile(title: 'Gold Stored', subtitle: 'By Sequel', icon: Icons.lock)),
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const _FeatureTile({required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppTheme.cardBg,
              child: Icon(icon, color: AppTheme.goldDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
