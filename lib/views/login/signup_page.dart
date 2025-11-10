import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'otp_verification_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  DateTime? _dob;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _pickDob() async {
    final d = await showDatePicker(
        context: context,
        initialDate: DateTime(2000, 1, 1),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (d != null) setState(() => _dob = d);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final phone = _phone.text.trim();
    setState(() => _loading = true);

    await AuthService.instance.sendOtp(
      phone: phone,
      codeSent: (verificationId, _) {
        setState(() => _loading = false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OtpVerificationPage(
                      verificationId: verificationId,
                      phone: phone,
                      signupData: {
                        'name': _name.text.trim(),
                        'email': _email.text.trim(),
                        'phone': phone,
                        'dob': _dob?.toIso8601String(),
                      },
                    )));
      },
      onFailed: (err) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err.message ?? 'OTP failed')));
      },
      onAutoVerified: (credential) async {
        try {
          final userCred =
              await AuthService.instance.signInWithCredential(credential);
          final uid = userCred.user?.uid;
          if (uid != null) {
            await AuthService.instance.createUserProfile(uid, {
              'name': _name.text.trim(),
              'email': _email.text.trim(),
              'phone': phone,
              'dob': _dob?.toIso8601String(),
            });
          }
          setState(() => _loading = false);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
        } catch (e) {
          setState(() => _loading = false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardRadius = 16.0;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFFDE68A), Color(0xFFF59E0B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(cardRadius))),
                elevation: 12,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Text('Create account',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Full name'),
                          validator: (v) => v!.isEmpty ? 'Required' : null),
                      const SizedBox(height: 12),
                      TextFormField(
                          controller: _email,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 12),
                      TextFormField(
                          controller: _phone,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'Phone (with country code)'),
                          keyboardType: TextInputType.phone,
                          validator: (v) =>
                              v!.isEmpty ? 'Phone required' : null),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                            child: Text(_dob == null
                                ? 'Date of birth'
                                : 'DOB: ${_dob!.toLocal().toString().split(' ')[0]}')),
                        TextButton(
                            onPressed: _pickDob, child: const Text('Pick DOB')),
                      ]),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14)),
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                              : const Text('Send OTP'),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
