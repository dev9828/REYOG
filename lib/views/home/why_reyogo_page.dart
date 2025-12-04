import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WhyReyogoPage extends StatefulWidget {
  const WhyReyogoPage({super.key});
  @override
  State<WhyReyogoPage> createState() => _WhyReyogoPageState();
}

class _WhyReyogoPageState extends State<WhyReyogoPage> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/why_reyogo.mp4')
      ..setLooping(false)
      ..initialize().then((_) {
        setState(() => _initialized = true);
        _controller.setVolume(0.0);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildVideoCard(BuildContext context) {
    final radius = BorderRadius.circular(24.0);
    final mq = MediaQuery.of(context);
    // limit video height so it doesn't overflow on small screens
    final double videoHeight = mq.size.height * 0.6;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: radius),
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: videoHeight,
              width: double.infinity,
              child: AspectRatio(
                aspectRatio:
                    _initialized ? _controller.value.aspectRatio : 16 / 9,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_initialized)
                      VideoPlayer(_controller)
                    else
                      const Center(child: CircularProgressIndicator()),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (!_initialized) return;
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
                          child: Center(
                            child: AnimatedOpacity(
                              opacity:
                                  _initialized && !_controller.value.isPlaying
                                      ? 1.0
                                      : 0.0,
                              duration: const Duration(milliseconds: 250),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black45,
                                    shape: BoxShape.circle),
                                padding: const EdgeInsets.all(12),
                                child: const Icon(Icons.play_arrow,
                                    color: Colors.white, size: 40),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _ctaButton(String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  void _onStart(String cadence) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Start on $cadence pressed')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Why Reyogo?'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            children: [
              _buildVideoCard(context),
              const SizedBox(height: 12),
              _ctaButton('Start on daily', () => _onStart('daily')),
              const SizedBox(height: 8),
              _ctaButton('Start on Weekly', () => _onStart('weekly')),
              const SizedBox(height: 8),
              _ctaButton('Start on monthly', () => _onStart('monthly')),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
