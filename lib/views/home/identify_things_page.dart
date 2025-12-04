import 'dart:ui';
import 'package:flutter/material.dart';

class IdentifyThingsPage extends StatefulWidget {
  const IdentifyThingsPage({super.key});
  @override
  State<IdentifyThingsPage> createState() => _IdentifyThingsPageState();
}

class _IdentifyThingsPageState extends State<IdentifyThingsPage> {
  final String _question = 'Tap the golden coin';
  final List<_ChoiceItem> _items = [
    _ChoiceItem('Coin', Icons.monetization_on),
    _ChoiceItem('Star', Icons.star),
    _ChoiceItem('Heart', Icons.favorite),
    _ChoiceItem('Diamond', Icons.diamond_outlined),
  ];

  int _score = 0;
  bool _done = false;

  void _onTapChoice(int idx) {
    if (_done) return;
    final correctIdx = 0;
    final correct = idx == correctIdx;
    setState(() {
      _done = true;
      if (correct) _score += 5;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(correct ? 'Correct!' : 'Try again'),
        content: Text(correct ? 'You earned ₹5' : 'Better luck next time'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _done = false;
              });
            },
            child: const Text('Continue'),
          ),
        ],
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
          // background image (same as other pages)
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.34)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.86,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28.0, vertical: 20.0),
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
                                const SizedBox(height: 12),
                                // logo
                                const Text(
                                  'Find the Gold',
                                  style: TextStyle(
                                      color: Color(0xFFFFD88A),
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 14),
                                // big scene image container (rounded with gold stroke)
                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: const Color(0xFFB78A3C),
                                        width: 2.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6))
                                    ],
                                    image: const DecorationImage(
                                      image:
                                          AssetImage('assets/images/image.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      // subtle inner dark overlay so gold bars pop
                                      Container(
                                          color:
                                              Colors.black.withOpacity(0.06)),
                                      // decorative rounded inner border
                                      Positioned.fill(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color:
                                                      const Color(0x33FFD9A6)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text('Found: 0/10 Gold Bars',
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 18),

                                // Options shown as golden pill buttons (2 columns) - taps call original logic
                                Row(
                                  children: [
                                    Expanded(
                                        child: _goldOptionButton(
                                            0, 'Coin', Icons.monetization_on)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                        child: _goldOptionButton(
                                            1, 'Star', Icons.star)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                        child: _goldOptionButton(
                                            2, 'Heart', Icons.favorite)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                        child: _goldOptionButton(3, 'Diamond',
                                            Icons.diamond_outlined)),
                                  ],
                                ),
                                const SizedBox(height: 18),

                                // bottom action row: large "I Found Them!" and small "Hint"
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
                                          onPressed: () {
                                            // preserve original flow: show a quick dialog to select which item found
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.9),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            16)),
                                              ),
                                              builder: (_) => Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                        'Which item did you find?',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white70)),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: _sheetChoice(
                                                                0,
                                                                'Coin',
                                                                Icons
                                                                    .monetization_on)),
                                                        const SizedBox(
                                                            width: 12),
                                                        Expanded(
                                                            child: _sheetChoice(
                                                                1,
                                                                'Star',
                                                                Icons.star)),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: _sheetChoice(
                                                                2,
                                                                'Heart',
                                                                Icons
                                                                    .favorite)),
                                                        const SizedBox(
                                                            width: 12),
                                                        Expanded(
                                                            child: _sheetChoice(
                                                                3,
                                                                'Diamond',
                                                                Icons
                                                                    .diamond_outlined)),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(28)),
                                          ),
                                          child: const Text('I Found Them!',
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: 72,
                                      height: 48,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // hint: highlight correct option briefly
                                          _showHint();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Color(0xFFB78A3C),
                                              width: 1.6),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24)),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        child: const Text('Hint',
                                            style: TextStyle(
                                                color: Color(0xFFF1DDB2))),
                                      ),
                                    )
                                  ],
                                ),

                                const Spacer(),
                                // bottom glow
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

                      // small gold highlight
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

  // pill style option button used on main screen
  Widget _goldOptionButton(int idx, String label, IconData icon) {
    return GestureDetector(
      onTap: () => _onTapChoice(idx),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFB78A3C), width: 1.6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFF1DDB2)),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFFF1DDB2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // bottom sheet choice used by "I Found Them!" button
  Widget _sheetChoice(int idx, String label, IconData icon) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        _onTapChoice(idx);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  void _showHint() {
    // animate or highlight correct option briefly - here simple dialog/hint
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hint'),
        content: const Text('Look for the round golden coin!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}

class _ChoiceItem {
  final String label;
  final IconData icon;
  _ChoiceItem(this.label, this.icon);
}
