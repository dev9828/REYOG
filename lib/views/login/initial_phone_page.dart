import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'otp_verification_page.dart';

class InitialPhonePage extends StatefulWidget {
  const InitialPhonePage({super.key});

  @override
  State<InitialPhonePage> createState() => _InitialPhonePageState();
}

class _InitialPhonePageState extends State<InitialPhonePage> {
  final _phoneCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  String _normalizePhone(String input) {
    final s = input.trim();
    if (s.isEmpty) return '';
    if (s.startsWith('+')) return s;
    final digits = s.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) return '+91$digits';
    return digits;
  }

  Future<void> _sendOtp() async {
    final raw = _phoneCtrl.text.trim();
    final phone = _normalizePhone(raw);

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter phone number (10 digits)')));
      return;
    }
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter a valid 10 digit number')));
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService.instance.sendOtp(
        phone: phone,
        codeSent: (verificationId, _) {
          if (!mounted) return;
          setState(() => _loading = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpVerificationPage(
                verificationId: verificationId,
                phone: phone,
              ),
            ),
          );
        },
        onFailed: (err) {
          if (!mounted) return;
          setState(() => _loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(err.message ?? 'Send OTP failed')));
        },
        onAutoVerified: (credential) async {
          try {
            await AuthService.instance.signInWithCredential(credential);
            if (!mounted) return;
            Navigator.pushReplacementNamed(context, '/login');
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Auto verify failed: $e')));
          }
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to send OTP: $e')));
    }
  }

  InputDecoration _inputDec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF7A7A7A), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFB78A3C), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFD6B566), width: 2.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // tuned sizes to match reference image
    final double cardRadius = 36;
    final double logoSize = 250;
    final double cardHeight = MediaQuery.of(context).size.height * 0.68;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // background image (assets/images/background.png)
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          // dark overlay so card pops
          Container(color: Colors.black.withOpacity(0.32)),
          Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SizedBox(
                  height: cardHeight,
                  child: Stack(
                    children: [
                      // outer rounded gold stroke + glow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(cardRadius + 4),
                            border: Border.all(
                              color: const Color(0x33FFD9A6),
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),

                      // frosted glass main card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(cardRadius),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.36),
                              borderRadius: BorderRadius.circular(cardRadius),
                              border: Border.all(
                                color: const Color(0x22FFD9A6),
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28.0, vertical: 22.0),
                              child: Column(
                                children: [
                                  // top soft gold glow line
                                  Container(
                                    height: 6,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 8.0),
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
                                  const SizedBox(height: 6),
                                  // logo and spacing exact
                                  SizedBox(
                                    width: logoSize,
                                    height: logoSize,
                                    child: Image.asset(
                                      'assets/images/logo_glitter.jpg',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  const Text(
                                    'Registration',
                                    style: TextStyle(
                                        color: Color(0xFFFFD88A),
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 40),
                                  // pill input with white fill and fine gold outline
                                  TextField(
                                    controller: _phoneCtrl,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    decoration:
                                        _inputDec('Mobile number/email id'),
                                  ),
                                  const SizedBox(height: 22),
                                  // big rounded golden button with subtle inner glow
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
                                            Color(0xFFD6B566),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.45),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                          BoxShadow(
                                            color: const Color(0x44FFD9A6),
                                            blurRadius: 24,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _loading ? null : _sendOtp,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(28),
                                          ),
                                        ),
                                        child: _loading
                                            ? const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.black87),
                                              )
                                            : const Text(
                                                'Submit',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  // lower small glow strip like reference
                                  Container(
                                    height: 8,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 6),
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

                      // optional small circular subtle highlight at top-right
                      Positioned(
                        top: 18,
                        right: 20,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0x22FFD9A6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
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
