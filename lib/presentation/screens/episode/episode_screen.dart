import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/ad_service.dart';
import '../../../core/models/episode_model.dart';

/// Episode screen with simulated pre-roll ad before video playback
/// On web, we show a simulated ad overlay then a video placeholder
class EpisodeScreen extends StatefulWidget {
  final EpisodeModel episode;

  const EpisodeScreen({super.key, required this.episode});

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  bool _isPreRollPlaying = true;
  bool _isVideoReady = false;

  @override
  void initState() {
    super.initState();
    _startPreRollThenVideo();
  }

  Future<void> _startPreRollThenVideo() async {
    final adService = context.read<AdService>();
    setState(() => _isPreRollPlaying = true);
    await adService.showPreRollAd();
    if (!mounted) return;
    setState(() {
      _isPreRollPlaying = false;
      _isVideoReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video placeholder
          if (_isVideoReady && !_isPreRollPlaying)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle_filled, size: 80, color: Colors.white70),
                  const SizedBox(height: 16),
                  Text(
                    widget.episode.title,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Episode ${widget.episode.episodeNumber}',
                    style: const TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Lecteur video - Web demo',
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ],
              ),
            )
          else if (_isPreRollPlaying)
            // Pre-roll ad simulation
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.ads_click, size: 80, color: Colors.amber),
                  const SizedBox(height: 16),
                  const Text(
                    'Publicite',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Votre episode commence dans un instant...',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(color: Colors.amber),
                ],
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),

          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
