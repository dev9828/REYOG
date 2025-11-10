import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../view_models/gold_view_model.dart';
import '../price_chart/price_chart_page.dart';
import 'widgets/banner_card.dart';
import 'widgets/price_tiles.dart';
import 'widgets/bottom_nav.dart';
import '../dashboard/dashboard_page.dart'; // ✅ Import added
import '../profile/profile_page.dart';
import 'insights_page.dart'; // <-- new import

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const InsightsPage(), // <-- replaced placeholder with InsightsPage
    const DashboardPage(),
    const ProfilePage(),
  ];

  void _onTap(int idx) => setState(() => _selectedIndex = idx);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gold,
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GoldViewModel>();
    final priceText = vm.latest?.pricePerOunce != null
        ? '₹ ${vm.latest!.pricePerOunce!.toStringAsFixed(2)}/gm'
        : '--';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top row (logo + price)
          Row(
            children: [
              const Icon(Icons.monetization_on, size: 34, color: Colors.white),
              const SizedBox(width: 12),
              const Text('REYOGO',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const Spacer(),

              /// 🟡 GOLD PRICE BUTTON (like your first screenshot)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomePage(),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_tethering,
                          color: Colors.redAccent, size: 18),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gold Buy Price',
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600)),
                          Text(
                            vm.latest?.timestamp != null
                                ? 'Updated'
                                : 'Dropped...',
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Banner card (big rounded)
          const BannerCard(),

          const SizedBox(height: 18),

          // Price tiles row
          const PriceTiles(),

          const SizedBox(height: 18),

          // more content placeholder
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            child: const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text("More features coming soon...",
                  style: TextStyle(color: Colors.black54)),
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

/// Section that contains the "Dropped" live gold price tile.
/// This is implemented here (home_page.dart) and simulates live data.
class _LiveGoldTileSection extends StatelessWidget {
  const _LiveGoldTileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _LiveGoldTile()),
      ],
    );
  }
}

class _LiveGoldTile extends StatefulWidget {
  const _LiveGoldTile({super.key});

  @override
  State<_LiveGoldTile> createState() => _LiveGoldTileState();
}

class _LiveGoldTileState extends State<_LiveGoldTile> {
  late double _pricePerGm;
  late DateTime _lastUpdated;
  Timer? _timer;
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    // Start mock price (INR per gram). Adjust if you want another currency.
    _pricePerGm = 6225.30;
    _lastUpdated = DateTime.now();
    // Demo update frequency: every 5 seconds (for visible demo). Change to Duration(minutes: 5) for real behaviour.
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _tick());
  }

  void _tick() {
    final change = (_rnd.nextDouble() * 2.0) - 1.0; // -1 .. +1
    final delta = _pricePerGm * (change / 1000); // tiny change
    setState(() {
      _pricePerGm = (_pricePerGm + delta).clamp(0.0, double.infinity);
      _lastUpdated = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formattedPrice() => '₹ ${_pricePerGm.toStringAsFixed(2)} / g';

  String _updatedAgo() {
    final diff = DateTime.now().difference(_lastUpdated);
    if (diff.inSeconds < 5) return 'just now';
    if (diff.inMinutes < 1) return '${diff.inSeconds}s ago';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Dropped',
              style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(_formattedPrice(),
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Updated: ${_updatedAgo()}',
              style: const TextStyle(fontSize: 12, color: Colors.black45)),
        ]),
      ),
    );
  }
}
