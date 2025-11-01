import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNav({required this.currentIndex, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.black45,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'REYOGO'),
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
