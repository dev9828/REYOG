import 'package:flutter/material.dart';

class InvestPage extends StatefulWidget {
  const InvestPage({super.key});

  @override
  State<InvestPage> createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage> {
  double amount = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C3D35),
        title: const Text("Investment Plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Projected gold grams in 5 years",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            const Text(
              "17.05 gm",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Valued at ₹3.54L (approx.)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              "Total paid amount in 5 years: ₹2.73L",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    "Setup SIP",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ToggleButtons(
                    isSelected: const [true, false, false],
                    borderRadius: BorderRadius.circular(12),
                    fillColor: const Color(0xFF1C3D35),
                    selectedColor: Colors.white,
                    color: Colors.black54,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Daily"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Weekly"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Monthly"),
                      ),
                    ],
                    onPressed: (index) {},
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "₹${amount.toInt()}",
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: amount,
                    min: 50,
                    max: 500,
                    divisions: 9,
                    label: amount.toStringAsFixed(0),
                    activeColor: const Color(0xFF1C3D35),
                    onChanged: (value) {
                      setState(() => amount = value);
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C3D35),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Proceed",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
