import 'dart:ui';
import 'package:flutter/material.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final p = _passCtrl.text.trim();
    final c = _confirmCtrl.text.trim();

    setState(() => _error = null);

    if (p.isEmpty || c.isEmpty) {
      setState(() => _error = 'Please fill both fields');
      return;
    }
    if (p.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }
    if (p != c) {
      setState(() => _error = 'Passwords do not match');
      return;
    }

    setState(() => _loading = true);
    // Here you would normally save the password (link to account) via your auth service.
    // For now, we simply navigate to the login page after a small delay to show the flow.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _loading = false);
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  InputDecoration _pillDecoration(String hint, {Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF777777), fontSize: 15),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFB78A3C), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFD6B566), width: 2.4),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final double cardRadius = 32;
    final double logoSize = 200;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // background image present in assets/images/background.png
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.34)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.66,
                  child: Stack(
                    children: [
                      // outer thin gold rounded stroke + glow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(cardRadius + 6),
                            border: Border.all(
                                color: const Color(0x33FFD9A6), width: 1.4),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x22FFD9A6),
                                blurRadius: 20,
                                spreadRadius: 1,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // frosted glass card
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
                                  color: const Color(0x22FFD9A6), width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28.0, vertical: 20.0),
                              child: Column(
                                children: [
                                  // top glow bar
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
                                  const SizedBox(height: 10),
                                  // logo
                                  Image.asset('assets/images/logo_glitter.jpg',
                                      width: logoSize,
                                      height: logoSize,
                                      fit: BoxFit.contain),
                                  const SizedBox(height: 18),
                                  const Text(
                                    'Create Password',
                                    style: TextStyle(
                                      color: Color(0xFFFFD88A),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  // New password pill
                                  TextField(
                                    controller: _passCtrl,
                                    obscureText: _obscure1,
                                    decoration: _pillDecoration(
                                      'New Password',
                                      suffix: IconButton(
                                        icon: Icon(
                                            _obscure1
                                                ? Icons.lock_outline
                                                : Icons.lock_open,
                                            color: const Color(0xFF8A8A8A)),
                                        onPressed: () => setState(
                                            () => _obscure1 = !_obscure1),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Confirm password pill
                                  TextField(
                                    controller: _confirmCtrl,
                                    obscureText: _obscure2,
                                    decoration: _pillDecoration(
                                      'Confirm Password',
                                      suffix: IconButton(
                                        icon: Icon(
                                            _obscure2
                                                ? Icons.lock_outline
                                                : Icons.lock_open,
                                            color: const Color(0xFF8A8A8A)),
                                        onPressed: () => setState(
                                            () => _obscure2 = !_obscure2),
                                      ),
                                    ),
                                  ),
                                  if (_error != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text(_error!,
                                          style: const TextStyle(
                                              color: Colors.red)),
                                    ),
                                  const SizedBox(height: 18),
                                  // Set Password gold button
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
                                              color: Colors.black
                                                  .withOpacity(0.45),
                                              blurRadius: 20,
                                              offset: Offset(0, 8)),
                                          BoxShadow(
                                              color: Color(0x44FFD9A6),
                                              blurRadius: 18,
                                              spreadRadius: 1),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _loading ? null : _submit,
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
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.black87))
                                            : const Text('Set Password',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  // bottom glow bar
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

                      // optional top-right subtle gold circle (like design)
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
