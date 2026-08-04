import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/ad_service.dart';
import '../../widgets/ad_banner_widget.dart';

/// Main home screen with episode list, clips, and ad integration
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adService = context.watch<AdService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('416 Records', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => _showAdStats(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Featured episode
                _buildFeaturedEpisode(context),
                const SizedBox(height: 24),

                // Episode list
                _buildSectionTitle('Episodes'),
                ..._buildEpisodeList(context),
                const SizedBox(height: 24),

                // Clips & behind the scenes (rewarded)
                _buildSectionTitle('Exclusivites (debloquer avec pub)'),
                ..._buildExclusiveContent(context),
                const SizedBox(height: 24),

                // Vote section
                _buildSectionTitle('Vote pour ton artiste'),
                _buildVoteCard(context),
                const SizedBox(height: 24),

                // Ad stats mini
                if (adService.totalImpressions > 0)
                  _buildMiniStats(context, adService),
              ],
            ),
          ),
          // Persistent bottom banner
          const AdBannerWidget(),
        ],
      ),
    );
  }

  Widget _buildFeaturedEpisode(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to episode with pre-roll
        context.read<AdService>().showPreRollAd();
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(Icons.play_circle_filled, size: 64, color: Colors.white70),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Episode 1', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const Text(
                    'Recrutement',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.ads_click, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Pub pre-roll 10s',
                        style: TextStyle(color: Colors.amber.shade300, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1a1a2e)),
      ),
    );
  }

  List<Widget> _buildEpisodeList(BuildContext context) {
    final episodes = [
      {'num': '1', 'title': 'Recrutement', 'desc': '40 candidats, parking de Kinshasa'},
      {'num': '2', 'title': 'Direction Artistique', 'desc': '20 candidats, Chantier Naval'},
      {'num': '3', 'title': 'Clash', 'desc': '12 candidats, duels en freestyle'},
      {'num': '4', 'title': 'Club', 'desc': '6 candidats, Millionaire Club'},
      {'num': '5', 'title': 'Finale Festival', 'desc': '3 finalistes, grand live'},
    ];

    return episodes.map((ep) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF1a1a2e),
            child: Text(ep['num']!, style: const TextStyle(color: Colors.white)),
          ),
          title: Text(ep['title']!, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(ep['desc']!),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.ads_click, size: 16, color: Colors.amber),
              const SizedBox(width: 8),
              const Icon(Icons.play_arrow),
            ],
          ),
          onTap: () {
            // Show pre-roll then episode
            context.read<AdService>().showPreRollAd();
          },
        ),
      );
    }).toList();
  }

  List<Widget> _buildExclusiveContent(BuildContext context) {
    final exclusives = [
      {'title': 'Coulisses E1', 'icon': Icons.movie, 'locked': true},
      {'title': 'Interview artiste', 'icon': Icons.mic, 'locked': true},
      {'title': 'Rehearsal freestyle', 'icon': Icons.music_note, 'locked': true},
    ];

    return exclusives.map((item) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(item['icon'] as IconData, color: const Color(0xFF1a1a2e)),
          title: Text(item['title'] as String),
          trailing: item['locked'] as bool
              ? const Icon(Icons.lock, color: Colors.amber)
              : const Icon(Icons.play_arrow),
          onTap: () {
            if (item['locked'] as bool) {
              // Show rewarded ad dialog to unlock
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Debloquer: ${item['title']}'),
                  content: const Text('Regarde une pub de 30 secondes pour acceder a ce contenu exclusif.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Plus tard'),
                    ),
                    FilledButton.icon(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await context.read<AdService>().showRewardedAd(
                          onReward: (amount) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Contenu debloque !')),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Regarder la pub'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      );
    }).toList();
  }

  Widget _buildVoteCard(BuildContext context) {
    return Card(
      color: const Color(0xFF1a1a2e),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Vote pour ton candidat prefere',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              '1 vote = 1 vote gratuit (1x/jour)\nVotes supplementaires = regarde une pub',
              style: TextStyle(color: Colors.white60, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                // Show interstitial before voting
                context.read<AdService>().showInterstitialAd();
              },
              icon: const Icon(Icons.how_to_vote),
              label: const Text('Voter maintenant'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStats(BuildContext context, AdService adService) {
    final breakdown = adService.revenueBreakdown;
    return Card(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statistiques pub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 8),
            Text('Impressions totales: ${adService.totalImpressions}', style: const TextStyle(fontSize: 11)),
            Text('Revenu estime: \$${adService.estimatedEarnings.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11)),
            const SizedBox(height: 4),
            ...breakdown.entries.map((e) => Text(
              '${e.key}: \$${e.value.toStringAsFixed(3)}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            )),
          ],
        ),
      ),
    );
  }

  void _showAdStats(BuildContext context) {
    final adService = context.read<AdService>();
    final breakdown = adService.revenueBreakdown;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Statistiques de monétisation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total impressions: ${adService.totalImpressions}'),
            Text('Revenu estime: \$${adService.estimatedEarnings.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            const Text('Detail par format:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...breakdown.entries.map((e) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text('${e.key}: ${e.value.toStringAsFixed(3)}\$'),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
