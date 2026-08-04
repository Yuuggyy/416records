import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/ad_service.dart';

/// Dialog that prompts user to watch a rewarded ad to unlock content
/// Used for: unlocking HD video, bonus votes, behind-the-scenes access, downloading songs
class RewardedAdDialog extends StatelessWidget {
  final String title;
  final String description;
  final String rewardLabel;
  final IconData rewardIcon;
  final VoidCallback onRewardEarned;

  const RewardedAdDialog({
    super.key,
    required this.title,
    required this.description,
    required this.rewardLabel,
    required this.rewardIcon,
    required this.onRewardEarned,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String description,
    required String rewardLabel,
    required IconData rewardIcon,
    required VoidCallback onRewardEarned,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RewardedAdDialog(
        title: title,
        description: description,
        rewardLabel: rewardLabel,
        rewardIcon: rewardIcon,
        onRewardEarned: onRewardEarned,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adService = context.read<AdService>();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(rewardIcon, color: const Color(0xFF1a1a2e), size: 32),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(description, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a2e).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle_filled, color: Color(0xFF1a1a2e)),
                const SizedBox(width: 8),
                Text(rewardLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Regarde une video de 30 secondes pour debloquer',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Plus tard'),
        ),
        FilledButton.icon(
          onPressed: () async {
            Navigator.pop(context);
            final success = await adService.showRewardedAd(
              onReward: (amount) {
                onRewardEarned();
              },
            );
            if (!success && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pub non disponible pour le moment. Reessayez plus tard.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Regarder'),
        ),
      ],
    );
  }
}
