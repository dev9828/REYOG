// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class PriceChartPage extends StatefulWidget {
//   const PriceChartPage({super.key});

//   @override
//   State<PriceChartPage> createState() => _PriceChartPageState();
// }

// class _PriceChartPageState extends State<PriceChartPage> {
//   int selectedRange = 1; // default to 6M
//   final ranges = const ['1M', '6M', '1Y', '3Y', '5Y', 'Max'];

//   // Mock chart data — replace with your GoldViewModel later if needed
//   List<FlSpot> getDataForRange(String range) {
//     switch (range) {
//       case '1M':
//         return const [
//           FlSpot(0, 12.0),
//           FlSpot(1, 12.3),
//           FlSpot(2, 12.4),
//           FlSpot(3, 12.6),
//           FlSpot(4, 12.8)
//         ];
//       case '6M':
//         return const [
//           FlSpot(0, 11.0),
//           FlSpot(1, 11.5),
//           FlSpot(2, 12.0),
//           FlSpot(3, 12.3),
//           FlSpot(4, 12.7),
//           FlSpot(5, 12.8)
//         ];
//       case '1Y':
//         return const [
//           FlSpot(0, 10.0),
//           FlSpot(1, 10.8),
//           FlSpot(2, 11.4),
//           FlSpot(3, 12.0),
//           FlSpot(4, 12.6),
//           FlSpot(5, 12.8)
//         ];
//       case '3Y':
//         return const [
//           FlSpot(0, 9.0),
//           FlSpot(1, 10.0),
//           FlSpot(2, 11.0),
//           FlSpot(3, 12.0),
//           FlSpot(4, 12.8),
//           FlSpot(5, 13.0)
//         ];
//       case '5Y':
//         return const [
//           FlSpot(0, 8.0),
//           FlSpot(1, 9.0),
//           FlSpot(2, 10.0),
//           FlSpot(3, 11.0),
//           FlSpot(4, 12.0),
//           FlSpot(5, 12.8)
//         ];
//       default:
//         return const [
//           FlSpot(0, 7.0),
//           FlSpot(1, 8.5),
//           FlSpot(2, 10.0),
//           FlSpot(3, 11.2),
//           FlSpot(4, 12.4),
//           FlSpot(5, 12.8)
//         ];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final range = ranges[selectedRange];
//     final spots = getDataForRange(range);

//     return Scaffold(
//       backgroundColor: const Color(0xFFFFD65E), // golden background
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFFD65E),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Price Trends',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Toggle buttons for time ranges
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(ranges.length, (i) {
//                 final active = i == selectedRange;
//                 return GestureDetector(
//                   onTap: () => setState(() => selectedRange = i),
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 4),
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: active ? Colors.green.shade800 : Colors.white,
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Text(
//                       ranges[i],
//                       style: TextStyle(
//                         color: active ? Colors.white : Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//             const SizedBox(height: 20),

//             // Line chart section
//             Expanded(
//               child: LineChart(
//                 LineChartData(
//                   gridData: FlGridData(show: false),
//                   borderData: FlBorderData(show: false),
//                   titlesData: FlTitlesData(show: false),
//                   lineBarsData: [
//                     LineChartBarData(
//                       isCurved: true,
//                       color: Colors.orange.shade700,
//                       barWidth: 4,
//                       belowBarData: BarAreaData(
//                         show: true,
//                         color: Colors.orange.withOpacity(0.2),
//                       ),
//                       spots: spots,
//                       dotData: FlDotData(show: false),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Bottom price box + Buy button
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: Column(
//                 children: const [
//                   Text(
//                     'Current gold price for 1gm of 24k gold (99.9%)',
//                     style: TextStyle(color: Colors.black54),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     '₹12,784.56/gm',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green.shade800,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               onPressed: () {},
//               child: const Text(
//                 'Buy',
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
