import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Games hub: Spin & Win (with working spinner), Identify the things, Quiz game.
class SpinWheelPage extends StatelessWidget {
  const SpinWheelPage({super.key});

  @override
  Widget build(BuildContext context) {
    // keep the simple list but with the app's visual style card background
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Image.asset('assets/images/background.png', fit: BoxFit.cover),
        Container(color: Colors.black.withOpacity(0.34)),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    const SizedBox(height: 8),
                    _GameCard(
                      title: 'Spin & Win',
                      subtitle: 'Try your luck — win rewards',
                      color: Colors.deepPurple,
                      icon: Icons.casino,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SpinWheelPlayPage())),
                    ),
                    const SizedBox(height: 12),
                    _GameCard(
                      title: 'Identify the things',
                      subtitle: 'Tap the correct item to earn rewards',
                      color: Colors.blue,
                      icon: Icons.search,
                      onTap: () =>
                          Navigator.pushNamed(context, '/identify_things'),
                    ),
                    const SizedBox(height: 12),
                    _GameCard(
                      title: 'Quiz game',
                      subtitle: 'Answer questions and win ₹5 per correct',
                      color: Colors.teal,
                      icon: Icons.quiz,
                      onTap: () => Navigator.pushNamed(context, '/quiz_game'),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 8),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _GameCard(
      {required this.title,
      required this.subtitle,
      required this.color,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Card(
        color: Colors.black.withOpacity(0.5),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(subtitle,
                        style: const TextStyle(color: Colors.white70)),
                  ]),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 18, color: Colors.white38),
          ]),
        ),
      ),
    );
  }
}

/// --- Spinner implementation with updated UI to match "Spin to Win" design ---
class SpinWheelPlayPage extends StatefulWidget {
  const SpinWheelPlayPage({super.key});
  @override
  State<SpinWheelPlayPage> createState() => _SpinWheelPlayPageState();
}

