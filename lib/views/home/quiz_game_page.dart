import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class QuizGamePage extends StatefulWidget {
  const QuizGamePage({super.key});
  @override
  State<QuizGamePage> createState() => _QuizGamePageState();
}

class _QuizGamePageState extends State<QuizGamePage> {
  final List<_Q> _questions = [
    _Q('What is the chemical symbol for Gold?', ['Au', 'Ag', 'Fe', 'Hg'], 0),
    _Q('Which is the color of pure gold?', ['Silver', 'Red', 'Yellow', 'Black'],
        2),
    _Q('Which unit commonly used for gold weight?',
        ['Gram', 'Litre', 'Meter', 'Second'], 0),
    _Q('Which metal is more reactive than gold?',
        ['Gold', 'Silver', 'Iron', 'Titanium'], 2),
    _Q('Which country is largest producer of gold?',
        ['China', 'USA', 'India', 'Australia'], 0),
  ];

  int _index = 0;
  int _score = 0;

  // UI state
  int? _selected; // selected option index (temporary visual)
  bool _answered =
      false; // whether current question already answered (locks further taps)
  Timer? _autoNextTimer;

  @override
  void dispose() {
    _autoNextTimer?.cancel();
    super.dispose();
  }

  void _answer(int choice) {
    if (_answered) return;
    setState(() {
      _selected = choice;
      _answered = true;
      if (choice == _questions[_index].correct) _score += 5;
    });

    // small delay so user sees selection then advance / show result (keeps original scoring behavior)
    _autoNextTimer = Timer(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      if (_index < _questions.length - 1) {
        setState(() {
          _index++;
          _selected = null;
          _answered = false;
        });
      } else {
        _showResult();
      }
    });
  }

  void _nextQuestionManual() {
    if (_answered) return; // if already answered auto-advance will handle
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
        _answered = false;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Complete'),
        content: Text('You earned ₹$_score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _index = 0;
                _score = 0;
                _selected = null;
                _answered = false;
              });
            },
            child: const Text('Play again'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  Widget _optionButton(int i, String text) {
    final bool isSelected = _selected == i;
    final correct = _questions[_index].correct == i;
    Color borderColor = const Color(0xFFB78A3C);
    Color fill = Colors.transparent;
    Widget? suffix;
    if (isSelected) {
      // selected styling: golden glow; if correct show check icon
      borderColor = const Color(0xFFD6B566);
      fill = const Color(0x22FFD9A6);
      suffix = Icon(correct ? Icons.check_circle : Icons.cancel,
          color: correct ? Colors.greenAccent : Colors.redAccent, size: 20);
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => _answer(i),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: borderColor, width: 1.8),
            boxShadow: [
              BoxShadow(
                color: isSelected ? const Color(0x33FFD9A6) : Colors.black26,
                blurRadius: isSelected ? 14 : 6,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              if (suffix != null) ...[const SizedBox(width: 8), suffix],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_index];
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
                  height: MediaQuery.of(context).size.height * 0.86,
                  child: Stack(
                    children: [
                      // gold outer stroke
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
                                const SizedBox(height: 12),
                                Image.asset('assets/images/logo_glitter.jpg',
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.contain),
                                const SizedBox(height: 100),
                                const Text(
                                  'Gold IQ Challenge',
                                  style: TextStyle(
                                      color: Color(0xFFFFD88A),
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  q.question,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                ),
                                const SizedBox(height: 22),

                                // options grid (2 columns)
                                Row(
                                  children: [
                                    _optionButton(0, 'A) ${q.options[0]}'),
                                    _optionButton(1, 'B) ${q.options[1]}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    _optionButton(2, 'C) ${q.options[2]}'),
                                    _optionButton(3, 'D) ${q.options[3]}'),
                                  ],
                                ),

                                const SizedBox(height: 18),
                                // question counter
                                Text(
                                    'Question ${_index + 1} of ${_questions.length}',
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 12),
                                // Next Question button (gold)
                                SizedBox(
                                  width: 220,
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
                                            blurRadius: 14,
                                            offset: Offset(0, 4)),
                                      ],
                                    ),
                                    child: TextButton(
                                      onPressed: _nextQuestionManual,
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16)),
                                      child: const Text(
                                        'Next Question',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Q {
  final String question;
  final List<String> options;
  final int correct;
  _Q(this.question, this.options, this.correct);
}
