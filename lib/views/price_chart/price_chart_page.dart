import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriceChartPage extends StatefulWidget {
  const PriceChartPage({super.key});

  @override
  State<PriceChartPage> createState() => _PriceChartPageState();
}

class _PriceChartPageState extends State<PriceChartPage> {
  int selectedRange = 1; // default to 6M
  final ranges = const ['1M', '6M', '1Y', '3Y', '5Y', 'Max'];

  // Mock chart data — replace with your GoldViewModel later if needed
  List<FlSpot> getDataForRange(String range) {
    switch (range) {
      case '1M':
        return const [
          FlSpot(0, 12.0),
          FlSpot(1, 12.3),
          FlSpot(2, 12.4),
          FlSpot(3, 12.6),
          FlSpot(4, 12.8)
        ];
      case '6M':
        return const [
          FlSpot(0, 11.0),
          FlSpot(1, 11.5),
          FlSpot(2, 12.0),
          FlSpot(3, 12.3),
          FlSpot(4, 12.7),
          FlSpot(5, 12.8)
        ];
      case '1Y':
        return const [
          FlSpot(0, 10.0),
          FlSpot(1, 10.8),
          FlSpot(2, 11.4),
          FlSpot(3, 12.0),
          FlSpot(4, 12.6),
          FlSpot(5, 12.8)
        ];
      case '3Y':
        return const [
          FlSpot(0, 9.0),
          FlSpot(1, 10.0),
          FlSpot(2, 11.0),
          FlSpot(3, 12.0),
          FlSpot(4, 12.8),
          FlSpot(5, 13.0)
        ];
      case '5Y':
        return const [
          FlSpot(0, 8.0),
          FlSpot(1, 9.0),
          FlSpot(2, 10.0),
          FlSpot(3, 11.0),
          FlSpot(4, 12.0),
          FlSpot(5, 12.8)
        ];
      default:
        return const [
          FlSpot(0, 7.0),
          FlSpot(1, 8.5),
          FlSpot(2, 10.0),
          FlSpot(3, 11.2),
          FlSpot(4, 12.4),
          FlSpot(5, 12.8)
        ];
    }
  }

  // Helper to produce nice Y axis values for mock data
  double _minY(List<FlSpot> s) =>
      s.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 2;
  double _maxY(List<FlSpot> s) =>
      s.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 6;

