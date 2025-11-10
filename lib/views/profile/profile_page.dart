// ...existing code...
import 'package:flutter/material.dart';
import 'profile_detail_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
        child: Column(
          children: [
            // Profile Avatar + Info
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFFFD66B),
              child: Text(
                'DG',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Devendra',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 4),
            const Text(
              '+91 9828404464',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            const Text(
              'Age 24 • Joined September 2025',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 28),

            // --- Profile Settings Section ---
            _sectionTitle('Profile Settings'),
            _tile(context, Icons.account_circle_outlined, 'Account Details'),
            _tile(context, Icons.tune, 'User Preferences'),
            _tile(context, Icons.person_outline, 'Nominee Details'),
            _tile(
              context,
              Icons.verified_user_outlined,
              'Identity Verification',
              trailingText: 'Start now',
            ),

            const SizedBox(height: 24),

            // --- Assets Section ---
            _sectionTitle('Assets'),
            _tile(
              context,
              Icons.pie_chart_outline,
              'Dashboard',
              trailingText: '₹0',
            ),
            _tile(context, Icons.local_offer_outlined, 'Asset Prices'),

            const SizedBox(height: 24),

            // --- App Settings Section ---
            _sectionTitle('App Settings'),
            _tile(context, Icons.autorenew_outlined, 'AutoPay'),
            _tile(context, Icons.flash_on_outlined, 'SnapSave'),
            _tile(
              context,
              Icons.savings_outlined,
              'Save on Every Spend',
              trailingText: 'Start now',
            ),

            const SizedBox(height: 24),
            _sectionTitle('General'),
            _tile(context, Icons.security_outlined, 'Security & Permission'),
            _tile(context, Icons.help_center, 'Help & Support'),
            _tile(context, Icons.delete, 'Delete Account'),
            _tile(context, Icons.abc_outlined, 'About Reyogo'),
            _tile(context, Icons.feedback, 'Share Feedback'),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String title, {
    String? trailingText,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title),
        trailing: trailingText != null
            ? Text(
                trailingText,
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                ),
              )
            : const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileDetailPage(section: title),
            ),
          );
        },
      ),
    );
  }
}
// ...existing code...