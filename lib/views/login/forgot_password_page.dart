import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'otp_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _phone = TextEditingController();
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    final phone = _phone.text.trim();
    final email = _email.text.trim();

    if (phone.isEmpty) {
      // If phone not provided but email provided, show info (email-reset flow not implemented here)
      if (email.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Password reset via email is not implemented. Please provide phone to receive OTP.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enter phone with country code')));
      }
      return;
    }

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
                    signupData: {'email': email.isEmpty ? null : email})));
      },
      onFailed: (err) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err.message ?? 'OTP failed')));
      },
      onAutoVerified: (credential) async {
        try {
          await AuthService.instance.signInWithCredential(credential);
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
              colors: [Color(0xFFE6F7FF), Color(0xFFBFE9FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(cardRadius))),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text('Forgot Password',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                        'Provide your phone to receive an OTP. You may also enter your email for reference.',
                        style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 16),
                    TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email (optional)'),
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    TextFormField(
                        controller: _phone,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            labelText: 'Phone (with country code)'),
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: _loading ? null : _sendOtp,
                        child: _loading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text('Send OTP'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back to login')),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
