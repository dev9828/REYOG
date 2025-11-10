import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class OtpVerificationPage extends StatefulWidget {
  final String? verificationId;
  final String? phone;
  final Map<String, dynamic>? signupData;

  const OtpVerificationPage({
    super.key,
    this.verificationId,
    this.phone,
    this.signupData,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _codeCtrl = TextEditingController();
  bool _loading = false;
  String? _verificationId;
  int? _resendToken;
  int _resendCooldown = 0;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    // start a small cooldown if we have a verificationId arrived already
    if (_verificationId != null) _startResendCooldown(30);
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendCooldown(int seconds) {
    _resendTimer?.cancel();
    setState(() => _resendCooldown = seconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      final next = _resendCooldown - 1;
      if (next <= 0) {
        t.cancel();
        setState(() => _resendCooldown = 0);
      } else {
        setState(() => _resendCooldown = next);
      }
    });
  }

  Future<void> _verifyOtp() async {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter OTP')));
      return;
    }
    if ((_verificationId ?? '').isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No verificationId - request OTP again')));
      return;
    }

    setState(() => _loading = true);
    try {
      print('[OTP] verifying with verificationId=$_verificationId, code=$code');
      final cred = await AuthService.instance.verifyOtp(
        verificationId: _verificationId!,
        smsCode: code,
      );
      print('[OTP] verify succeeded, uid=${cred.user?.uid}');

      final uid = cred.user?.uid;
      if (uid != null && widget.signupData != null) {
        await AuthService.instance.createUserProfile(uid, widget.signupData!);
      }

      setState(() => _loading = false);
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } catch (e, st) {
      print('[OTP] verify failed: $e');
      print(st);
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Verify failed: $e')));
    }
  }

  Future<void> _handleAutoVerified(PhoneAuthCredential credential) async {
    setState(() => _loading = true);
    try {
      final userCred =
          await AuthService.instance.signInWithCredential(credential);
      final uid = userCred.user?.uid;
      if (uid != null && widget.signupData != null) {
        await AuthService.instance.createUserProfile(uid, widget.signupData!);
      }
      setState(() => _loading = false);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Auto verify failed: $e')));
    }
  }

  Future<void> _resendOtp() async {
    final phone = widget.phone;
    if (phone == null || phone.isEmpty) return;
    setState(() => _loading = true);

    await AuthService.instance.sendOtp(
      phone: phone,
      codeSent: (verificationId, resendToken) {
        setState(() {
          _loading = false;
          _verificationId = verificationId;
          _resendToken = resendToken;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('OTP resent')));
        _startResendCooldown(30);
      },
      onFailed: (err) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.message ?? 'Resend failed')));
      },
      onAutoVerified: (credential) async {
        // auto verification after resend
        await _handleAutoVerified(credential);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneLabel = widget.phone ?? 'your phone';
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('We sent an OTP to $phoneLabel',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            TextField(
              controller: _codeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Enter OTP', prefixIcon: Icon(Icons.lock)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _verifyOtp,
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Verify & Continue'),
              ),
            ),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton(
                onPressed:
                    _resendCooldown == 0 && !_loading ? _resendOtp : null,
                child: Text(_resendCooldown == 0
                    ? 'Resend OTP'
                    : 'Resend in ${_resendCooldown}s'),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Change number'),
              ),
            ]),
            const SizedBox(height: 12),
            // Debug info for development
            if (_verificationId != null)
              SelectableText('verificationId: ${_verificationId!}',
                  style: const TextStyle(fontSize: 11, color: Colors.black54)),
            if (_resendToken != null)
              SelectableText('resendToken: ${_resendToken!}',
                  style: const TextStyle(fontSize: 11, color: Colors.black54)),
            const SizedBox(height: 8),
            const Text(
                'If you use Firebase test numbers enter the test code here',
                style: TextStyle(color: Colors.black45, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