  @override
  Widget build(BuildContext context) {
    final range = ranges[selectedRange];
    final spots = getDataForRange(range);

    final double cardRadius = 36;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.36)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.86,
                  child: Stack(
                    children: [
                      // outer gold thin stroke + glow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(cardRadius + 6),
                            border: Border.all(
                                color: const Color(0x33FFD9A6), width: 1.4),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0x22FFD9A6),
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 8)),
                            ],
                          ),
                        ),
                      ),

                      // frosted card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(cardRadius),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.36),
                              borderRadius: BorderRadius.circular(cardRadius),
                              border: Border.all(
                                  color: const Color(0x22FFD9A6), width: 1.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36.0, vertical: 22.0),
                            child: Column(
                              children: [
                                // top glow bar
                                Container(
                                  height: 6,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        const Color(0x66FFD9A6),
                                        Colors.transparent
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // logo
                                Image.asset('assets/images/logo_glitter.jpg',
                                    width: 92, height: 92, fit: BoxFit.contain),
                                const SizedBox(height: 12),
                                const Text(
                                  'Gold Price Trend',
                                  style: TextStyle(
                                      color: Color(0xFFFFD88A),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 18),

                                // chart container (centered)
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.0),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        // allow column to take available space and let chart expand
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          // Chart card (rounded, dark grid area)
                                          Expanded(
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.28),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: const Color(
                                                        0x33FFD9A6)),
                                              ),
                                              child: LineChart(
                                                LineChartData(
                                                  minY: _minY(spots),
                                                  maxY: _maxY(spots),
                                                  gridData: FlGridData(
                                                    show: true,
                                                    drawVerticalLine: true,
                                                    getDrawingHorizontalLine:
                                                        (v) => FlLine(
                                                            color:
                                                                Colors.white12,
                                                            strokeWidth: 1),
                                                    getDrawingVerticalLine:
                                                        (v) => FlLine(
                                                            color:
                                                                Colors.white12,
                                                            strokeWidth: 1),
                                                  ),
                                                  borderData: FlBorderData(
                                                    show: true,
                                                    border: Border(
                                                      left: BorderSide(
                                                          color: Colors.white24,
                                                          width: 1),
                                                      bottom: BorderSide(
                                                          color: Colors.white24,
                                                          width: 1),
                                                      top: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                      right: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                  ),
                                                  titlesData: FlTitlesData(
                                                    leftTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        interval: ((_maxY(
                                                                    spots) -
                                                                _minY(spots)) /
                                                            5),
                                                        // reduce reserved size to avoid horizontal overflow on narrow screens
                                                        reservedSize: 44,
                                                        getTitlesWidget:
                                                            (value, meta) =>
                                                                Text(
                                                          value
                                                              .toInt()
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        reservedSize: 28,
                                                        interval: 1,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          // map x index to years for mock presentation
                                                          final labels = [
                                                            '2012',
                                                            '2014',
                                                            '2016',
                                                            '2018',
                                                            '2020',
                                                            '2024'
                                                          ];
                                                          final idx =
                                                              value.toInt();
                                                          final text = (idx >=
                                                                      0 &&
                                                                  idx <
                                                                      labels
                                                                          .length)
                                                              ? labels[idx]
                                                              : '';
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 6.0),
                                                            child: Text(text,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white70,
                                                                    fontSize:
                                                                        12)),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    topTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                            showTitles: false)),
                                                    rightTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                            showTitles: false)),
                                                  ),
                                                  lineBarsData: [
                                                    LineChartBarData(
                                                      spots: spots,
                                                      isCurved: true,
                                                      color: const Color(
                                                          0xFFFFD65E),
                                                      barWidth: 4,
                                                      dotData:
                                                          FlDotData(show: true),
                                                      belowBarData: BarAreaData(
                                                          show: true,
                                                          color: const Color(
                                                                  0xFFFFD65E)
                                                              .withOpacity(
                                                                  0.12)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          // small caption under chart like reference
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.calendar_today,
                                                  color: Color(0xFFD9C79A),
                                                  size: 18),
                                              SizedBox(width: 8),
                                              Text('Last 12 Years',
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFFD9C79A))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // Range selector pills — horizontally scrollable to avoid overflow on narrow screens
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(ranges.length, (i) {
                                      final active = i == selectedRange;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: GestureDetector(
                                          onTap: () =>
                                              setState(() => selectedRange = i),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              gradient: active
                                                  ? const LinearGradient(
                                                      colors: [
                                                          Color(0xFFF7E6B9),
                                                          Color(0xFFD6B566)
                                                        ])
                                                  : null,
                                              color: active
                                                  ? null
                                                  : Colors.black
                                                      .withOpacity(0.22),
                                              border: Border.all(
                                                  color:
                                                      const Color(0x33FFD9A6)),
                                            ),
                                            child: Text(
                                              ranges[i],
                                              style: TextStyle(
                                                  color: active
                                                      ? Colors.black87
                                                      : const Color(0xFFD9C79A),
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),

                                const SizedBox(height: 18),
                                // bottom info box (current price summary) + Buy button
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.28),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: const Color(0x33FFD9A6)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                                'Current gold price for 1gm of 24k gold (99.9%)',
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 12)),
                                            SizedBox(height: 6),
                                            Text('₹12,784.56/gm',
                                                style: TextStyle(
                                                    color: Color(0xFFFFD65E),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFFFD65E),
                                        foregroundColor: Colors.black87,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 14),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                      onPressed: () {},
                                      child: const Text('Buy',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // tiny top-right highlight
                      Positioned(
                        top: 18,
                        right: 22,
                        child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                                color: Color(0x22FFD9A6),
                                shape: BoxShape.circle)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
