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


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const Center(child: Text('REYOGO Insights')),
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
                      builder: (_) => const PriceChartPage(),
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
