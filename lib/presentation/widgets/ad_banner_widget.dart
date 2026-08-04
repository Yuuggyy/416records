import 'package:flutter/material.dart';

/// Web-compatible banner ad widget — shows a simulated ad banner
/// On native, this would use AdMob BannerAd
class AdBannerWidget extends StatefulWidget {
  final double? maxHeight;
  const AdBannerWidget({super.key, this.maxHeight});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  bool _showAd = true;

  @override
  Widget build(BuildContext context) {
    if (!_showAd) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      height: 50,
      color: const Color(0xFF1a1a2e),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.ads_click, color: Colors.white54, size: 16),
          const SizedBox(width: 8),
          const Text(
            'Publicite',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => setState(() => _showAd = false),
            child: const Icon(Icons.close, color: Colors.white38, size: 16),
          ),
        ],
      ),
    );
  }
}
