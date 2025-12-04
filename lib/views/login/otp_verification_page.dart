import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import 'create_password_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String? verificationId;
  final String? phone;
  final Map<String, dynamic>? signupData;
  final String? nextRoute;

  const OtpVerificationPage(
      {super.key,
      this.verificationId,
      this.phone,
      this.signupData,
      this.nextRoute});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _ctrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());
  bool _loading = false;
  String? _verificationId;
  Timer? _timer;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    if (_verificationId != null) _startCooldown(30);
  }

  void _startCooldown(int s) {
    _resendCooldown = s;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _resendCooldown--;
        if (_resendCooldown <= 0) t.cancel();
      });
    });
  }

  String _combinedCode() => _ctrls.map((c) => c.text.trim()).join();

  Future<void> _verify() async {
    final code = _combinedCode();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter complete 6 digit code')));
      return;
    }
    if ((_verificationId ?? '').isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No verification id')));
      return;
    }

    setState(() => _loading = true);
    try {
      final cred = await AuthService.instance
          .verifyOtp(verificationId: _verificationId!, smsCode: code);

      final uid = cred.user?.uid;
      if (uid != null && widget.signupData != null) {
        try {
          await AuthService.instance.createUserProfile(uid, widget.signupData!);
        } catch (_) {}
      }

      if (!mounted) return;

      // Navigate to create password as per your flow
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const CreatePasswordPage()));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Verification failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resendOtp() async {
    final phone = widget.phone;
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No phone to resend to')));
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService.instance.sendOtp(
        phone: phone,
        codeSent: (verificationId, _) {
          if (!mounted) return;
          setState(() {
            _verificationId = verificationId;
            _loading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('OTP resent')));
          _startCooldown(30);
        },
        onFailed: (err) {
          if (!mounted) return;
          setState(() => _loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(err.message ?? 'Resend failed')));
        },
        onAutoVerified: (credential) async {
          try {
            await AuthService.instance.signInWithCredential(credential);
            if (!mounted) return;
            final target = widget.nextRoute ??
                (widget.signupData != null ? '/home' : '/home');
            Navigator.pushNamedAndRemoveUntil(context, target, (_) => false);
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Auto verify failed: $e')));
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to resend OTP: $e')));
      }
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _otpBox(int i) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: _ctrls[i],
        focusNode: _nodes[i],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1)
        ],
        style: const TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFB78A3C), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD6B566), width: 2.2),
          ),
        ),
        onChanged: (v) {
          if (v.isNotEmpty) {
            if (i + 1 < _nodes.length) {
              FocusScope.of(context).requestFocus(_nodes[i + 1]);
            } else {
              _nodes[i].unfocus();
            }
          } else {
            if (i > 0) FocusScope.of(context).requestFocus(_nodes[i - 1]);
          }
        },
        onSubmitted: (_) {
          if (i == 5) _verify();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneLabel = widget.phone ?? '';
    final double cardRadius = 36;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.32)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(cardRadius),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.36),
                          borderRadius: BorderRadius.circular(cardRadius),
                          border: Border.all(
                              color: const Color(0x22FFD9A6), width: 1.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28.0, vertical: 22.0),
                        child: Column(
                          children: [
                            // top glow
                            Container(
                              height: 6,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    const Color(0x66FFD9A6),
                                    Colors.transparent
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Image.asset('assets/images/logo_glitter.jpg',
                                width: 225, height: 225, fit: BoxFit.contain),
                            const SizedBox(height: 12),
                            const Text('Verify Your Code',
                                style: TextStyle(
                                    color: Color(0xFFFFD88A),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Text(
                              'Please enter the 6-digit code sent to your mobile number / email id',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(height: 18),
                            // OTP boxes
                            Wrap(
                              spacing: 6,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: List.generate(6, (i) => _otpBox(i)),
                            ),
                            const SizedBox(height: 20),
                            // Submit button
                            SizedBox(
                              width: double.infinity,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFF7E6B9),
                                      Color(0xFFD6B566)
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.45),
                                        blurRadius: 20,
                                        offset: Offset(0, 8)),
                                    BoxShadow(
                                        color: Color(0x44FFD9A6),
                                        blurRadius: 20,
                                        spreadRadius: 1),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _verify,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(28)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                  ),
                                  child: _loading
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.black87))
                                      : const Text('Submit',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // small buttons row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton(
                                  onPressed:
                                      _resendCooldown > 0 ? null : _resendOtp,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Color(0xFFB78A3C), width: 1.4),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                  ),
                                  child: Text(
                                      _resendCooldown > 0
                                          ? 'Resend (${_resendCooldown}s)'
                                          : 'Resend code',
                                      style: const TextStyle(
                                          color: Color(0xFFF1DDB2))),
                                ),
                                OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Color(0xFFB78A3C), width: 1.4),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                  ),
                                  child: const Text('Wrong number/email?',
                                      style:
                                          TextStyle(color: Color(0xFFF1DDB2))),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // bottom glow strip
                            Container(
                              height: 8,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    const Color(0x44FFD9A6),
                                    Colors.transparent
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
