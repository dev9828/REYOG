import 'package:flutter/material.dart';
import 'invest_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // light yellow tone like your app
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Simple illustration (placeholder)
                Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE082),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.insert_chart_rounded,
                      color: Colors.orange, size: 90),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Generate reports instantly.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C3D35), // dark green button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InvestPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Start Investing",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
