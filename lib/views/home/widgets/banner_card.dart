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
            // Top rounded colored area (matches your screenshot)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Save for 24K gold", style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 6),
                  Text("at just ₹100/day", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  Text("Withdraw as jewellery, coin or cash", style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),

            // Image & CTA area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
              ),
              child: Column(
                children: [
                  // image that sits above CTA (add your image in assets/images)
                  SizedBox(
                    height: 800,
                    child: Image.asset(
                      'assets/images/golden_banner.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: navigate to start saving flow
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Start Saving tapped')));
                      },
                      child: const Text('Start Saving', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
