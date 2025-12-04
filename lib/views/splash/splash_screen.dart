import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../login/initial_phone_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    Timer(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const InitialPhonePage()));
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _close() {
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const InitialPhonePage()));
  }

  @override
  Widget build(BuildContext context) {
    // background image + glowing gold popup like attached POP_UP
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          // subtle dim overlay
          Container(color: Colors.black.withOpacity(0.36)),
          Center(
            child: FadeTransition(
              opacity: _anim.drive(Tween(begin: 0.75, end: 1.0)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // outer thin gold stroke / glow around popup
                    Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                              color: const Color(0x33FFD9A6), width: 1.6),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x22FFD9A6),
                                blurRadius: 24,
                                spreadRadius: 2,
                                offset: const Offset(0, 8)),
                          ],
                        ),
                      ),
                    ),

                    // main frosted popup
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.42),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                                color: const Color(0x22FFD9A6), width: 1.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // tiny top gold glow strip (centered)
                              Container(
                                height: 6,
                                width: 120,
                                margin: const EdgeInsets.only(bottom: 6),
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

                              // logo
                              Image.asset('assets/images/logo_glitter.jpg',
                                  width: 92, height: 92, fit: BoxFit.contain),
                              const SizedBox(height: 12),

                              // gold lines text (center)
                              const Text(
                                '0% making charges',
                                style: TextStyle(
                                    color: Color(0xFFFFD88A),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '0% Wastage',
                                style: TextStyle(
                                    color: Color(0xFFFFD88A),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),

                              const SizedBox(height: 22),

                              // Buy Now large pill button with gold gradient and inner glow
                              DecoratedBox(
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
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 14,
                                        offset: Offset(0, 8)),
                                    BoxShadow(
                                        color: const Color(0x33FFD9A6),
                                        blurRadius: 20,
                                        spreadRadius: 1),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _close,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 48),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(28)),
                                  ),
                                  child: const Text('Buy Now',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),

                              const SizedBox(height: 6),

                              // small bottom glow line
                              Container(
                                height: 6,
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 8),
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

                    // close (x) button top-right overlapping the card
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Material(
                        color: Colors.transparent,
                        child: InkResponse(
                          onTap: _close,
                          radius: 26,
                          splashColor: Colors.black12,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(colors: [
                                Color(0xFFF7E6B9),
                                Color(0xFFD6B566)
                              ]),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 8,
                                    offset: Offset(0, 4))
                              ],
                              border:
                                  Border.all(color: const Color(0x33FFD9A6)),
                            ),
                            child: const Center(
                                child:
                                    Icon(Icons.close, color: Colors.black87)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
