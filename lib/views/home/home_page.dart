import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../view_models/gold_view_model.dart';
import '../price_chart/price_chart_page.dart';
import 'widgets/banner_card.dart';
import 'widgets/bottom_nav.dart';
import '../dashboard/dashboard_page.dart';
import '../profile/profile_page.dart';
import 'insights_page.dart';
import 'rewards_page.dart'; // <-- added import
import 'spin_wheel_page.dart'; // <-- add this import
import 'why_reyogo_page.dart'; // <-- add this import

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const InsightsPage(),
    const DashboardPage(),
    const ProfilePage(),
  ];

  void _onTap(int idx) => setState(() => _selectedIndex = idx);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a full-screen background image with a dim overlay, then place
      // the existing SafeArea content on top so the homepage matches app theme.
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.34)), // subtle dim
          SafeArea(child: _pages[_selectedIndex]),
        ],
      ),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Top row: logo + price bubble + actions
        Row(children: [
          // replace small icon with logo image sized to match original icon (34x34)
          SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(
              'assets/images/logo_glitter.jpg',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 5),
          const Text('REYOGO',
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const Spacer(),
          // price bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(28)),
            child: Row(children: [
              const Icon(Icons.local_offer, color: Colors.orange, size: 18),
              const SizedBox(width: 8),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Current gold rate',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7), fontSize: 10)),
                Text(priceText,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12)),
              ]),
            ]),
          ),
          const SizedBox(width: 12),
          // notification & rewards
          IconButton(
              onPressed: () {
                // TODO: open inbox/transactions
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Inbox')));
              },
              icon: const Icon(Icons.notifications_none, color: Colors.white)),
          IconButton(
              onPressed: () {
                // open Rewards / Inbox & Transaction page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RewardsPage()),
                );
              },
              icon: const Icon(Icons.card_giftcard, color: Colors.white)),
        ]),
        const SizedBox(height: 18),

        // Greeting card with stats (rounded big card like designs)
        Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Row(children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hi, Devendra',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      const Text("Let's get started",
                          style: TextStyle(color: Colors.black54)),
                      const SizedBox(height: 14),
                      // highlighted box with making charge / wastage
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(children: [
                          Text('0% making charge',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 6),
                          Text('0% wastage',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () {
                                // book now flow
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const PriceChartPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.goldDark,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Text('Book now'),
                            ),
                          ),
                        ]),
                      ),
                    ]),
              ),
              const SizedBox(width: 12),
              // small profile circle or avatar
              CircleAvatar(
                  radius: 34,
                  backgroundColor: AppTheme.cardBg,
                  child: const Icon(Icons.person, size: 36)),
            ]),
          ),
        ),

        const SizedBox(height: 18),

        // Banner / promo card
        const BannerCard(),

        const SizedBox(height: 16),

        // Graph / Trends card
        Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PriceChartPage())),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Price Trends',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        const Text('View last 1M / 6M / 1Y trends',
                            style: TextStyle(color: Colors.black54)),
                      ]),
                ),
                Icon(Icons.show_chart, color: AppTheme.goldDark, size: 36),
              ]),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Saving plans row
        const Text('Gold saving plans',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(children: [
                  const Text('Daily',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('₹100/day', style: TextStyle(color: Colors.black54)),
                ]),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(children: [
                  const Text('Weekly',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('₹700/week', style: TextStyle(color: Colors.black54)),
                ]),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(children: [
                  const Text('Monthly',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('₹3000/mo', style: TextStyle(color: Colors.black54)),
                ]),
              ),
            ),
          ),
        ]),

        const SizedBox(height: 16),

        // Spin wheel / CTA and Spend tracker
        Row(children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(children: [
                  const Text('Spin & Win',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Win gold up to ₹600',
                      style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SpinWheelPage()),
                        );
                      },
                      child: const Text('Play now'))
                ]),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(children: [
                  const Text('Spend Tracker',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Track rounding & saves',
                      style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: () {}, child: const Text('Open'))
                ]),
              ),
            ),
          ),
        ]),

        const SizedBox(height: 18),

        // Tailored for you list
        const Text('Tailored for you',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Column(children: [
          _ActionTile(
              title: 'Why Reyogo',
              subtitle: 'Watch a short video about saving gold',
              icon: Icons.play_circle_fill,
              onTap: () {
                debugPrint('Why Reyogo pressed — opening video page');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WhyReyogoPage()),
                );
              }),
          _ActionTile(
              title: 'User success story',
              subtitle: 'Read stories',
              icon: Icons.star_border),
          _ActionTile(
              title: 'Brands connected with us',
              subtitle: 'Trusted partners',
              icon: Icons.handshake),
        ]),

        const SizedBox(height: 120),
      ]),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionTile(
      {required this.title,
      required this.subtitle,
      required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
            backgroundColor: AppTheme.cardBg,
            child: Icon(icon, color: AppTheme.goldDark)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

/// Section that contains the "Dropped" live gold price tile.
/// This is implemented here (home_page.dart) and simulates live data.
class _LiveGoldTileSection extends StatelessWidget {
  const _LiveGoldTileSection();

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
  const _LiveGoldTile();

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