class _SpinWheelPlayPageState extends State<SpinWheelPlayPage>
    with SingleTickerProviderStateMixin {
  static const _prefsKey = 'spin_count';
  final List<String> _labels = [
    'Better luck\nnext time',
    '₹50',
    'Better luck\nnext time',
    '₹150',
    '₹100',
    '₹200'
  ];
  final List<Color> _colors = [
    Colors.redAccent,
    Colors.orange,
    Colors.redAccent.shade100,
    Colors.green,
    Colors.amber,
    Colors.purpleAccent
  ];

  late AnimationController _ctrl;
  Tween<double>? _tween;
  VoidCallback? _controllerListener;
  AnimationStatusListener? _statusListener;

  double _rotation = 0.0;
  bool _spinning = false;
  int _spinCount = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this);
    _loadSpinCount();
  }

  @override
  void dispose() {
    if (_controllerListener != null) _ctrl.removeListener(_controllerListener!);
    if (_statusListener != null) _ctrl.removeStatusListener(_statusListener!);
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _loadSpinCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _spinCount = prefs.getInt(_prefsKey) ?? 0;
    });
  }

  Future<void> _saveSpinCount(int v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, v);
  }

  int _indexOf150() => _labels.indexOf('₹150');

  Future<void> _spin() async {
    if (_spinning) return;
    setState(() => _spinning = true);

    _spinCount++;
    await _saveSpinCount(_spinCount);

    final int segments = _labels.length;
    final double segmentAngle = 2 * pi / segments;

    int targetIndex;
    if (_spinCount % 3 == 0) {
      targetIndex = _indexOf150();
    } else {
      final rnd = Random();
      final choices = List<int>.generate(segments, (i) => i)
        ..remove(_indexOf150());
      targetIndex = choices[rnd.nextInt(choices.length)];
    }

    final int fullSpins = 6 + Random().nextInt(4);
    final double centerAngle = (targetIndex + 0.5) * segmentAngle;
    final double offset = (pi / 2) - centerAngle;
    final double finalRotation = _rotation + fullSpins * 2 * pi + offset;

    if (_controllerListener != null) {
      _ctrl.removeListener(_controllerListener!);
      _controllerListener = null;
    }
    if (_statusListener != null) {
      _ctrl.removeStatusListener(_statusListener!);
      _statusListener = null;
    }

    _tween = Tween(begin: _rotation, end: finalRotation);
    _controllerListener = () {
      setState(() {
        _rotation = _tween!.evaluate(_ctrl);
      });
    };
    _ctrl.addListener(_controllerListener!);

    _statusListener = (status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          _rotation = finalRotation % (2 * pi);
          _spinning = false;
        });

        final double segA = 2 * pi / segments;
        double bestDiff = double.infinity;
        int landed = 0;
        for (int i = 0; i < segments; i++) {
          final double center = (i + 0.5) * segA;
          final double moved = (center - _rotation) % (2 * pi);
          double angleAtPointer = (moved - (pi / 2));
          angleAtPointer = (angleAtPointer + 3 * pi) % (2 * pi) - pi;
          final double diff = angleAtPointer.abs();
          if (diff < bestDiff) {
            bestDiff = diff;
            landed = i;
          }
        }

        final prize = _labels[landed];

        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(prize.contains('₹') ? 'Congratulations!' : 'Result'),
            content: Text(prize),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (_spinCount % 3 == 0) {
                    _spinCount = 0;
                    await _saveSpinCount(0);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _spinning = false);
      }
    };

    _ctrl.addStatusListener(_statusListener!);
    _ctrl.duration = Duration(milliseconds: 3600 + Random().nextInt(1200));
    _ctrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    // UI tuned to reference: centered frosted card with gold border, title, wheel and golden button
    final double wheelSize = min(MediaQuery.of(context).size.width, 520) * 0.72;
    final double cardRadius = 36;
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Image.asset('assets/images/background.png', fit: BoxFit.cover),
        Container(color: Colors.black.withOpacity(0.36)),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.86,
                child: Stack(
                  children: [
                    // outer subtle gold stroke
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(cardRadius + 6),
                          border: Border.all(
                              color: const Color(0x33FFD9A6), width: 1.6),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x22FFD9A6),
                                blurRadius: 22,
                                spreadRadius: 1,
                                offset: const Offset(0, 8)),
                          ],
                        ),
                      ),
                    ),

                    // frosted main card
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          child: Column(
                            children: [
                              // top gold glow strip
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
                              Image.asset('assets/images/logo_glitter.jpg',
                                  width: 200, height: 150, fit: BoxFit.contain),
                              const SizedBox(height: 12),
                              const Text(
                                'Spin to Win!',
                                style: TextStyle(
                                    color: Color(0xFFFFD88A),
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 18),
                              Text('Spins done: $_spinCount',
                                  style:
                                      const TextStyle(color: Colors.white70)),
                              const SizedBox(height: 20),
                              // wheel area centered with golden ring
                              Center(
                                child: SizedBox(
                                  width: wheelSize + 40,
                                  height: wheelSize + 40,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // golden outer ring
                                      Container(
                                        width: wheelSize + 40,
                                        height: wheelSize + 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFFE9B8),
                                              Color(0xFFD1A83F)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.45),
                                                blurRadius: 18,
                                                offset: Offset(0, 8)),
                                            BoxShadow(
                                                color: Color(0x44FFD9A6),
                                                blurRadius: 16,
                                                spreadRadius: 1),
                                          ],
                                        ),
                                      ),
                                      // inner dark stroke ring to match reference
                                      Container(
                                        width: wheelSize + 24,
                                        height: wheelSize + 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black87,
                                          border: Border.all(
                                              color: Colors.black, width: 6),
                                        ),
                                      ),
                                      // rotating wheel (custom paint)
                                      Transform.rotate(
                                        angle: _rotation,
                                        child: CustomPaint(
                                          size: Size(wheelSize, wheelSize),
                                          painter: _WheelPainter(
                                              labels: _labels, colors: _colors),
                                        ),
                                      ),
                                      // center badge
                                      Container(
                                        width: wheelSize * 0.18,
                                        height: wheelSize * 0.18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFF6DE98),
                                                Color(0xFFD6B566)
                                              ]),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 8)
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.emoji_events,
                                            color: Colors.black87),
                                      ),
                                      // pointer at top
                                      Positioned(
                                        top: 6,
                                        child: SizedBox(
                                          width: 34,
                                          height: 34,
                                          child: CustomPaint(
                                              painter: _PointerPainter(
                                                  color:
                                                      Colors.amber.shade700)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // big golden Spin button
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
                                          blurRadius: 18,
                                          offset: Offset(0, 8)),
                                      BoxShadow(
                                          color: Color(0x44FFD9A6),
                                          blurRadius: 18,
                                          spreadRadius: 1),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _spinning ? null : _spin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28)),
                                    ),
                                    child: _spinning
                                        ? const SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.black87))
                                        : const Text('Spin',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600)),
                                  ),
                                ),
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

                    // top-right tiny highlight
                    Positioned(
                      top: 18,
                      right: 20,
                      child: Container(
                        width: 14,
                        height: 14,
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
      ]),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<String> labels;
  final List<Color> colors;
  _WheelPainter({required this.labels, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final int n = labels.length;
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final Offset center = Offset(cx, cy);
    final double radius = min(cx, cy);
    final double sweep = 2 * pi / n;
    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < n; i++) {
      final double start = -pi / 2 + i * sweep;
      paint.color = colors[i % colors.length];
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start,
          sweep, true, paint);

      final label = labels[i];
      final textSpan = TextSpan(
          text: label,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold));
      textPainter.text = textSpan;
      textPainter.layout(maxWidth: radius * 0.6);

      final double angle = start + sweep / 2;
      final double tx = center.dx + cos(angle) * radius * 0.62;
      final double ty = center.dy + sin(angle) * radius * 0.62;

      canvas.save();
      canvas.translate(tx, ty);
      canvas.rotate(angle + pi / 2);
      textPainter.paint(
          canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }

    final border = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black12
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _PointerPainter extends CustomPainter {
  final Color color;
  _PointerPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
    final border = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(size.width / 2, size.height * 0.9), 2, border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
