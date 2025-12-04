import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/biometric_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  bool _loading = false;
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _initBiometric();
  }

  Future<void> _initBiometric() async {
    final avail = await BiometricService.instance.canCheckBiometrics();
    final enabled = await BiometricService.instance.isEnabled();
    setState(() {
      _biometricAvailable = avail;
      _biometricEnabled = enabled;
    });
    if (avail && enabled) {
      final ok =
          await BiometricService.instance.authenticate(reason: 'Unlock Reyogo');
      if (ok && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  void _submitPasswordLogin() {
    // keep existing behaviour (show enable biometric dialog). Replace with actual auth call where required.
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Biometric / Face ID'),
        content: const Text('Enable biometric login for seamless entry?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Skip')),
          ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _enableBiometric();
              },
              child: const Text('Enable')),
        ],
      ),
    );
  }

  Future<void> _enableBiometric() async {
    final supported = await BiometricService.instance.canCheckBiometrics();
    if (!supported) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Biometric/Device credential not available or not enrolled on this device. Please enroll in device settings.')));
      return;
    }

    final enrolled = await BiometricService.instance.getEnrolledBiometrics();
    if (enrolled.isEmpty) {
      if (!mounted) return;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('No biometrics enrolled'),
          content: const Text(
              'No fingerprint or face template found. You can enable device PIN/pattern as fallback or enroll biometrics in device settings. Do you want to try authentication (may fall back to PIN)?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Try')),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    final ok = await BiometricService.instance
        .authenticate(reason: 'Confirm to enable biometric login');
    if (ok) {
      await BiometricService.instance.setEnabled(true);
      if (!mounted) return;
      setState(() => _biometricEnabled = true);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric login enabled')));
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric setup failed or cancelled')));
    }
  }

  void _goRegister() => Navigator.pushNamed(context, '/register');
  void _goForgot() => Navigator.pushNamed(context, '/forgot');
  void _useOtp() => Navigator.pushNamed(context, '/otp_phone');

  InputDecoration _pillDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF777777), fontSize: 15),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFB78A3C), width: 1.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFD6B566), width: 2.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final double cardRadius = 36;
    final double logoSize = 200;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.34)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: Stack(
                    children: [
                      // outer gold stroke & glow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(cardRadius + 6),
                            border: Border.all(
                                color: const Color(0x33FFD9A6), width: 1.4),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0x22FFD9A6),
                                  blurRadius: 18,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 8)),
                            ],
                          ),
                        ),
                      ),

                      // frosted transparent card
                      ClipRRect(
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
                                // top subtle glow
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
                                const SizedBox(height: 8),
                                Image.asset('assets/images/logo_glitter.jpg',
                                    width: logoSize, height: logoSize),
                                const SizedBox(height: 10),
                                const Text(
                                  'Welcome',
                                  style: TextStyle(
                                      color: Color(0xFFFFD88A),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 18),
                                TextField(
                                    controller: _idCtrl,
                                    decoration: _pillDecoration(
                                        'Mobile number/email id')),
                                const SizedBox(height: 12),
                                TextField(
                                    controller: _pwdCtrl,
                                    obscureText: true,
                                    decoration: _pillDecoration('Password')),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: _goForgot,
                                    child: const Text('Forgot Password?',
                                        style: TextStyle(
                                            color: Color(0xFFCFB57E))),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // login button with gold gradient
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
                                            color:
                                                Colors.black.withOpacity(0.45),
                                            blurRadius: 18,
                                            offset: Offset(0, 8)),
                                        BoxShadow(
                                            color: Color(0x44FFD9A6),
                                            blurRadius: 18,
                                            spreadRadius: 1),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _loading
                                          ? null
                                          : _submitPasswordLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(28)),
                                      ),
                                      child: _loading
                                          ? const SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.black87))
                                          : const Text('Login',
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: _goRegister,
                                  child: const Text(
                                      "Don't have an account? Register here",
                                      style:
                                          TextStyle(color: Color(0xFFCFB57E))),
                                ),
                                const Spacer(),
                                // bottom glow bar similar to design
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

                      // small highlight circle top-right
                      Positioned(
                        top: 18,
                        right: 22,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              color: const Color(0x22FFD9A6),
                              shape: BoxShape.circle),
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
