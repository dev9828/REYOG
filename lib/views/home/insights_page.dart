// filepath: /Users/devendrakumargupta/StudioProjects/Gold_price/lib/views/home/insights_page.dart
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'q': 'What is REYOGO?',
        'a':
            'REYOGO is a user-friendly app that tracks gold prices and provides insights to help users make informed decisions. It aggregates market data, displays trends, and offers educational resources designed for both beginners and experienced buyers.'
      },
      {
        'q': 'How often are prices updated?',
        'a':
            'Prices are refreshed frequently during market hours to keep you informed about intraday movements. Minor delays may occur depending on network connectivity and data source latency — always check the timestamp shown with each quote.'
      },
      {
        'q': 'Are the prices guaranteed for transactions?',
        'a':
            'No. The prices shown in the app are indicative market prices intended for tracking and research. Actual transaction prices can vary due to local premiums, making charges, taxes, and dealer margins.'
      },
      {
        'q': 'How can I suggest a feature or report an issue?',
        'a':
            'You can send feedback through the app\'s support or feedback option. Our team reviews suggestions regularly and prioritizes features that improve usability and reliability.'
      },
      {
        'q': 'Is my personal data safe?',
        'a':
            'We follow best practices to protect user data. Sensitive information is stored securely and only used for app functionality. Refer to the app\'s privacy policy for full details.'
      },
    ];

    final blogs = [
      {
        'title': 'Understanding Gold: A Simple Guide',
        'date': 'Nov 04, 2025',
        'excerpt':
            'Learn the basics of what drives gold prices and how to interpret simple signals.',
        'content':
            'Gold is influenced by macroeconomic factors like inflation expectations, currency movements, central bank policy, and geopolitical events. Investors often view gold as a hedge against currency depreciation and inflation. When considering physical gold, include storage, insurance, and taxes in your cost calculations. Diversify and avoid timing the market based on short-term headlines.'
      },
      {
        'title': 'Reading Price Charts — Practical Tips',
        'date': 'Oct 28, 2025',
        'excerpt':
            'An introduction to chart reading, trend identification, and simple indicators.',
        'content':
            'Price charts condense market action into visual patterns. Identify trend direction using moving averages, spot momentum with RSI or MACD, and confirm signals with volume when available. Practice interpreting charts on historical data; combine technical cues with fundamental context for more reliable decisions.'
      },
      {
        'title': 'Physical vs Paper Gold: What to Choose?',
        'date': 'Oct 10, 2025',
        'excerpt':
            'Pros and cons of holding physical bullion versus exchange-traded or digital gold.',
        'content':
            'Physical gold offers direct ownership but has storing and liquidity considerations. Paper gold (ETFs, futures) provides easier trading and lower immediate custody overheads but introduces counterparty and tracking risks. Choose based on your objectives: long-term store of value or short-term trading.'
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.gold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('REYOGO Insights', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: const [
                    Icon(Icons.lightbulb_outline, color: Colors.amber),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Insights — FAQs and short articles to help you understand gold and the features in REYOGO.',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // FAQs
            const Text('Frequently Asked Questions',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: faqs.map((f) {
                  return ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(f['q']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                    children: [
                      Text(f['a']!, style: const TextStyle(color: Colors.black87, height: 1.4)),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Blogs
            const Text('Latest Articles',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              children: blogs.map((b) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlogDetailPage(
                          title: b['title']!,
                          date: b['date']!,
                          content: b['content']!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(b['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text(b['excerpt']!, style: const TextStyle(color: Colors.black54)),
                                const SizedBox(height: 8),
                                Text(b['date']!, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black26),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

class BlogDetailPage extends StatelessWidget {
  final String title;
  final String date;
  final String content;

  const BlogDetailPage({
    super.key,
    required this.title,
    required this.date,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppTheme.gold,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(content, style: const TextStyle(color: Colors.black87, height: 1.5)),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Related Reading', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Explore more articles in the Insights section to deepen your understanding of gold markets, chart reading, and practical buying tips.',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}