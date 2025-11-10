// ...existing code...
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class ProfileDetailPage extends StatefulWidget {
  final String section;
  const ProfileDetailPage({super.key, required this.section});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  // Controllers used by various forms
  final _nameCtrl = TextEditingController(text: 'Devendra');
  final _phoneCtrl = TextEditingController(text: '+91 9828404464');
  final _emailCtrl = TextEditingController(text: 'devendra@example.com');

  final _nomineeName = TextEditingController();
  final _nomineeRelation = TextEditingController();
  final _nomineePhone = TextEditingController();

  final _idNumberCtrl = TextEditingController();
  String _idType = 'Aadhaar';
  bool _idUploaded = false;

  bool _autopayEnabled = false;
  bool _snapSaveEnabled = false;
  bool _saveEverySpend = false;
  double _savePercent = 5;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _nomineeName.dispose();
    _nomineeRelation.dispose();
    _nomineePhone.dispose();
    _idNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.section;
    return Scaffold(
      backgroundColor: AppTheme.gold,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSection(title),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String key) {
    switch (key) {
      case 'Account Details':
        return _accountDetails();
      case 'User Preferences':
        return _userPreferences();
      case 'Nominee Details':
        return _nomineeDetails();
      case 'Identity Verification':
        return _identityVerification();
      case 'Dashboard':
        return _assetsDashboard();
      case 'Asset Prices':
        return _assetPrices();
      case 'AutoPay':
        return _autoPay();
      case 'SnapSave':
        return _snapSave();
      case 'Save on Every Spend':
        return _saveOnEverySpend();
      case 'Security & Permission':
        return _securityPermissions();
      case 'Help & Support':
        return _helpSupport();
      case 'Delete Account':
        return _deleteAccount();
      case 'About Reyogo':
        return _aboutReyogo();
      case 'Share Feedback':
        return _shareFeedback();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _sectionHeader(String title, [String? subtitle]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.black54)),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _accountDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Account Details', 'Update your personal information'),
        TextFormField(
          controller: _nameCtrl,
          decoration: const InputDecoration(labelText: 'Full name'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _phoneCtrl,
          decoration: const InputDecoration(labelText: 'Phone'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _emailCtrl,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: save profile
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile saved')),
                  );
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _userPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'User Preferences',
          'Customize app behavior and notifications',
        ),
        SwitchListTile(
          title: const Text('Price Alerts'),
          subtitle: const Text(
            'Receive push notifications for price movements',
          ),
          value: true,
          onChanged: (v) {},
        ),
        SwitchListTile(
          title: const Text('Daily Market Summary'),
          subtitle: const Text('Receive a short summary each morning'),
          value: false,
          onChanged: (v) {},
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Preferences updated')),
            );
          },
          child: const Text('Update Preferences'),
        ),
      ],
    );
  }

  Widget _nomineeDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'Nominee Details',
          'Add or update nominee for your assets',
        ),
        TextFormField(
          controller: _nomineeName,
          decoration: const InputDecoration(labelText: 'Nominee name'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _nomineeRelation,
          decoration: const InputDecoration(labelText: 'Relation'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _nomineePhone,
          decoration: const InputDecoration(labelText: 'Phone'),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nominee saved')),
                  );
                },
                child: const Text('Save Nominee'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _identityVerification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'Identity Verification',
          'Verify your identity to unlock higher limits',
        ),
        DropdownButtonFormField<String>(
          value: _idType,
          items: const [
            DropdownMenuItem(value: 'Aadhaar', child: Text('Aadhaar')),
            DropdownMenuItem(value: 'PAN', child: Text('PAN')),
            DropdownMenuItem(value: 'Passport', child: Text('Passport')),
          ],
          onChanged: (v) => setState(() => _idType = v ?? 'Aadhaar'),
          decoration: const InputDecoration(labelText: 'ID type'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _idNumberCtrl,
          decoration: const InputDecoration(labelText: 'ID number'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: Text(_idUploaded ? 'Uploaded' : 'Upload Document'),
              onPressed: () {
                // place holder for upload flow
                setState(() => _idUploaded = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Document uploaded (demo)')),
                );
              },
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {
                // start verification flow
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Verification requested')),
                );
              },
              child: const Text('Request Verification'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _assetsDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'My Assets',
          'Summary of your gold holdings and performance',
        ),
        const ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.amber,
            child: Icon(Icons.account_balance),
          ),
          title: Text('Physical Gold'),
          subtitle: Text('0.0 gm • Value ₹0'),
        ),
        const Divider(),
        const ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.trending_up),
          ),
          title: Text('Invested via REYOGO'),
          subtitle: Text('No active investments'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          child: const Text('View full dashboard'),
        ),
      ],
    );
  }

  Widget _assetPrices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'Asset Prices',
          'Quick access to recent prices and watchlist',
        ),
        const ListTile(
          leading: Icon(Icons.watch_later),
          title: Text('Gold (24K)'),
          subtitle: Text('₹5,000 / gm (example)'),
        ),
        const ListTile(
          leading: Icon(Icons.watch_later),
          title: Text('Silver'),
          subtitle: Text('₹65 / gm (example)'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Open Price Explorer'),
        ),
      ],
    );
  }

  Widget _autoPay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'AutoPay',
          'Setup recurring purchases or SIP-like plans',
        ),
        SwitchListTile(
          title: const Text('Enable AutoPay'),
          subtitle: const Text('Schedule recurring buys'),
          value: _autopayEnabled,
          onChanged: (v) => setState(() => _autopayEnabled = v),
        ),
        if (_autopayEnabled) ...[
          const SizedBox(height: 8),
          const Text('Frequency'),
          const SizedBox(height: 6),
          Row(
            children: const [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Weekly'),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Monthly'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Configure AutoPay'),
          ),
        ],
      ],
    );
  }

  Widget _snapSave() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'SnapSave',
          'Round-up spare change to buy gold automatically',
        ),
        SwitchListTile(
          title: const Text('Enable SnapSave'),
          subtitle: const Text(
            'Round-up transactions and invest the spare change',
          ),
          value: _snapSaveEnabled,
          onChanged: (v) => setState(() => _snapSaveEnabled = v),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Manage linked cards'),
        ),
      ],
    );
  }

  Widget _saveOnEverySpend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'Save on Every Spend',
          'Auto-save percentage from each transaction',
        ),
        SwitchListTile(
          title: const Text('Enable Save on Every Spend'),
          value: _saveEverySpend,
          onChanged: (v) => setState(() => _saveEverySpend = v),
        ),
        if (_saveEverySpend) ...[
          const SizedBox(height: 8),
          Text('Save percentage: ${_savePercent.toInt()}%'),
          Slider(
            min: 1,
            max: 20,
            divisions: 19,
            value: _savePercent,
            onChanged: (v) => setState(() => _savePercent = v),
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Save settings')),
        ],
      ],
    );
  }

  Widget _securityPermissions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'Security & Permission',
          'Manage authentication and app permissions',
        ),
        ListTile(
          leading: const Icon(Icons.fingerprint),
          title: const Text('Biometric Authentication'),
          trailing: ElevatedButton(
            onPressed: () {},
            child: const Text('Enable'),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: const Text('Change PIN / Password'),
          trailing: ElevatedButton(
            onPressed: () {},
            child: const Text('Change'),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Manage App Permissions'),
        ),
      ],
    );
  }

  Widget _helpSupport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Help & Support', 'Get help and contact support'),
        const Text(
          'Common issues\n• App not updating prices\n• Transaction not showing\n• Uploading documents',
          style: TextStyle(color: Colors.black87),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            // open chat or mail
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening support chat (demo)')),
            );
          },
          child: const Text('Contact Support'),
        ),
      ],
    );
  }

  Widget _deleteAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'Delete Account',
          'This action is irreversible. All data will be removed.',
        ),
        const Text(
          'Please confirm your decision. You will receive an email to finalize deletion.',
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Confirm delete'),
                content: const Text(
                  'Are you sure you want to delete your account? This cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account deletion requested'),
                        ),
                      );
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Delete my account'),
        ),
      ],
    );
  }

  Widget _aboutReyogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('About Reyogo', 'Short description'),
        const Text(
          'REYOGO is a simple, secure gold price tracking app that helps you monitor prices, save on the go, and learn about the gold market. We focus on transparency and easy-to-use tools for new and experienced users.',
          style: TextStyle(color: Colors.black87, height: 1.4),
        ),
        const SizedBox(height: 12),
        const Text('Version: 1.0.0'),
      ],
    );
  }

  Widget _shareFeedback() {
    final _feedbackCtrl = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Share Feedback', 'Help us improve REYOGO'),
        TextFormField(
          controller: _feedbackCtrl,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Write your feedback here',
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thanks for your feedback')),
            );
          },
          child: const Text('Send Feedback'),
        ),
      ],
    );
  }
}
// ...existing code...