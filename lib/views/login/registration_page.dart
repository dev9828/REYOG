import 'dart:ui';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _name = TextEditingController();
  final _gender = TextEditingController();
  final _age = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _ref = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _gender.dispose();
    _age.dispose();
    _email.dispose();
    _mobile.dispose();
    _ref.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pushNamed(context, '/create_password', arguments: {
      'name': _name.text,
      'email': _email.text,
      'mobile': _mobile.text,
      'gender': _gender.text,
      'age': _age.text,
      'ref': _ref.text,
    });
  }

  Widget _pillField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFB78A3C), width: 1.6),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF7A7A7A)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: InputBorder.none,
          suffixIcon: suffix,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double cardRadius = 36;
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
                constraints: const BoxConstraints(maxWidth: 480),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.78,
                  child: Stack(
                    children: [
                      // outer gold stroke + glow
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
                                  offset: const Offset(0, 8)),
                            ],
                          ),
                        ),
                      ),

                      // frosted card
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
                                  color: const Color(0x22FFD9A6), width: 1.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28.0, vertical: 22.0),
                              child: Column(
                                children: [
                                  // top glow line
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
                                  const SizedBox(height: 60),
                                  // logo
                                  const Text(
                                    'Complete Your Profile',
                                    style: TextStyle(
                                        color: Color(0xFFFFD88A),
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 22),
                                  // fields
                                  _pillField(
                                      controller: _name, hint: 'Full Name'),
                                  const SizedBox(height: 12),
                                  _pillField(
                                      controller: _gender, hint: 'Gender'),
                                  const SizedBox(height: 12),
                                  _pillField(
                                      controller: _age,
                                      hint: 'Age',
                                      keyboardType: TextInputType.number),
                                  const SizedBox(height: 12),
                                  _pillField(
                                      controller: _mobile,
                                      hint: 'Mobile Number',
                                      keyboardType: TextInputType.phone),
                                  const SizedBox(height: 12),
                                  _pillField(
                                    controller: _ref,
                                    hint: 'Referral Code (if any)',
                                    suffix: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: const Color(0xFFB78A3C),
                                              width: 1.4),
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // buttons row: Submit (big) + Skip (circle)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(28),
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
                                                  blurRadius: 18,
                                                  offset: Offset(0, 8)),
                                              BoxShadow(
                                                  color: Color(0x44FFD9A6),
                                                  blurRadius: 18,
                                                  spreadRadius: 1),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: _submit,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          28)),
                                            ),
                                            child: const Text('Submit',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Skip circular outlined button
                                      SizedBox(
                                        width: 56,
                                        height: 56,
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Color(0xFFB78A3C),
                                                width: 1.8),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(28)),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          child: const Text('Skip',
                                              style: TextStyle(
                                                  color: Color(0xFFF1DDB2))),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  // bottom subtle glow
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

                      // small gold highlight circle top-right
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
