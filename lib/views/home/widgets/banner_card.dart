import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          children: [
            // Top colored header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Save for 24K gold",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text("at just ₹100/day",
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),

            // Image & CTA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(18)),
              ),
              child: Column(children: [
                SizedBox(
                  height: 160,
                  child: Image.asset(
                    'assets/images/golden_banner.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                        child:
                            Icon(Icons.image, size: 60, color: Colors.black12)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.goldDark),
                    child: const Text('Start Saving',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
