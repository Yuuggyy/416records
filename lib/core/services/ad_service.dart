import 'package:flutter/foundation.dart';

/// Web-compatible AdService — simulates AdMob for web deployment
/// On native (Android/iOS), this would use google_mobile_ads
/// On web, we simulate ad display with timed overlays
class AdService extends ChangeNotifier {
  bool _isPreRollLoading = false;
  bool _isInterstitialLoading = false;
  bool _isRewardedLoading = false;
  bool _isBannerLoading = false;

  int _preRollShown = 0;
  int _interstitialShown = 0;
  int _rewardedShown = 0;
  int _bannerImpressions = 0;
  double _estimatedEarnings = 0.0;

  static const double preRollEcpm = 5.0;
  static const double interstitialEcpm = 5.0;
  static const double rewardedEcpm = 15.0;
  static const double bannerEcpm = 0.5;

  Function(int)? onRewardEarned;
  Function()? onAdClosed;
  Function()? onAdFailed;

  bool get isPreRollReady => true;
  bool get isInterstitialReady => true;
  bool get isRewardedReady => true;
  bool get isBannerReady => true;

  int get preRollShown => _preRollShown;
  int get interstitialShown => _interstitialShown;
  int get rewardedShown => _rewardedShown;
  int get bannerImpressions => _bannerImpressions;
  double get estimatedEarnings => _estimatedEarnings;

  Future<void> initialize() async {
    // Simulated init — on native this would call MobileAds.instance.initialize()
    debugPrint('AdService initialized (web mode)');
  }

  Future<bool> showPreRollAd() async {
    _preRollShown++;
    _estimatedEarnings += preRollEcpm / 1000;
    notifyListeners();
    // Simulate 10s pre-roll
    await Future.delayed(const Duration(seconds: 2));
    onAdClosed?.call();
    return true;
  }

  Future<bool> showInterstitialAd() async {
    _interstitialShown++;
    _estimatedEarnings += interstitialEcpm / 1000;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    onAdClosed?.call();
    return true;
  }

  Future<bool> showRewardedAd({Function(int)? onReward}) async {
    _rewardedShown++;
    _estimatedEarnings += rewardedEcpm / 1000;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    onRewardEarned?.call(1);
    onReward?.call(1);
    onAdClosed?.call();
    return true;
  }

  int get totalImpressions =>
      _preRollShown + _interstitialShown + _rewardedShown + _bannerImpressions;

  Map<String, double> get revenueBreakdown => {
        'pre_roll': _preRollShown * preRollEcpm / 1000,
        'interstitial': _interstitialShown * interstitialEcpm / 1000,
        'rewarded': _rewardedShown * rewardedEcpm / 1000,
        'banner': _bannerImpressions * bannerEcpm / 1000,
      };

  void resetStats() {
    _preRollShown = 0;
    _interstitialShown = 0;
    _rewardedShown = 0;
    _bannerImpressions = 0;
    _estimatedEarnings = 0.0;
    notifyListeners();
  }

  void disposeAll() {}
}
