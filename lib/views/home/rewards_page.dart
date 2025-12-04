import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  int _tabIndex = 0; // 0 = Inbox, 1 = Transaction

  @override
  Widget build(BuildContext context) {
    final double cardRadius = 36;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.34)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.86,
                  child: Stack(
                    children: [
                      // outer subtle gold stroke / glow
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
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // frosted card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(cardRadius),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.36),
                              borderRadius: BorderRadius.circular(cardRadius),
                              border: Border.all(
                                  color: const Color(0x22FFD9A6), width: 1.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28.0, vertical: 20.0),
                            child: Column(
                              children: [
                                // top glow line
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
                                const SizedBox(height: 12),
                                // logo

                                // Custom tabs row (large pill buttons like reference)
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              setState(() => _tabIndex = 0),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 220),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              gradient: _tabIndex == 0
                                                  ? const LinearGradient(
                                                      colors: [
                                                          Color(0xFFF7E6B9),
                                                          Color(0xFFD6B566)
                                                        ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter)
                                                  : null,
                                              color: _tabIndex == 0
                                                  ? null
                                                  : Colors.black
                                                      .withOpacity(0.28),
                                              border: Border.all(
                                                color: _tabIndex == 0
                                                    ? Colors.transparent
                                                    : const Color(0xFF3B2F20)
                                                        .withOpacity(0.5),
                                                width: 1.0,
                                              ),
                                              boxShadow: _tabIndex == 0
                                                  ? [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.45),
                                                          blurRadius: 14,
                                                          offset: const Offset(
                                                              0, 6))
                                                    ]
                                                  : [],
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Inbox',
                                                style: TextStyle(
                                                  color: _tabIndex == 0
                                                      ? Colors.black87
                                                      : const Color(0xFFD9C79A),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              setState(() => _tabIndex = 1),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 220),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: _tabIndex == 1
                                                  ? AppTheme.goldDark
                                                  : Colors.transparent,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFB78A3C),
                                                  width: 1.2),
                                              boxShadow: _tabIndex == 1
                                                  ? [
                                                      BoxShadow(
                                                          color: AppTheme
                                                              .goldDark
                                                              .withOpacity(
                                                                  0.22),
                                                          blurRadius: 12,
                                                          offset: const Offset(
                                                              0, 6))
                                                    ]
                                                  : [],
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Transaction',
                                                style: TextStyle(
                                                  color: _tabIndex == 1
                                                      ? Colors.white
                                                      : const Color(0xFFD9C79A),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // descriptive text
                               
                                const SizedBox(height: 50),

                                // content area (scrollable list inside fixed height)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: _tabIndex == 0
                                        ? _inboxList(context)
                                        : _transactionList(context),
                                  ),
                                ),

                                const SizedBox(height: 12),
                                // Bottom CTA row
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                  'Wanna know your earnings?',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppTheme.goldDark,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                              ),
                                              onPressed: () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Opening earnings...')));
                                              },
                                              child: const Text('Click',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // bottom glow bar
                                Container(
                                  height: 8,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        const Color(0x44FFD9A6),
                                        Colors.transparent
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // tiny top-right highlight like other pages
                      Positioned(
                        top: 18,
                        right: 22,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                              color: Color(0x22FFD9A6), shape: BoxShape.circle),
                        ),
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

  Widget _inboxList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        return _GoldCardTile(
          icon: Icons.card_giftcard,
          title: i == 0
              ? 'Exclusive Welcome Offer - 5gm Gold Free!'
              : 'Offer #${i + 1}',
          subtitle: i == 0
              ? 'Expires: 31/12/2024'
              : 'You earned a reward worth ₹${25 * (i + 1)}',
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Open inbox item $i')));
          },
        );
      },
    );
  }

  Widget _transactionList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        return _GoldCardTile(
          icon: Icons.receipt_long,
          title: 'Txn #${1000 + i}',
          subtitle: '₹${(i + 1) * 150} — ${i % 2 == 0 ? 'Success' : 'Pending'}',
          trailing: Text(' ${i % 2 == 0 ? 'Cr' : 'Dr'}',
              style: const TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.bold)),
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Open transaction $i')));
          },
        );
      },
    );
  }
}

class _GoldCardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _GoldCardTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Matches reference: big rounded gold-outlined tile with dark interior
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.22),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFB78A3C), width: 2.0),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x33FFD9A6)),
              ),
              child: Icon(icon, color: AppTheme.goldDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(subtitle,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ]),
            ),
            if (trailing != null)
              trailing!
            else
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white38, size: 16),
          ],
        ),
      ),
    );
  }
}
