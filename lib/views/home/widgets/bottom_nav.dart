import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNav({required this.currentIndex, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 12,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 64,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(
            icon: Icon(Icons.home,
                color: currentIndex == 0 ? Colors.black87 : Colors.black45),
            onPressed: () => onTap(0),
          ),
          IconButton(
            icon: Icon(Icons.account_balance_wallet,
                color: currentIndex == 1 ? Colors.black87 : Colors.black45),
            onPressed: () => onTap(1),
          ),
          const SizedBox(width: 48), // space for center button
          IconButton(
            icon: Icon(Icons.pie_chart,
                color: currentIndex == 2 ? Colors.black87 : Colors.black45),
            onPressed: () => onTap(2),
          ),
          IconButton(
            icon: Icon(Icons.person_outline,
                color: currentIndex == 3 ? Colors.black87 : Colors.black45),
            onPressed: () => onTap(3),
          ),
        ]),
      ),
    );
  }
}
